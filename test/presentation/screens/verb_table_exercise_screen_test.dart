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
import 'package:mufeed_app/presentation/screens/verb_table_exercise_screen.dart';
import 'package:mufeed_app/presentation/widgets/skeleton_loader_widget.dart';

class FakeContentRepository implements ContentRepository {
  List<VerbModel> verbs = [];
  bool shouldThrow = false;

  @override
  Future<List<VerbModel>> getVerbsByLessonId(int lessonId) async {
    if (shouldThrow) throw Exception('Error');
    return verbs;
  }

  @override
  Future<List<WordModel>> getWordsByLessonId(int lessonId) async => [];

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
      int lessonId) async => [];
}

VerbModel _verb(int id, String masdar, String past, String present,
        String imperative, String fr) =>
    VerbModel(
      id: id,
      lessonId: 1,
      contentType: 'verb',
      masdar: masdar,
      past: past,
      present: present,
      imperative: imperative,
      translationFr: fr,
      sortOrder: id,
    );

final _testVerbs = [
  _verb(1, 'كِتَابَة', 'كَتَبَ', 'يَكْتُبُ', 'اُكْتُبْ', 'écrire'),
  _verb(2, 'قِرَاءَة', 'قَرَأَ', 'يَقْرَأُ', 'اِقْرَأْ', 'lire'),
  _verb(3, 'ذَهَاب', 'ذَهَبَ', 'يَذْهَبُ', 'اِذْهَبْ', 'aller'),
];

Widget _buildApp(FakeContentRepository repo) {
  return ProviderScope(
    overrides: [
      contentRepositoryProvider.overrideWithValue(repo),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('fr'),
      home: VerbTableExerciseScreen(lessonId: 1),
    ),
  );
}

void main() {
  group('VerbTableExerciseScreen', () {
    testWidgets('shows loading skeleton initially', (tester) async {
      final repo = FakeContentRepository();
      repo.verbs = List.of(_testVerbs);

      await tester.pumpWidget(_buildApp(repo));
      // Don't pumpAndSettle — check during loading
      expect(find.byType(SkeletonListLoader), findsOneWidget);
    });

    testWidgets('shows empty state when fewer than 2 verbs', (tester) async {
      final repo = FakeContentRepository();
      repo.verbs = [
        _verb(1, 'كِتَابَة', 'كَتَبَ', 'يَكْتُبُ', 'اُكْتُبْ', 'écrire'),
      ];

      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      expect(
          find.text('Pas assez de verbes pour cet exercice'), findsOneWidget);
      expect(find.text('Retour'), findsOneWidget);
    });

    testWidgets('shows table with verb data when verbs exist', (tester) async {
      final repo = FakeContentRepository();
      repo.verbs = List.of(_testVerbs);

      await tester.pumpWidget(_buildApp(repo));
      // Use pump() instead of pumpAndSettle() because the pulsing "?"
      // animation never settles.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Translation text should be visible in the table
      final ecrireFinder = find.text('écrire');
      final lireFinder = find.text('lire');
      expect(
        ecrireFinder.evaluate().isNotEmpty || lireFinder.evaluate().isNotEmpty,
        isTrue,
        reason: 'Expected to find at least one verb translation in the table',
      );
    });

    testWidgets('shows app bar title "Tableau de conjugaison"', (tester) async {
      final repo = FakeContentRepository();
      repo.verbs = List.of(_testVerbs);

      await tester.pumpWidget(_buildApp(repo));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Tableau de conjugaison'), findsOneWidget);
    });

    testWidgets('shows "?" text for hidden cells', (tester) async {
      final repo = FakeContentRepository();
      repo.verbs = List.of(_testVerbs);

      await tester.pumpWidget(_buildApp(repo));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Hidden cells are displayed as "?"
      expect(find.text('?'), findsWidgets);
    });

    testWidgets('shows close button', (tester) async {
      final repo = FakeContentRepository();
      repo.verbs = List.of(_testVerbs);

      await tester.pumpWidget(_buildApp(repo));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}
