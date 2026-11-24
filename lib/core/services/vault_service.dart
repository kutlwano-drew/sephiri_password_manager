import 'package:cryptography/cryptography.dart';
import 'package:uuid/uuid.dart';
import '../../database/app_database.dart';
import '../../models/vault_entry.dart';
import '../crypto/crypto_service.dart';

class VaultService {
  VaultService({required this.database, required this.crypto, required this.keyProvider});
  final AppDatabase database;
  final CryptoService crypto;
  final SecretKey Function() keyProvider;

  Stream<List<VaultEntryModel>> watchEntries() async* {
    await for (final rows in database.watchEntries()) {
      final result = <VaultEntryModel>[];
      for (final row in rows) {
        result.add(await _decrypt(row));
      }
      result.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      yield result;
    }
  }

  Future<VaultEntryModel> getEntry(String id) async {
    final row = (await database.allEntries()).firstWhere((e) => e.id == id);
    return _decrypt(row);
  }

  Future<void> save(VaultEntryModel model) async {
    final id = model.id ?? const Uuid().v4();
    final payload = await crypto.encryptJson({
      'title': model.title,
      'username': model.username,
      'password': model.password,
      'url': model.url,
      'notes': model.notes,
      'category': model.category,
      'tags': model.tags,
      'customFields': model.customFields,
      'locked': model.locked,
    }, keyProvider(), aad: [1]);
    await database.saveEntry(id: id, payload: payload, favorite: model.favorite);
  }

  Future<void> delete(String id) => database.deleteEntry(id);

  Future<VaultEntryModel> _decrypt(dynamic row) async {
    final data = await crypto.decryptJson(
      EncryptedPayload(bytes: row.ciphertext, nonce: row.nonce, mac: row.mac),
      keyProvider(),
      aad: [1],
    );
    return VaultEntryModel(
      id: row.id as String,
      title: data['title'] as String? ?? '',
      username: data['username'] as String? ?? '',
      password: data['password'] as String? ?? '',
      url: data['url'] as String? ?? '',
      notes: data['notes'] as String? ?? '',
      category: data['category'] as String? ?? 'Login',
      tags: List<String>.from(data['tags'] as List? ?? const []),
      favorite: row.favorite as bool,
      customFields: Map<String, String>.from(
        (data['customFields'] as Map? ?? const {}).map(
          (key, value) => MapEntry(key.toString(), value.toString()),
        ),
      ),
      locked: data['locked'] as bool? ?? false,
    );
  }
}
