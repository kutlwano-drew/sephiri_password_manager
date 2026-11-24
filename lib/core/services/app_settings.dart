import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSettings extends ChangeNotifier {
  AppSettings(this._storage);

  final FlutterSecureStorage _storage;
  int _autoLockMinutes = 5;
  bool _darkMode = false;
  List<Map<String, dynamic>> _customCategories = [];
  int _entryLockMaxAttempts = 0; // 0 means unlimited.
  int _entryLockCooldownMinutes = 15;
  int _entryLockFailures = 0;
  DateTime? _entryLockoutUntil;

  int get autoLockMinutes => _autoLockMinutes;
  bool get darkMode => _darkMode;
  List<Map<String, dynamic>> get customCategories =>
      List.unmodifiable(_customCategories);
  int get entryLockMaxAttempts => _entryLockMaxAttempts;
  int get entryLockCooldownMinutes => _entryLockCooldownMinutes;
  int get entryLockFailures => _entryLockFailures;
  DateTime? get entryLockoutUntil => _entryLockoutUntil;
  Duration get entryLockRemaining {
    final until = _entryLockoutUntil;
    if (until == null) return Duration.zero;
    final remaining = until.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }
  bool get entryUnlockBlocked => entryLockRemaining > Duration.zero;

  static Future<AppSettings> load() async {
    const storage = FlutterSecureStorage();
    final settings = AppSettings(storage);
    final lockValue = await storage.read(key: 'auto_lock_minutes');
    final darkValue = await storage.read(key: 'dark_mode');
    final categories = await storage.read(key: 'custom_categories_v1');
    final maxAttempts = await storage.read(key: 'entry_lock_max_attempts');
    final cooldown = await storage.read(key: 'entry_lock_cooldown_minutes');
    final failures = await storage.read(key: 'entry_lock_failures');
    final until = await storage.read(key: 'entry_lockout_until');
    settings._autoLockMinutes = int.tryParse(lockValue ?? '') ?? 5;
    settings._darkMode = darkValue == 'true';
    settings._entryLockMaxAttempts = int.tryParse(maxAttempts ?? '') ?? 0;
    settings._entryLockCooldownMinutes = int.tryParse(cooldown ?? '') ?? 15;
    settings._entryLockFailures = int.tryParse(failures ?? '') ?? 0;
    settings._entryLockoutUntil = DateTime.tryParse(until ?? '');
    if (categories != null) {
      try {
        settings._customCategories = (jsonDecode(categories) as List)
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      } catch (_) {
        settings._customCategories = [];
      }
    }
    if (settings.entryLockRemaining == Duration.zero) {
      settings._entryLockoutUntil = null;
      settings._entryLockFailures = 0;
    }
    return settings;
  }

  Future<void> setAutoLockMinutes(int value) async {
    _autoLockMinutes = value;
    await _storage.write(key: 'auto_lock_minutes', value: value.toString());
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    await _storage.write(key: 'dark_mode', value: value.toString());
    notifyListeners();
  }

  Future<void> saveCustomCategory(Map<String, dynamic> category) async {
    final name = (category['name'] as String).trim();
    _customCategories.removeWhere(
      (item) => (item['name'] as String).toLowerCase() == name.toLowerCase(),
    );
    _customCategories.add(Map<String, dynamic>.from(category));
    await _storage.write(
      key: 'custom_categories_v1',
      value: jsonEncode(_customCategories),
    );
    notifyListeners();
  }

  Map<String, dynamic>? customCategory(String name) {
    for (final item in _customCategories) {
      if ((item['name'] as String).toLowerCase() == name.toLowerCase()) {
        return item;
      }
    }
    return null;
  }

  Future<void> setEntryLockPolicy({
    required int maxAttempts,
    required int cooldownMinutes,
  }) async {
    _entryLockMaxAttempts = maxAttempts < 0 ? 0 : maxAttempts;
    _entryLockCooldownMinutes = cooldownMinutes.clamp(1, 1440).toInt();
    _entryLockFailures = 0;
    _entryLockoutUntil = null;
    await _storage.write(key: 'entry_lock_max_attempts', value: '$_entryLockMaxAttempts');
    await _storage.write(key: 'entry_lock_cooldown_minutes', value: '$_entryLockCooldownMinutes');
    await _storage.write(key: 'entry_lock_failures', value: '0');
    await _storage.delete(key: 'entry_lockout_until');
    notifyListeners();
  }

  Future<void> recordEntryLockFailure() async {
    if (_entryLockMaxAttempts == 0) return;
    _entryLockFailures++;
    if (_entryLockFailures >= _entryLockMaxAttempts) {
      _entryLockoutUntil = DateTime.now().add(
        Duration(minutes: _entryLockCooldownMinutes),
      );
      _entryLockFailures = 0;
      await _storage.write(
        key: 'entry_lockout_until',
        value: _entryLockoutUntil!.toIso8601String(),
      );
    }
    await _storage.write(key: 'entry_lock_failures', value: '$_entryLockFailures');
    notifyListeners();
  }

  Future<void> clearEntryLockFailures() async {
    _entryLockFailures = 0;
    _entryLockoutUntil = null;
    await _storage.write(key: 'entry_lock_failures', value: '0');
    await _storage.delete(key: 'entry_lockout_until');
    notifyListeners();
  }
}
