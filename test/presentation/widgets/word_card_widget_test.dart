import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/word_model.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/tts_provider.dart';
import 'package:mufeed_app/presentation/widgets/word_card_widget.dart';

import '../../helpers/fake_tts_notifier.dart';

void main() {
  Widget buildApp({required WordModel word, VoidCallback? onReport}) {
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
            child: WordCard(word: word, onReport: onReport),
          ),
        ),
      ),
    );
  }

  const baseWord = WordModel(
    id: 1,
    lessonId: 1,
    contentType: 'vocab',
    arabic: 'كِتَابٌ',
    translationFr: 'Livre',
    sortOrder: 1,
  );

  group('WordCard', () {
    testWidgets('displays arabic word and translation', (tester) async {
      await tester.pumpWidget(buildApp(word: baseWord));
      await tester.pumpAndSettle();

      expect(find.text('كِتَابٌ'), findsOneWidget);
      expect(find.text('Livre'), findsOneWidget);
    });

    testWidgets('shows grammatical category chip when present',
        (tester) async {
      final word = baseWord.copyWith(grammaticalCategory: 'Nom');
      await tester.pumpWidget(buildApp(word: word));
      await tester.pumpAndSettle();

      expect(find.text('Nom'), findsOneWidget);
      expect(find.byType(Chip), findsOneWidget);
    });

    testWidgets('hides grammatical category when null', (tester) async {
      await tester.pumpWidget(buildApp(word: baseWord));
      await tester.pumpAndSettle();

      expect(find.byType(Chip), findsNothing);
    });

    testWidgets('shows metadata when singular/plural present', (tester) async {
      final word = baseWord.copyWith(
        singular: 'كِتَابٌ',
        plural: 'كُتُبٌ',
      );
      await tester.pumpWidget(buildApp(word: word));
      await tester.pumpAndSettle();

      expect(find.textContaining('Singulier'), findsOneWidget);
      expect(find.textContaining('Pluriel'), findsOneWidget);
      expect(find.text('كُتُبٌ'), findsOneWidget);
    });

    testWidgets('shows synonym and antonym when present', (tester) async {
      final word = baseWord.copyWith(
        synonym: 'مُصْحَفٌ',
        antonym: 'جَهْلٌ',
      );
      await tester.pumpWidget(buildApp(word: word));
      await tester.pumpAndSettle();

      expect(find.textContaining('Synonyme'), findsOneWidget);
      expect(find.textContaining('Antonyme'), findsOneWidget);
    });

    testWidgets('hides metadata section when all fields null', (tester) async {
      await tester.pumpWidget(buildApp(word: baseWord));
      await tester.pumpAndSettle();

      expect(find.textContaining('Singulier'), findsNothing);
      expect(find.textContaining('Pluriel'), findsNothing);
      expect(find.textContaining('Synonyme'), findsNothing);
      expect(find.textContaining('Antonyme'), findsNothing);
    });

    testWidgets('shows flag button when onReport is provided',
        (tester) async {
      var reported = false;
      await tester.pumpWidget(
        buildApp(word: baseWord, onReport: () => reported = true),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.flag_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.flag_outlined));
      expect(reported, isTrue);
    });

    testWidgets('hides flag button when onReport is null', (tester) async {
      await tester.pumpWidget(buildApp(word: baseWord));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.flag_outlined), findsNothing);
    });

    testWidgets('shows TTS button next to arabic text', (tester) async {
      await tester.pumpWidget(buildApp(word: baseWord));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });
  });
}
