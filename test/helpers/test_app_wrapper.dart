import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/tts_provider.dart';

import 'fake_tts_notifier.dart';

Widget testAppWrapper({required Widget child}) {
  return ProviderScope(
    overrides: [
      ttsProvider.overrideWith(() => FakeTtsNotifier()),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 600,
          child: child,
        ),
      ),
    ),
  );
}
