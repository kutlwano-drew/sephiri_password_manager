import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cryptography/cryptography.dart';

import '../../database/app_database.dart';
import '../crypto/crypto_service.dart';

class SessionManager extends ChangeNotifier {
  SessionManager(this.database, this.crypto);
  final AppDatabase database;
  final CryptoService crypto;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  SecretKey? _vaultKey;
  bool hasVault = false;
  String? _recoveryQuestion;

  bool get isUnlocked => _vaultKey != null;
  SecretKey get vaultKey => _vaultKey!;
  bool get recoveryQuestionAvailable => _recoveryQuestion != null && _recoveryQuestion!.isNotEmpty;
  String? get recoveryQuestion => _recoveryQuestion;

  Future<void> initialize() async {
    hasVault = await database.hasVault();
    _recoveryQuestion = await _secureStorage.read(key: 'vault_recovery_question_v1');
    notifyListeners();
  }

  Future<void> createVault(String password) async {
    if (password.length < 10) {
      throw StateError('Use at least 10 characters for the master password.');
    }
    final derived = await crypto.derivePasswordKey(password);
    final verifier = await crypto.encryptString('OFFLINE_VAULT_VERIFIER_V1', derived.key);
    await database.createVaultMeta(
      salt: derived.salt,
      verifierCiphertext: verifier.bytes,
      verifierNonce: verifier.nonce,
      verifierMac: verifier.mac,
    );
    _vaultKey = derived.key;
    hasVault = true;
    // Keep the setup screen mounted until its required recovery-question dialog
    // has been completed. configureRecoveryQuestion notifies after saving it.
  }

  Future<void> unlock(String password) async {
    final meta = await database.getVaultMeta();
    if (meta == null) throw StateError('Vault metadata is missing.');
    final derived = await crypto.derivePasswordKey(password, salt: Uint8List.fromList(meta.salt));
    try {
      await crypto.decryptString(
        EncryptedPayload(
          bytes: Uint8List.fromList(meta.verifierCiphertext),
          nonce: Uint8List.fromList(meta.verifierNonce),
          mac: Uint8List.fromList(meta.verifierMac),
        ),
        derived.key,
      );
    } catch (_) {
      throw StateError('Incorrect master password.');
    }
    _vaultKey = derived.key;
    notifyListeners();
  }

  Future<bool> verifyMasterPassword(String password) async {
    final meta = await database.getVaultMeta();
    if (meta == null) return false;
    final derived = await crypto.derivePasswordKey(password, salt: Uint8List.fromList(meta.salt));
    try {
      await crypto.decryptString(
        EncryptedPayload(
          bytes: Uint8List.fromList(meta.verifierCiphertext),
          nonce: Uint8List.fromList(meta.verifierNonce),
          mac: Uint8List.fromList(meta.verifierMac),
        ),
        derived.key,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> configureRecoveryQuestion(String question, String answer) async {
    if (_vaultKey == null) throw StateError('Unlock the vault before configuring recovery.');
    final cleanQuestion = question.trim();
    final cleanAnswer = _normalizeAnswer(answer);
    if (cleanQuestion.isEmpty || cleanAnswer.length < 3) {
      throw StateError('Enter a recovery question and an answer of at least 3 characters.');
    }
    await _storeRecoveryQuestion(cleanQuestion, cleanAnswer, _vaultKey!);
    _recoveryQuestion = cleanQuestion;
    notifyListeners();
  }

  Future<void> _storeRecoveryQuestion(String question, String answer, SecretKey vaultKey) async {
    final derived = await crypto.derivePasswordKey(answer);
    final keyBytes = await vaultKey.extractBytes();
    final encrypted = await crypto.encryptString(base64Encode(keyBytes), derived.key, aad: [77, 81, 65]);
    await _secureStorage.write(key: 'vault_recovery_question_v1', value: question);
    await _secureStorage.write(key: 'vault_recovery_salt_v1', value: base64Encode(derived.salt));
    await _secureStorage.write(key: 'vault_recovery_cipher_v1', value: base64Encode(encrypted.bytes));
    await _secureStorage.write(key: 'vault_recovery_nonce_v1', value: base64Encode(encrypted.nonce));
    await _secureStorage.write(key: 'vault_recovery_mac_v1', value: base64Encode(encrypted.mac));
  }

  Future<void> resetMasterPasswordWithRecovery({
    required String question,
    required String answer,
    required String newPassword,
  }) async {
    if (newPassword.length < 10) throw StateError('Use at least 10 characters for the new master password.');
    final storedQuestion = await _secureStorage.read(key: 'vault_recovery_question_v1');
    if (storedQuestion == null || storedQuestion.trim().toLowerCase() != question.trim().toLowerCase()) {
      throw StateError('That recovery question does not match.');
    }
    final saltText = await _secureStorage.read(key: 'vault_recovery_salt_v1');
    final cipherText = await _secureStorage.read(key: 'vault_recovery_cipher_v1');
    final nonceText = await _secureStorage.read(key: 'vault_recovery_nonce_v1');
    final macText = await _secureStorage.read(key: 'vault_recovery_mac_v1');
    if ([saltText, cipherText, nonceText, macText].any((v) => v == null)) {
      throw StateError('Recovery has not been configured on this device.');
    }
    final recoveryKey = await crypto.derivePasswordKey(
      _normalizeAnswer(answer),
      salt: Uint8List.fromList(base64Decode(saltText!)),
    );
    late SecretKey oldKey;
    try {
      final clear = await crypto.decryptString(
        EncryptedPayload(
          bytes: Uint8List.fromList(base64Decode(cipherText!)),
          nonce: Uint8List.fromList(base64Decode(nonceText!)),
          mac: Uint8List.fromList(base64Decode(macText!)),
        ),
        recoveryKey.key,
        aad: [77, 81, 65],
      );
      oldKey = SecretKeyData(Uint8List.fromList(base64Decode(clear)));
    } catch (_) {
      throw StateError('The answer is incorrect.');
    }

    final newDerived = await crypto.derivePasswordKey(newPassword);
    final rows = await database.allEntries();
    final rekeyed = <VaultEntryRekey>[];
    for (final row in rows) {
      final clear = await crypto.decryptJson(
        EncryptedPayload(bytes: Uint8List.fromList(row.ciphertext), nonce: Uint8List.fromList(row.nonce), mac: Uint8List.fromList(row.mac)),
        oldKey,
        aad: [1],
      );
      final encrypted = await crypto.encryptJson(clear, newDerived.key, aad: [1]);
      rekeyed.add(VaultEntryRekey(id: row.id, payload: encrypted));
    }
    final verifier = await crypto.encryptString('OFFLINE_VAULT_VERIFIER_V1', newDerived.key);
    await database.rekeyVault(
      salt: newDerived.salt,
      verifierCiphertext: verifier.bytes,
      verifierNonce: verifier.nonce,
      verifierMac: verifier.mac,
      entries: rekeyed,
    );
    // The database is now rekeyed. Keep the new key even if secure-storage
    // needs the recovery record to be configured again.
    _vaultKey = newDerived.key;
    hasVault = true;
    try {
      await _storeRecoveryQuestion(storedQuestion, _normalizeAnswer(answer), newDerived.key);
      _recoveryQuestion = storedQuestion;
    } catch (_) {
      for (final key in [
        'vault_recovery_question_v1', 'vault_recovery_salt_v1',
        'vault_recovery_cipher_v1', 'vault_recovery_nonce_v1',
        'vault_recovery_mac_v1',
      ]) {
        await _secureStorage.delete(key: key);
      }
      _recoveryQuestion = null;
      notifyListeners();
      throw StateError('Your master password was reset, but recovery could not be saved. Set a new recovery question in Settings.');
    }
    notifyListeners();
  }

  String _normalizeAnswer(String value) => value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  void lock() {
    _vaultKey = null;
    notifyListeners();
  }
}
