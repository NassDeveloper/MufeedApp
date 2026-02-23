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
import 'package:mufeed_app/presentation/screens/exercises_screen.dart';
import 'package:mufeed_app/presentation/widgets/skeleton_loader_widget.dart';

class FakeContentRepository implements ContentRepository {
  List<LevelModel> levels = [];
  List<UnitModel> units = [];
  List<LessonModel> lessons = [];
  bool shouldThrow = false;

  @override
  Future<List<LevelModel>> getAllLevels() async {
    if (shouldThrow) throw Exception('Database error');
    return levels;
  }

  @override
  Future<List<UnitModel>> getUnitsByLevelId(int levelId) async {
    if (shouldThrow) throw Exception('Database error');
    return units;
  }

  @override
  Future<List<LessonModel>> getLessonsByUnitId(int unitId) async {
    if (shouldThrow) throw Exception('Database error');
    return lessons;
  }

  @override
  Future<List<LessonModel>> getLessonsByLevelId(int levelId) async => [];

  @override
  Future<LessonModel?> getLessonById(int lessonId) async => null;

  @override
  Future<List<WordModel>> getWordsByLessonId(int lessonId) async => [];

  @override
  Future<List<VerbModel>> getVerbsByLessonId(int lessonId) async => [];

  @override
  Future<List<SentenceExerciseModel>> getExercisesForLesson(
      int lessonId) async => [];
}

Widget _buildApp(FakeContentRepository repo) {
  return ProviderScope(
    overrides: [
      contentRepositoryProvider.overrideWithValue(repo),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('fr'),
      home: ExercisesScreen(),
    ),
  );
}

void main() {
  group('ExercisesScreen', () {
    testWidgets('shows skeleton loader while loading', (tester) async {
      final repo = FakeContentRepository();
      repo.levels = [
        const LevelModel(
          id: 1,
          number: 1,
          nameFr: 'Niveau 1',
          nameEn: 'Level 1',
          nameAr: 'المستوى 1',
          unitCount: 3,
        ),
      ];

      await tester.pumpWidget(_buildApp(repo));
      // Don't pumpAndSettle — check during loading
      expect(find.byType(SkeletonListLoader), findsOneWidget);
    });

    testWidgets('shows error state when loading fails', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            levelsProvider.overrideWith(
              (ref) async => throw Exception('DB error'),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: ExercisesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
          find.text('Erreur de chargement du contenu'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);
    });

    testWidgets('shows empty state when levels are empty', (tester) async {
      final repo = FakeContentRepository();
      repo.levels = [];

      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      expect(find.text('Aucun contenu disponible'), findsOneWidget);
    });

    testWidgets('shows level tile when levels exist', (tester) async {
      final repo = FakeContentRepository();
      repo.levels = [
        const LevelModel(
          id: 1,
          number: 1,
          nameFr: 'Niveau 1',
          nameEn: 'Level 1',
          nameAr: 'المستوى 1',
          unitCount: 3,
        ),
      ];

      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      // The level name should be visible (French locale)
      expect(find.text('Niveau 1'), findsOneWidget);
      // The level number badge should be visible
      expect(find.text('1'), findsOneWidget);
      // Should render as an ExpansionTile inside a Card
      expect(find.byType(ExpansionTile), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('shows app bar title', (tester) async {
      final repo = FakeContentRepository();

      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      expect(find.text('Exercices'), findsOneWidget);
      expect(find.text('Testez vos connaissances avec des QCM'), findsOneWidget);
    });
  });
}
