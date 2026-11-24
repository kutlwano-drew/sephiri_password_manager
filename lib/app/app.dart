
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '../core/services/app_container.dart';
import '../features/home/home_screen.dart';
import '../features/setup/setup_screen.dart';
import '../features/unlock/unlock_screen.dart';

class SephiriPasswordManager extends StatefulWidget {
  const SephiriPasswordManager({super.key, required this.container});

  final AppContainer container;

  @override
  State<SephiriPasswordManager> createState() => _SephiriPasswordManagerState();
}

class _SephiriPasswordManagerState extends State<SephiriPasswordManager>
    with WidgetsBindingObserver {
  DateTime? _backgroundedAt;
  Timer? _autoLockTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoLockTimer?.cancel();
    widget.container.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Do not lock on `inactive`: opening a file picker, system dialog, or
    // briefly switching apps can trigger it. Apply the configured timeout
    // only after the app returns from the background.
    if (state == AppLifecycleState.paused) {
      _backgroundedAt = DateTime.now();
      _autoLockTimer?.cancel();
      final minutes = widget.container.settings.autoLockMinutes;
      if (minutes > 0) {
        _autoLockTimer = Timer(
          Duration(minutes: minutes),
          widget.container.session.lock,
        );
      }
    } else if (state == AppLifecycleState.resumed) {
      final since = _backgroundedAt;
      _backgroundedAt = null;
      _autoLockTimer?.cancel();
      _autoLockTimer = null;
      final minutes = widget.container.settings.autoLockMinutes;
      if (since != null &&
          minutes > 0 &&
          DateTime.now().difference(since) >= Duration(minutes: minutes)) {
        widget.container.session.lock();
      }
    }
  }

  ThemeData _theme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF5B6CDE),
      brightness: brightness,
      surface: brightness == Brightness.light
          ? const Color(0xFFF7F8FC)
          : const Color(0xFF111522),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.black.withValues(alpha: .7),
        surfaceTintColor: Colors.transparent,
        iconColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      scaffoldBackgroundColor: scheme.surface,
      cardTheme: CardThemeData(
        elevation: 0,
        color: brightness == Brightness.light ? Colors.white : const Color(0xFF1B2232),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.light
            ? const Color(0xFFF5F6FA)
            : const Color(0xFF242C3D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.container.settings,
      builder: (context, _) {
        return MaterialApp(
          title: 'Sephiri Password Manager',
          debugShowCheckedModeBanner: false,
          theme: _theme(Brightness.light),
          darkTheme: _theme(Brightness.dark),
          themeMode: widget.container.settings.darkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          builder: (context, child) => HeroIconTheme(
            style: HeroIconStyle.outline,
            child: child ?? const SizedBox.shrink(),
          ),
          home: AnimatedBuilder(
            animation: widget.container.session,
            builder: (_, __) {
              if (!widget.container.session.hasVault) {
                return SetupScreen(container: widget.container);
              }
              if (!widget.container.session.isUnlocked) {
                return UnlockScreen(container: widget.container);
              }
              return HomeScreen(container: widget.container);
            },
          ),
        );
      },
    );
  }
}
