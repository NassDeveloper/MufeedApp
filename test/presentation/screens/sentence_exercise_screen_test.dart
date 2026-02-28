import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/lesson_model.dart';
import 'package:mufeed_app/domain/models/level_model.dart';
import 'package:mufeed_app/domain/models/sentence_exercise_model.dart';
import 'package:mufeed_app/domain/models/unit_model.dart';
import 'package:mufeed_app/domain/models/verb_model.dart';
import 'package:mufeed_app/domain/models/word_model.dart';
import 'package:mufeed_app/domain/repositories/content_repository.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/content_provider.dart';
import 'package:mufeed_app/presentation/screens/sentence_exercise_screen.dart';
import 'package:mufeed_app/presentation/widgets/skeleton_loader_widget.dart';

class FakeContentRepository implements ContentRepository {
  List<SentenceExerciseModel> exercises = [];
  bool shouldThrow = false;

  @override
  Future<List<SentenceExerciseModel>> getExercisesForLesson(
      int lessonId) async {
    if (shouldThrow) throw Exception('Error');
    return exercises;
  }

  @override
  Future<List<WordModel>> getWordsByLessonId(int lessonId) async => [];

  @override
  Future<List<VerbModel>> getVerbsByLessonId(int lessonId) async => [];

  @override
  Future<List<LevelModel>> getAllLevels() async => [];

  @override
  Future<List<UnitModel>> getUnitsByLevelId(int levelId) async => [];

  @override
  Future<List<LessonModel>> getLessonsByUnitId(int unitId) async => [];

  @override
  Future<List<LessonModel>> getLessonsByLevelId(int levelId) async => [];

  @override
  Future<LessonModel?> getLessonById(int lessonId) async => null;
}

const _exercise1 = SentenceExerciseModel(
  lessonId: 1,
  sentenceFr: "Ce n'est ___ un livre.",
  sentenceAr: '___ \u0647\u064e\u0630\u064e\u0627 \u0643\u0650\u062a\u064e\u0627\u0628\u064b\u0627',
  choices: [
    '\u0644\u064e\u064a\u0652\u0633\u064e',
    '\u0644\u064e\u0645\u0652',
    '\u0644\u064e\u0646\u0652',
    '\u0644\u0627',
  ],
  correctIndex: 0,
  explanations: [
    'Correct !',
    'Incorrect 1.',
    'Incorrect 2.',
    'Incorrect 3.',
  ],
);

const _exercise2 = SentenceExerciseModel(
  lessonId: 1,
  sentenceFr: 'Je ___ \u00e9tudiant.',
  sentenceAr:
      '\u0623\u064e\u0646\u064e\u0627 ___ \u0637\u064e\u0627\u0644\u0650\u0628\u064c',
  choices: [
    '\u0623\u064e\u0646\u064e\u0627',
    '\u0623\u064e\u0646\u062a\u064e',
    '\u0647\u064f\u0648\u064e',
    '\u0647\u0650\u064a\u064e',
  ],
  correctIndex: 0,
  explanations: [
    'Correct !',
    'Incorrect 1.',
    'Incorrect 2.',
    'Incorrect 3.',
  ],
);

Widget _buildApp(FakeContentRepository repo) {
  return ProviderScope(
    overrides: [
      contentRepositoryProvider.overrideWithValue(repo),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('fr'),
      home: SentenceExerciseScreen(lessonId: 1),
    ),
  );
}

void main() {
  group('SentenceExerciseScreen', () {
    testWidgets('shows skeleton loader while loading', (tester) async {
      final repo = FakeContentRepository();
      repo.exercises = [_exercise1, _exercise2];

      await tester.pumpWidget(_buildApp(repo));
      // Don't pumpAndSettle — check during loading
      expect(find.byType(SkeletonListLoader), findsOneWidget);
    });

    testWidgets('shows empty state when no exercises', (tester) async {
      final repo = FakeContentRepository();
      repo.exercises = [];

      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      expect(
        find.text('Aucun exercice de complétion disponible'),
        findsOneWidget,
      );
      expect(find.text('Retour'), findsOneWidget);
    });

    testWidgets('shows exercise with choices when exercises exist',
        (tester) async {
      final repo = FakeContentRepository();
      repo.exercises = [_exercise1, _exercise2];

      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      expect(find.text('Compl\u00e9tez la phrase :'), findsOneWidget);
      // 4 choice InkWells + 1 close button + 1 report button
      expect(find.byType(InkWell), findsNWidgets(6));
    });

    testWidgets('shows progress text "Question 1 / 2"', (tester) async {
      final repo = FakeContentRepository();
      repo.exercises = [_exercise1, _exercise2];

      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      expect(find.text('Question 1 / 2'), findsOneWidget);
    });

    testWidgets('shows explanation after selecting an answer', (tester) async {
      final repo = FakeContentRepository();
      repo.exercises = [_exercise1, _exercise2];

      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      // Tap the first choice (correct answer)
      await tester.tap(find.text('\u0644\u064e\u064a\u0652\u0633\u064e'));
      await tester.pump();

      expect(find.text('Correct !'), findsOneWidget);
      expect(find.text('Suivant'), findsOneWidget);
    });
  });
}
