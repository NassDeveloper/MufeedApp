import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'preferences_provider.dart';

class LocaleNotifier extends Notifier<Locale> {
  static const supportedLocales = {'fr', 'en'};
  static const _defaultLocale = Locale('fr');

  @override
  Locale build() {
    final prefs = ref.read(sharedPreferencesSourceProvider);
    final saved = prefs.getLocale();
    if (saved != null && supportedLocales.contains(saved)) {
      return Locale(saved);
    }

    final platformLocale =
        PlatformDispatcher.instance.locale;
    if (supportedLocales.contains(platformLocale.languageCode)) {
      return Locale(platformLocale.languageCode);
    }

    return _defaultLocale;
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale.languageCode)) return;
    state = locale;
    final prefs = ref.read(sharedPreferencesSourceProvider);
    await prefs.setLocale(locale.languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});
