import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/verb_model.dart';
import 'package:mufeed_app/domain/models/word_model.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/content_provider.dart';
import 'package:mufeed_app/presentation/providers/tts_provider.dart';
import 'package:mufeed_app/presentation/screens/lesson_detail_screen.dart';
import 'package:mufeed_app/presentation/widgets/verb_card_widget.dart';
import 'package:mufeed_app/presentation/widgets/word_card_widget.dart';

import '../../helpers/fake_tts_notifier.dart';

void main() {
  const lessonId = 1;

  group('LessonDetailScreen', () {
    testWidgets('shows skeleton loader while loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ttsProvider.overrideWith(() => FakeTtsNotifier()),
            wordsByLessonProvider(lessonId).overrideWith(
              (ref) => Completer<List<WordModel>>().future,
            ),
            verbsByLessonProvider(lessonId).overrideWith(
              (ref) => Completer<List<VerbModel>>().future,
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: LessonDetailScreen(
                lessonId: lessonId, lessonName: 'Leçon 1'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Card), findsWidgets);
      expect(find.text('Leçon 1'), findsOneWidget);
    });

    testWidgets('displays words and verbs sorted by sortOrder',
        (tester) async {
      final words = [
        const WordModel(
          id: 1,
          lessonId: lessonId,
          contentType: 'vocab',
          arabic: 'كِتَابٌ',
          translationFr: 'Livre',
          sortOrder: 1,
        ),
        const WordModel(
          id: 2,
          lessonId: lessonId,
          contentType: 'vocab',
          arabic: 'قَلَمٌ',
          translationFr: 'Stylo',
          sortOrder: 3,
        ),
      ];
      final verbs = [
        const VerbModel(
          id: 1,
          lessonId: lessonId,
          contentType: 'verb',
          masdar: 'كِتَابَةٌ',
          past: 'كَتَبَ',
          present: 'يَكْتُبُ',
          imperative: 'اُكْتُبْ',
          translationFr: 'Écrire',
          sortOrder: 2,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ttsProvider.overrideWith(() => FakeTtsNotifier()),
            wordsByLessonProvider(lessonId)
                .overrideWith((ref) async => words),
            verbsByLessonProvider(lessonId)
                .overrideWith((ref) async => verbs),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: LessonDetailScreen(
                lessonId: lessonId, lessonName: 'Leçon 1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WordCard), findsNWidgets(2));
      expect(find.byType(VerbCard), findsOneWidget);

      // Verify positional order: Livre (sortOrder 1) → Écrire (2) → Stylo (3)
      final livrePos = tester.getTopLeft(find.text('Livre'));
      final ecrirePos = tester.getTopLeft(find.text('Écrire'));
      final styloPos = tester.getTopLeft(find.text('Stylo'));
      expect(livrePos.dy, lessThan(ecrirePos.dy));
      expect(ecrirePos.dy, lessThan(styloPos.dy));
    });

    testWidgets('shows error state when words fail to load', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ttsProvider.overrideWith(() => FakeTtsNotifier()),
            wordsByLessonProvider(lessonId).overrideWith(
              (ref) async => throw Exception('DB error'),
            ),
            verbsByLessonProvider(lessonId)
                .overrideWith((ref) async => <VerbModel>[]),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: LessonDetailScreen(
                lessonId: lessonId, lessonName: 'Leçon 1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Erreur de chargement du contenu'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);
    });

    testWidgets('shows empty state when no vocabulary', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ttsProvider.overrideWith(() => FakeTtsNotifier()),
            wordsByLessonProvider(lessonId)
                .overrideWith((ref) async => <WordModel>[]),
            verbsByLessonProvider(lessonId)
                .overrideWith((ref) async => <VerbModel>[]),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: LessonDetailScreen(
                lessonId: lessonId, lessonName: 'Leçon 1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
          find.text('Aucun vocabulaire dans cette leçon'), findsOneWidget);
    });
  });
}
