import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/verb_model.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/tts_provider.dart';
import 'package:mufeed_app/presentation/widgets/verb_card_widget.dart';

import '../../helpers/fake_tts_notifier.dart';

void main() {
  Widget buildApp({required VerbModel verb, VoidCallback? onReport}) {
    return ProviderScope(
      overrides: [
        ttsProvider.overrideWith(() => FakeTtsNotifier()),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('fr'),
        home: Scaffold(
          body: SingleChildScrollView(
            child: VerbCard(verb: verb, onReport: onReport),
          ),
        ),
      ),
    );
  }

  const verb = VerbModel(
    id: 1,
    lessonId: 1,
    contentType: 'verb',
    masdar: 'كِتَابَةٌ',
    past: 'كَتَبَ',
    present: 'يَكْتُبُ',
    imperative: 'اُكْتُبْ',
    translationFr: 'Écrire',
    sortOrder: 1,
  );

  group('VerbCard', () {
    testWidgets('displays all 4 verb forms', (tester) async {
      await tester.pumpWidget(buildApp(verb: verb));
      await tester.pumpAndSettle();

      expect(find.text('كِتَابَةٌ'), findsOneWidget);
      expect(find.text('كَتَبَ'), findsOneWidget);
      expect(find.text('يَكْتُبُ'), findsOneWidget);
      expect(find.text('اُكْتُبْ'), findsOneWidget);
    });

    testWidgets('displays translation', (tester) async {
      await tester.pumpWidget(buildApp(verb: verb));
      await tester.pumpAndSettle();

      expect(find.text('Écrire'), findsOneWidget);
    });

    testWidgets('displays localized form labels', (tester) async {
      await tester.pumpWidget(buildApp(verb: verb));
      await tester.pumpAndSettle();

      expect(find.text('Masdar (المصدر)'), findsOneWidget);
      expect(find.text('Passé (الماضي)'), findsOneWidget);
      expect(find.text('Présent (المضارع)'), findsOneWidget);
      expect(find.text('Impératif (الأمر)'), findsOneWidget);
    });

    testWidgets('shows flag button when onReport is provided',
        (tester) async {
      var reported = false;
      await tester.pumpWidget(
        buildApp(verb: verb, onReport: () => reported = true),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.flag_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.flag_outlined));
      expect(reported, isTrue);
    });

    testWidgets('hides flag button when onReport is null', (tester) async {
      await tester.pumpWidget(buildApp(verb: verb));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.flag_outlined), findsNothing);
    });

    testWidgets('shows TTS button on masdar row', (tester) async {
      await tester.pumpWidget(buildApp(verb: verb));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });
  });
}
