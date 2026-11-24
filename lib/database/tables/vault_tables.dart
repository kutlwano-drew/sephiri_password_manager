import 'package:drift/drift.dart';

class VaultMetas extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  BlobColumn get salt => blob()();
  BlobColumn get verifierCiphertext => blob()();
  BlobColumn get verifierNonce => blob()();
  BlobColumn get verifierMac => blob()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  @override
  Set<Column> get primaryKey => {id};
}

class VaultEntries extends Table {
  TextColumn get id => text()();
  BlobColumn get ciphertext => blob()();
  BlobColumn get nonce => blob()();
  BlobColumn get mac => blob()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}
