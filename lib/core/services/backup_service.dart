import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import '../../database/app_database.dart';
import '../crypto/crypto_service.dart';
import '../errors/app_exception.dart';
import '../utils/bytes.dart';

class BackupService {
  BackupService({required this.database, required this.crypto});
  final AppDatabase database;
  final CryptoService crypto;

  Future<Uint8List> exportVault(String password) async {
    final meta = await database.getVaultMeta();
    if (meta == null) throw const InvalidBackupException();
    final entries = await database.allEntries();
    final payload = {
      'format': 'OFFLINE_VAULT',
      'version': 1,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'entries': entries.map((e) => VaultEntryBackup(id: e.id, ciphertext: e.ciphertext, nonce: e.nonce, mac: e.mac, createdAt: e.createdAt, updatedAt: e.updatedAt, favorite: e.favorite).toJson()).toList(),
    };
    final derived = await crypto.derivePasswordKey(password);
    final encrypted = await crypto.encryptJson(payload, derived.key, aad: utf8Bytes('OFFLINE_VAULT_BACKUP_V1'));
    final envelope = {
      'magic': 'OVB1',
      'version': 1,
      'kdf': {'name': 'argon2id', 'memory': 19456, 'iterations': 2, 'parallelism': 1, 'hashLength': 32},
      'salt': base64UrlEncodeBytes(derived.salt),
      'nonce': base64UrlEncodeBytes(encrypted.nonce),
      'mac': base64UrlEncodeBytes(encrypted.mac),
      'ciphertext': base64UrlEncodeBytes(encrypted.bytes),
    };
    return Uint8List.fromList(utf8.encode(jsonEncode(envelope)));
  }

  Future<int> importVault(Uint8List bytes, String password) async {
    try {
      final envelope = Map<String, dynamic>.from(jsonDecode(utf8String(bytes)) as Map);
      if (envelope['magic'] != 'OVB1' || envelope['version'] != 1) throw const InvalidBackupException();
      final salt = base64UrlDecodeBytes(envelope['salt'] as String);
      final derived = await crypto.derivePasswordKey(password, salt: salt);
      final payload = await crypto.decryptJson(
        EncryptedPayload(
          bytes: base64UrlDecodeBytes(envelope['ciphertext'] as String),
          nonce: base64UrlDecodeBytes(envelope['nonce'] as String),
          mac: base64UrlDecodeBytes(envelope['mac'] as String),
        ),
        derived.key,
        aad: utf8Bytes('OFFLINE_VAULT_BACKUP_V1'),
      );
      if (payload['format'] != 'OFFLINE_VAULT' || payload['version'] != 1) throw const InvalidBackupException();
      final entries = (payload['entries'] as List).map((e) => VaultEntryBackup.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      return database.importEntries(entries);
    } catch (e) {
      if (e is InvalidBackupException) rethrow;
      throw const InvalidBackupException();
    }
  }
}
