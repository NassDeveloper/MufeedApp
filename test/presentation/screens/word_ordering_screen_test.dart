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
import 'package:mufeed_app/presentation/screens/word_ordering_screen.dart';
import 'package:mufeed_app/presentation/widgets/skeleton_loader_widget.dart';

class FakeContentRepository implements ContentRepository {
  List<SentenceExerciseModel> exercises = [];

  @override
  Future<List<SentenceExerciseModel>> getExercisesForLesson(
          int lessonId) async =>
      exercises;

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

SentenceExerciseModel _ex3tokens() => const SentenceExerciseModel(
      lessonId: 1,
      sentenceFr: '___ المَدْرَسَةُ ؟ (Où est l\'école ?)',
      sentenceAr: '___ المَدْرَسَةُ ؟',
      choices: ['أَيْنَ', 'مَتَى'],
      correctIndex: 0,
      explanations: ['', ''],
    );

Widget _buildApp(FakeContentRepository repo) => ProviderScope(
      overrides: [
        contentRepositoryProvider.overrideWithValue(repo),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: WordOrderingScreen(lessonId: 1),
      ),
    );

void main() {
  group('WordOrderingScreen', () {
    testWidgets('shows skeleton loader while loading', (tester) async {
      final repo = FakeContentRepository();
      await tester.pumpWidget(_buildApp(repo));
      expect(find.byType(SkeletonListLoader), findsOneWidget);
    });

    testWidgets('shows empty state when no eligible sentences', (tester) async {
      final repo = FakeContentRepository()
        ..exercises = [
          const SentenceExerciseModel(
            lessonId: 1,
            sentenceFr: '___ طَالِبٌ.',
            sentenceAr: '___ طَالِبٌ.',
            choices: ['هُوَ'],
            correctIndex: 0,
            explanations: [''],
          ),
        ];
      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      expect(find.text('Aucune phrase disponible'), findsOneWidget);
    });

    testWidgets('shows French prompt when session loaded', (tester) async {
      final repo = FakeContentRepository()..exercises = [_ex3tokens()];
      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      expect(find.text("Où est l'école ?"), findsOneWidget);
    });

    testWidgets('shows word chips when session loaded', (tester) async {
      final repo = FakeContentRepository()..exercises = [_ex3tokens()];
      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      // There should be Arabic word chips visible
      // The reconstructed sentence is "أَيْنَ المَدْرَسَةُ ؟" (3 tokens)
      expect(find.text('أَيْنَ'), findsOneWidget);
    });

    testWidgets('shows close button in app bar', (tester) async {
      final repo = FakeContentRepository();
      await tester.pumpWidget(_buildApp(repo));
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}
