import 'dart:convert';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:cryptography/cryptography.dart';
import '../errors/app_exception.dart';
import '../utils/bytes.dart';

class DerivedKey {
  const DerivedKey({required this.key, required this.salt});
  final SecretKey key;
  final Uint8List salt;
}

class EncryptedPayload {
  const EncryptedPayload({required this.bytes, required this.nonce, required this.mac});
  final Uint8List bytes;
  final Uint8List nonce;
  final Uint8List mac;
}

class CryptoService {
  CryptoService({Argon2id? kdf, Cipher? cipher})
      : _kdf = kdf ?? Argon2id(memory: 19456, iterations: 2, parallelism: 1, hashLength: 32),
        _cipher = cipher ?? Xchacha20.poly1305Aead();

  final Argon2id _kdf;
  final Cipher _cipher;

  Future<DerivedKey> derivePasswordKey(String password, {Uint8List? salt}) async {
    final actualSalt = salt ?? Uint8List.fromList(List<int>.generate(16, (_) => math.Random.secure().nextInt(256)));
    final key = await _kdf.deriveKeyFromPassword(password: password, nonce: actualSalt);
    return DerivedKey(key: key, salt: actualSalt);
  }

  Future<EncryptedPayload> encryptString(String plaintext, SecretKey key, {List<int> aad = const []}) async {
    final box = await _cipher.encrypt(utf8Bytes(plaintext), secretKey: key, aad: aad);
    return EncryptedPayload(
      bytes: Uint8List.fromList(box.cipherText),
      nonce: Uint8List.fromList(box.nonce),
      mac: Uint8List.fromList(box.mac.bytes),
    );
  }

  Future<String> decryptString(EncryptedPayload payload, SecretKey key, {List<int> aad = const []}) async {
    try {
      final box = SecretBox(payload.bytes, nonce: payload.nonce, mac: Mac(payload.mac));
      final clear = await _cipher.decrypt(box, secretKey: key, aad: aad);
      return utf8String(clear);
    } catch (_) {
      throw const InvalidPasswordException();
    }
  }

  Future<EncryptedPayload> encryptJson(Object value, SecretKey key, {List<int> aad = const []}) =>
      encryptString(jsonEncode(value), key, aad: aad);

  Future<Map<String, dynamic>> decryptJson(EncryptedPayload payload, SecretKey key, {List<int> aad = const []}) async {
    final text = await decryptString(payload, key, aad: aad);
    return Map<String, dynamic>.from(jsonDecode(text) as Map);
  }
}
