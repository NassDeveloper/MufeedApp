import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/lesson_model.dart';
import 'package:mufeed_app/domain/models/level_model.dart';
import 'package:mufeed_app/domain/models/unit_model.dart';
import 'package:mufeed_app/domain/models/verb_model.dart';
import 'package:mufeed_app/domain/models/word_model.dart';
import 'package:mufeed_app/domain/repositories/content_repository.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/content_provider.dart';
import 'package:mufeed_app/presentation/providers/quiz_session_provider.dart';
import 'package:mufeed_app/presentation/screens/quiz_summary_screen.dart';
import 'package:mufeed_app/presentation/widgets/arabic_text_widget.dart';

class FakeContentRepository implements ContentRepository {
  List<WordModel> words = [];
  List<VerbModel> verbs = [];

  @override
  Future<List<WordModel>> getWordsByLessonId(int lessonId) async => words;

  @override
  Future<List<VerbModel>> getVerbsByLessonId(int lessonId) async => verbs;

  @override
  Future<List<LevelModel>> getAllLevels() async => [];

  @override
  Future<List<UnitModel>> getUnitsByLevelId(int levelId) async => [];

  @override
  Future<List<LessonModel>> getLessonsByUnitId(int unitId) async => [];

  @override
  Future<List<LessonModel>> getLessonsByLevelId(int levelId) async => [];
}

WordModel _word(int id, String arabic, String translationFr) => WordModel(
      id: id,
      lessonId: 1,
      contentType: 'vocab',
      arabic: arabic,
      translationFr: translationFr,
      sortOrder: id,
    );

Future<void> _setupSession(
  ProviderContainer container,
  FakeContentRepository repo, {
  required int correctCount,
}) async {
  final notifier = container.read(quizSessionProvider.notifier);
  await notifier.startSession(1);

  final state = container.read(quizSessionProvider)!;
  for (var i = 0; i < state.totalQuestions; i++) {
    final current = container.read(quizSessionProvider)!;
    if (i < correctCount) {
      notifier.submitAnswer(current.currentQuestion.correctAnswer);
    } else {
      final wrong = current.currentQuestion.choices
          .firstWhere((c) => c != current.currentQuestion.correctAnswer);
      notifier.submitAnswer(wrong);
    }
    notifier.nextQuestion();
  }
}

Widget _buildApp(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('fr'),
      home: QuizSummaryScreen(lessonId: 1),
    ),
  );
}

void main() {
  group('QuizSummaryScreen', () {
    late ProviderContainer container;
    late FakeContentRepository repo;

    setUp(() {
      repo = FakeContentRepository();
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];
      container = ProviderContainer(
        overrides: [
          contentRepositoryProvider.overrideWithValue(repo),
        ],
      );
    });

    tearDown(() => container.dispose());

    testWidgets('displays score', (tester) async {
      await _setupSession(container, repo, correctCount: 3);

      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      expect(find.text('3 / 4'), findsOneWidget);
    });

    testWidgets('displays title', (tester) async {
      await _setupSession(container, repo, correctCount: 4);

      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      expect(find.text('Résultat QCM'), findsOneWidget);
    });

    testWidgets('shows correct and incorrect labels', (tester) async {
      await _setupSession(container, repo, correctCount: 3);

      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      expect(find.text('Correctes'), findsOneWidget);
      expect(find.text('Incorrectes'), findsOneWidget);
    });

    testWidgets('shows missed words section when there are incorrect answers',
        (tester) async {
      await _setupSession(container, repo, correctCount: 2);

      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      expect(find.text('Mots à revoir'), findsOneWidget);
      // Should have ArabicText widgets for missed words
      expect(find.byType(ArabicText), findsWidgets);
    });

    testWidgets('does not show missed words section when all correct',
        (tester) async {
      await _setupSession(container, repo, correctCount: 4);

      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      expect(find.text('Mots à revoir'), findsNothing);
    });

    testWidgets('shows three action buttons', (tester) async {
      await _setupSession(container, repo, correctCount: 4);

      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      expect(find.text('Relancer le QCM'), findsOneWidget);
      expect(find.text('Retour au vocabulaire'), findsOneWidget);
      expect(find.text('Réviser en flashcards'), findsOneWidget);
    });

    testWidgets('has no back button in app bar', (tester) async {
      await _setupSession(container, repo, correctCount: 4);

      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      // automaticallyImplyLeading is false, so no back button
      expect(find.byType(BackButton), findsNothing);
    });
  });
}
