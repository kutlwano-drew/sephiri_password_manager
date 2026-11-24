import 'package:drift/drift.dart';
import '../app_database.dart';

class VaultDao {
  VaultDao(this.db);
  final AppDatabase db;
  Future<List<VaultEntry>> getAll() => db.allEntries();
  Stream<List<VaultEntry>> watchAll() => db.watchEntries();
}
