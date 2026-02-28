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
import 'package:mufeed_app/presentation/screens/matching_exercise_screen.dart';
import 'package:mufeed_app/presentation/widgets/skeleton_loader_widget.dart';

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
  @override
  Future<LessonModel?> getLessonById(int lessonId) async => null;
  @override
  Future<List<SentenceExerciseModel>> getExercisesForLesson(
          int lessonId) async =>
      [];
}

WordModel _word(int id, String arabic, String fr) => WordModel(
      id: id,
      lessonId: 1,
      contentType: 'vocab',
      arabic: arabic,
      translationFr: fr,
      sortOrder: id,
    );

Widget _buildApp(FakeContentRepository repo) => ProviderScope(
      overrides: [
        contentRepositoryProvider.overrideWithValue(repo),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: MatchingExerciseScreen(lessonId: 1),
      ),
    );

void main() {
  group('MatchingExerciseScreen', () {
    testWidgets('shows skeleton loader while loading', (tester) async {
      final repo = FakeContentRepository();
      await tester.pumpWidget(_buildApp(repo));
      expect(find.byType(SkeletonListLoader), findsOneWidget);
    });

    testWidgets('shows empty state when fewer than 4 words', (tester) async {
      final repo = FakeContentRepository()
        ..words = [
          _word(1, 'كتاب', 'livre'),
          _word(2, 'قلم', 'stylo'),
        ];
      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      expect(find.text('Pas assez de mots'), findsOneWidget);
    });

    testWidgets('shows two columns with words when 4+ items', (tester) async {
      final repo = FakeContentRepository()
        ..words = [
          _word(1, 'كتاب', 'livre'),
          _word(2, 'قلم', 'stylo'),
          _word(3, 'باب', 'porte'),
          _word(4, 'بيت', 'maison'),
        ];
      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      // Arabic words should be visible
      expect(find.text('كتاب'), findsOneWidget);
      // French translations should be visible
      expect(find.text('livre'), findsOneWidget);
    });

    testWidgets('shows close button in app bar', (tester) async {
      final repo = FakeContentRepository();
      await tester.pumpWidget(_buildApp(repo));
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}
