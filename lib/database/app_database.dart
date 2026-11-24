import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

import 'tables/vault_tables.dart';
import '../models/vault_entry.dart';
import '../core/crypto/crypto_service.dart';

part 'app_database.g.dart';

class VaultMetaData {
  const VaultMetaData({
    required this.salt,
    required this.verifierCiphertext,
    required this.verifierNonce,
    required this.verifierMac,
  });

  final List<int> salt;
  final List<int> verifierCiphertext;
  final List<int> verifierNonce;
  final List<int> verifierMac;
}

class VaultEntryBackup {
  const VaultEntryBackup({
    required this.id,
    required this.ciphertext,
    required this.nonce,
    required this.mac,
    required this.createdAt,
    required this.updatedAt,
    required this.favorite,
  });

  final String id;
  final List<int> ciphertext;
  final List<int> nonce;
  final List<int> mac;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool favorite;

  Map<String, dynamic> toJson() => {
    'id': id,
    'ciphertext': ciphertext,
    'nonce': nonce,
    'mac': mac,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'favorite': favorite,
  };

  factory VaultEntryBackup.fromJson(Map<String, dynamic> json) {
    return VaultEntryBackup(
      id: json['id'] as String,
      ciphertext: List<int>.from(json['ciphertext'] as List),
      nonce: List<int>.from(json['nonce'] as List),
      mac: List<int>.from(json['mac'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      favorite: json['favorite'] as bool,
    );
  }
}


class VaultEntryRekey {
  const VaultEntryRekey({required this.id, required this.payload});
  final String id;
  final EncryptedPayload payload;
}

@DriftDatabase(tables: [VaultMetas, VaultEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.defaults() : super(driftDatabase(name: 'offline_vault'));

  @override
  int get schemaVersion => 1;

  // Check whether a vault already exists.
  Future<bool> hasVault() async {
    return (await select(vaultMetas).getSingleOrNull()) != null;
  }

  // Retrieve vault metadata.
  Future<VaultMetaData?> getVaultMeta() async {
    final row = await select(vaultMetas).getSingleOrNull();

    if (row == null) return null;

    return VaultMetaData(
      salt: row.salt,
      verifierCiphertext: row.verifierCiphertext,
      verifierNonce: row.verifierNonce,
      verifierMac: row.verifierMac,
    );
  }

  // Create vault metadata.
  Future<void> createVaultMeta({
    required List<int> salt,
    required List<int> verifierCiphertext,
    required List<int> verifierNonce,
    required List<int> verifierMac,
  }) async {
    await into(vaultMetas).insert(
      VaultMetasCompanion.insert(
        salt: Uint8List.fromList(salt),
        verifierCiphertext: Uint8List.fromList(verifierCiphertext),
        verifierNonce: Uint8List.fromList(verifierNonce),
        verifierMac: Uint8List.fromList(verifierMac),
      ),
    );
  }

  Future<void> rekeyVault({
    required List<int> salt,
    required List<int> verifierCiphertext,
    required List<int> verifierNonce,
    required List<int> verifierMac,
    required List<VaultEntryRekey> entries,
  }) async {
    await transaction(() async {
      await update(vaultMetas).write(VaultMetasCompanion(
        salt: Value(Uint8List.fromList(salt)),
        verifierCiphertext: Value(Uint8List.fromList(verifierCiphertext)),
        verifierNonce: Value(Uint8List.fromList(verifierNonce)),
        verifierMac: Value(Uint8List.fromList(verifierMac)),
      ));
      final now = DateTime.now().toUtc();
      for (final entry in entries) {
        await (update(vaultEntries)..where((t) => t.id.equals(entry.id))).write(
          VaultEntriesCompanion(
            ciphertext: Value(Uint8List.fromList(entry.payload.bytes)),
            nonce: Value(Uint8List.fromList(entry.payload.nonce)),
            mac: Value(Uint8List.fromList(entry.payload.mac)),
            updatedAt: Value(now),
          ),
        );
      }
    });
  }

  // Watch all vault entries.
  Stream<List<VaultEntry>> watchEntries() {
    return select(vaultEntries).watch();
  }

  // Retrieve all vault entries.
  Future<List<VaultEntry>> allEntries() {
    return select(vaultEntries).get();
  }

  // Save or update an encrypted vault entry.
  Future<void> saveEntry({
    required String id,
    required EncryptedPayload payload,
    required bool favorite,
    DateTime? createdAt,
  }) async {
    final now = DateTime.now().toUtc();

    await into(vaultEntries).insertOnConflictUpdate(
      VaultEntriesCompanion.insert(
        id: id,
        ciphertext: Uint8List.fromList(payload.bytes),
        nonce: Uint8List.fromList(payload.nonce),
        mac: Uint8List.fromList(payload.mac),
        createdAt: createdAt ?? now,
        updatedAt: now,
        favorite: Value(favorite),
      ),
    );
  }

  // Delete an entry by ID.
  Future<void> deleteEntry(String id) async {
    await (delete(vaultEntries)..where((t) => t.id.equals(id))).go();
  }

  // Import encrypted entries in a single transaction.
  Future<int> importEntries(List<VaultEntryBackup> entries) async {
    var count = 0;

    await transaction(() async {
      for (final entry in entries) {
        await into(vaultEntries).insertOnConflictUpdate(
          VaultEntriesCompanion.insert(
            id: entry.id,
            ciphertext: Uint8List.fromList(entry.ciphertext),
            nonce: Uint8List.fromList(entry.nonce),
            mac: Uint8List.fromList(entry.mac),
            createdAt: entry.createdAt,
            updatedAt: entry.updatedAt,
            favorite: Value(entry.favorite),
          ),
        );

        count++;
      }
    });

    return count;
  }

  // Generate a unique entry ID.
  Future<String> newEntryId() async {
    return const Uuid().v4();
  }
}
