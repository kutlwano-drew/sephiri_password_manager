
import '../../database/app_database.dart';
import '../crypto/crypto_service.dart';
import '../security/session_manager.dart';
import 'app_settings.dart';
import 'backup_service.dart';
import 'clipboard_service.dart';
import 'password_generator_service.dart';

class AppContainer {
  AppContainer._(
    this.database,
    this.crypto,
    this.session,
    this.backup,
    this.clipboard,
    this.generator,
    this.settings,
  );

  final AppDatabase database;
  final CryptoService crypto;
  final SessionManager session;
  final BackupService backup;
  final ClipboardService clipboard;
  final PasswordGeneratorService generator;
  final AppSettings settings;

  static Future<AppContainer> create() async {
    final database = AppDatabase.defaults();
    final crypto = CryptoService();
    final session = SessionManager(database, crypto);
    final settings = await AppSettings.load();
    await session.initialize();

    return AppContainer._(
      database,
      crypto,
      session,
      BackupService(database: database, crypto: crypto),
      ClipboardService(),
      PasswordGeneratorService(),
      settings,
    );
  }

  void dispose() {
    session.dispose();
    settings.dispose();
    clipboard.dispose();
    database.close();
  }
}
