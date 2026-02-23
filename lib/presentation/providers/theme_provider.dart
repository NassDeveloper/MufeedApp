import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'preferences_provider.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _dark = 'dark';
  static const _light = 'light';
  static const _system = 'system';

  @override
  ThemeMode build() {
    final prefs = ref.read(sharedPreferencesSourceProvider);
    final saved = prefs.getThemeMode();
    return _fromString(saved);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = ref.read(sharedPreferencesSourceProvider);
    await prefs.setThemeMode(_toString(mode));
  }

  static ThemeMode _fromString(String? value) {
    return switch (value) {
      _light => ThemeMode.light,
      _system => ThemeMode.system,
      _ => ThemeMode.dark,
    };
  }

  static String _toString(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => _light,
      ThemeMode.system => _system,
      ThemeMode.dark => _dark,
    };
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
