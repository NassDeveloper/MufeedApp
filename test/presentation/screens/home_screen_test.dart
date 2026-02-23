import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/data/datasources/shared_preferences_source.dart';
import 'package:mufeed_app/domain/models/lesson_model.dart';
import 'package:mufeed_app/domain/models/level_model.dart';
import 'package:mufeed_app/domain/models/reviewable_item_model.dart';
import 'package:mufeed_app/domain/models/session_model.dart';
import 'package:mufeed_app/domain/models/unit_model.dart';
import 'package:mufeed_app/domain/models/user_progress_model.dart';
import 'package:mufeed_app/domain/models/verb_model.dart';
import 'package:mufeed_app/domain/models/word_model.dart';
import 'package:mufeed_app/domain/models/streak_model.dart';
import 'package:mufeed_app/domain/models/sentence_exercise_model.dart';
import 'package:mufeed_app/domain/repositories/content_repository.dart';
import 'package:mufeed_app/domain/repositories/progress_repository.dart';
import 'package:mufeed_app/domain/repositories/streak_repository.dart';
import 'package:mufeed_app/domain/services/notification_service.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/content_provider.dart';
import 'package:mufeed_app/presentation/providers/notification_provider.dart';
import 'package:mufeed_app/presentation/providers/preferences_provider.dart';
import 'package:mufeed_app/presentation/providers/srs_provider.dart';
import 'package:mufeed_app/presentation/providers/streak_provider.dart';
import 'package:mufeed_app/presentation/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeProgressRepository implements ProgressRepository {
  List<({int lessonId, int totalItems, int masteredCount})>
      lessonProgressSummary = [];
  List<UserProgressModel> dueItems = [];
  List<ReviewableItemModel> dueReviewableItems = [];
  int sessionCount = 0;

  @override
  Future<List<({int lessonId, int totalItems, int masteredCount})>>
      getLessonProgressSummaryForLevel(int levelId) async =>
          lessonProgressSummary;
  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLesson(
          int lessonId) async =>
      [];
  @override
  Future<List<UserProgressModel>> getDueItems() async => dueItems;
  @override
  Future<List<ReviewableItemModel>> getDueReviewableItems() async =>
      dueReviewableItems;
  @override
  Future<UserProgressModel?> getProgressForItem(
          int itemId, String contentType) async =>
      null;
  @override
  Future<void> saveProgress(UserProgressModel progress) async {}
  @override
  Future<int> createSession(SessionModel session) async => 1;
  @override
  Future<Map<String, int>> getProgressCountsByState() async => {};
  @override
  Future<Map<String, Map<String, int>>> getProgressCountsByStateAndType() async => {};
  @override
  Future<int> getTotalWordCount() async => 0;
  @override
  Future<int> getTotalVerbCount() async => 0;
  @override
  Future<int> getTotalItemCount() async => 0;
  @override
  Future<int> getSessionCount() async => sessionCount;
  @override
  Future<List<UserProgressModel>> getProgressForLesson(int lessonId) async =>
      [];
  @override
  Future<int> getTotalItemCountForLesson(int lessonId) async => 0;

  @override
  Future<int> getTotalWordsReviewed() async => 0;
  @override
  Future<int> getCompletedLessonCount() async => 0;
  @override
  Future<bool> hasPerfectQuiz() async => false;
}

class FakeContentRepository implements ContentRepository {
  List<LevelModel> levels = [];
  List<LessonModel> lessonsByLevel = [];

  @override
  Future<List<LevelModel>> getAllLevels() async => levels;
  @override
  Future<List<UnitModel>> getUnitsByLevelId(int levelId) async => [];
  @override
  Future<List<LessonModel>> getLessonsByUnitId(int unitId) async => [];
  @override
  Future<List<WordModel>> getWordsByLessonId(int lessonId) async => [];
  @override
  Future<List<VerbModel>> getVerbsByLessonId(int lessonId) async => [];
  @override
  Future<List<LessonModel>> getLessonsByLevelId(int levelId) async =>
      lessonsByLevel;
  @override
  Future<LessonModel?> getLessonById(int lessonId) async => null;
  @override
  Future<List<SentenceExerciseModel>> getExercisesForLesson(int lessonId) async => [];
}

class FakeNotificationService implements NotificationService {
  @override
  Future<void> initialize() async {}
  @override
  Future<bool> requestPermission() async => true;
  @override
  Future<void> scheduleDailyReminder({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {}
  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {}
  @override
  Future<void> cancelNotification(int id) async {}
  @override
  Future<void> cancelAll() async {}
}

class FakeStreakRepository implements StreakRepository {
  DateTime? lastActivityDate;
  StreakModel? streakData;

  @override
  Future<StreakModel?> getStreak() async => streakData;
  @override
  Future<DateTime?> getLastActivityDate() async => lastActivityDate;
  @override
  Future<void> updateLastActivityDate(DateTime date) async {
    lastActivityDate = date;
  }

  @override
  Future<void> updateStreak(StreakModel streak) async {
    streakData = streak;
  }
}

Widget _buildApp({
  required SharedPreferencesSource prefsSource,
  FakeProgressRepository? progressRepo,
  FakeContentRepository? contentRepo,
  FakeStreakRepository? streakRepo,
  DateTime Function()? clock,
}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesSourceProvider.overrideWithValue(prefsSource),
      progressRepositoryProvider
          .overrideWithValue(progressRepo ?? FakeProgressRepository()),
      contentRepositoryProvider
          .overrideWithValue(contentRepo ?? FakeContentRepository()),
      streakRepositoryProvider
          .overrideWithValue(streakRepo ?? FakeStreakRepository()),
      notificationServiceProvider
          .overrideWithValue(FakeNotificationService()),
      if (clock != null) clockProvider.overrideWithValue(clock),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('fr'),
      home: HomeScreen(),
    ),
  );
}

void main() {
  group('HomeScreen', () {
    testWidgets('shows welcome message', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
          _buildApp(prefsSource: SharedPreferencesSource(prefs)));
      await tester.pumpAndSettle();

      expect(find.text('Bon retour !'), findsOneWidget);
    });

    testWidgets('shows settings button in app bar', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
          _buildApp(prefsSource: SharedPreferencesSource(prefs)));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    });

    testWidgets('shows mode info section', (tester) async {
      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 2,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
          _buildApp(prefsSource: SharedPreferencesSource(prefs)));
      await tester.pumpAndSettle();

      expect(find.text('Mode : Cursus'), findsOneWidget);
    });

    testWidgets('does not show resume card when no last visited lesson',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
          _buildApp(prefsSource: SharedPreferencesSource(prefs)));
      await tester.pumpAndSettle();

      expect(find.text('Dernière leçon consultée'), findsNothing);
      expect(find.text('Reprendre'), findsNothing);
    });

    testWidgets('shows resume card in curriculum mode', (tester) async {
      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'last_visited_lesson_id': 42,
        'last_visited_lesson_name': 'Les salutations',
        'last_visited_lesson_route': '/vocabulary/level/1/unit/1/lesson/42',
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
          _buildApp(prefsSource: SharedPreferencesSource(prefs)));
      await tester.pumpAndSettle();

      expect(find.text('Dernière leçon consultée'), findsOneWidget);
      expect(find.text('Les salutations'), findsOneWidget);
      expect(find.text('Reprendre'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('shows next level card when all mastered in autodidact',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'learning_mode': 'autodidact',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();
      final contentRepo = FakeContentRepository();
      contentRepo.levels = [
        const LevelModel(id: 1, number: 1, nameFr: 'Niveau 1', nameEn: 'Level 1', nameAr: 'م1', unitCount: 1),
        const LevelModel(id: 2, number: 2, nameFr: 'Niveau 2', nameEn: 'Level 2', nameAr: 'م2', unitCount: 1),
      ];

      await tester.pumpWidget(
          _buildApp(
            prefsSource: SharedPreferencesSource(prefs),
            contentRepo: contentRepo,
          ));
      await tester.pumpAndSettle();

      expect(find.text('Prêt pour le niveau suivant ?'), findsOneWidget);
    });

    testWidgets(
        'shows suggested lesson card with real name in autodidact mode',
        (tester) async {
      final progressRepo = FakeProgressRepository();
      progressRepo.lessonProgressSummary = [
        (lessonId: 1, totalItems: 10, masteredCount: 10),
        (lessonId: 2, totalItems: 10, masteredCount: 5),
        (lessonId: 3, totalItems: 10, masteredCount: 0),
      ];

      final contentRepo = FakeContentRepository();
      contentRepo.lessonsByLevel = [
        const LessonModel(
            id: 1, unitId: 1, number: 1, nameFr: 'Les salutations', nameEn: 'Greetings'),
        const LessonModel(
            id: 2, unitId: 1, number: 2, nameFr: 'La famille', nameEn: 'Family'),
        const LessonModel(
            id: 3, unitId: 2, number: 1, nameFr: 'Les couleurs', nameEn: 'Colors'),
      ];

      SharedPreferences.setMockInitialValues({
        'learning_mode': 'autodidact',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(_buildApp(
        prefsSource: SharedPreferencesSource(prefs),
        progressRepo: progressRepo,
        contentRepo: contentRepo,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Leçon suggérée'), findsOneWidget);
      expect(find.text('La famille'), findsOneWidget);
      expect(find.text('Continuer'), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
    });

    testWidgets('shows daily session CTA when due items exist',
        (tester) async {
      final progressRepo = FakeProgressRepository();
      progressRepo.dueItems = [
        const UserProgressModel(
          itemId: 1,
          contentType: 'vocab',
          state: 'review',
          nextReview: null,
        ),
        const UserProgressModel(
          itemId: 2,
          contentType: 'vocab',
          state: 'review',
          nextReview: null,
        ),
        const UserProgressModel(
          itemId: 3,
          contentType: 'vocab',
          state: 'learning',
          nextReview: null,
        ),
      ];

      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(_buildApp(
        prefsSource: SharedPreferencesSource(prefs),
        progressRepo: progressRepo,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Session du jour'), findsOneWidget);
      expect(find.text('3 mots à réviser'), findsOneWidget);
      expect(find.text('Lancer la session'), findsOneWidget);
    });

    testWidgets('shows all reviewed card when no due items and has history',
        (tester) async {
      final progressRepo = FakeProgressRepository();
      progressRepo.sessionCount = 1;

      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(_buildApp(
        prefsSource: SharedPreferencesSource(prefs),
        progressRepo: progressRepo,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Tout est révisé !'), findsOneWidget);
      expect(find.text('Explorer le contenu'), findsOneWidget);
      expect(find.text('Faire un QCM'), findsOneWidget);
    });

    testWidgets('does not show all reviewed card for new user with no history',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
          _buildApp(prefsSource: SharedPreferencesSource(prefs)));
      await tester.pumpAndSettle();

      expect(find.text('Tout est révisé !'), findsNothing);
    });

    testWidgets('shows autodidact mode info', (tester) async {
      SharedPreferences.setMockInitialValues({
        'learning_mode': 'autodidact',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
          _buildApp(prefsSource: SharedPreferencesSource(prefs)));
      await tester.pumpAndSettle();

      expect(find.text('Mode : Autodidacte'), findsOneWidget);
    });

    testWidgets('shows resume session card when absence detected',
        (tester) async {
      final streakRepo = FakeStreakRepository();
      // Last activity 5 days ago → absence detected
      streakRepo.lastActivityDate =
          DateTime.now().subtract(const Duration(days: 5));

      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(_buildApp(
        prefsSource: SharedPreferencesSource(prefs),
        streakRepo: streakRepo,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Bon retour !'), findsWidgets);
      expect(find.text('Reprenons en douceur avec quelques mots'),
          findsOneWidget);
      expect(find.text('Reprendre'), findsOneWidget);
      expect(find.text('Pas maintenant'), findsOneWidget);
      expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
    });

    testWidgets('dismiss resume card shows normal HomeScreen',
        (tester) async {
      final streakRepo = FakeStreakRepository();
      streakRepo.lastActivityDate =
          DateTime.now().subtract(const Duration(days: 5));

      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(_buildApp(
        prefsSource: SharedPreferencesSource(prefs),
        streakRepo: streakRepo,
      ));
      await tester.pumpAndSettle();

      // Resume card is visible
      expect(find.text('Pas maintenant'), findsOneWidget);

      // Tap dismiss
      await tester.tap(find.text('Pas maintenant'));
      await tester.pumpAndSettle();

      // Resume card dismissed
      expect(
          find.text('Reprenons en douceur avec quelques mots'), findsNothing);
    });

    testWidgets('does not show resume card when no absence', (tester) async {
      final streakRepo = FakeStreakRepository();
      // Last activity today → no absence
      streakRepo.lastActivityDate = DateTime.now();

      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(_buildApp(
        prefsSource: SharedPreferencesSource(prefs),
        streakRepo: streakRepo,
      ));
      await tester.pumpAndSettle();

      expect(
          find.text('Reprenons en douceur avec quelques mots'), findsNothing);
    });

    testWidgets('shows streak section with active streak', (tester) async {
      final now = DateTime(2026, 2, 22);
      final streakRepo = FakeStreakRepository();
      streakRepo.lastActivityDate = DateTime(2026, 2, 21);
      streakRepo.streakData = StreakModel(
        id: 1,
        currentStreak: 5,
        longestStreak: 10,
        lastActivityDate: DateTime(2026, 2, 21),
        freezeAvailable: true,
      );

      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(_buildApp(
        prefsSource: SharedPreferencesSource(prefs),
        streakRepo: streakRepo,
        clock: () => now,
      ));
      await tester.pumpAndSettle();

      // Streak incremented: 5 → 6
      expect(find.text('6 jours de suite !'), findsOneWidget);
      expect(find.text('Record : 10 jours'), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    });

    testWidgets('shows streak broken card when streak resets', (tester) async {
      final now = DateTime(2026, 2, 22);
      final streakRepo = FakeStreakRepository();
      streakRepo.lastActivityDate = DateTime(2026, 2, 19);
      streakRepo.streakData = StreakModel(
        id: 1,
        currentStreak: 5,
        longestStreak: 10,
        lastActivityDate: DateTime(2026, 2, 19), // 3 days ago → reset
        freezeAvailable: false,
        freezeUsedDate: DateTime(2026, 2, 18),
      );

      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(_buildApp(
        prefsSource: SharedPreferencesSource(prefs),
        streakRepo: streakRepo,
        clock: () => now,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Série interrompue'), findsOneWidget);
      expect(
        find.text("Ce n'est pas grave, l'important c'est de reprendre !"),
        findsOneWidget,
      );
      expect(find.text("C'est reparti"), findsOneWidget);
    });

    testWidgets('dismiss streak broken card shows streak display',
        (tester) async {
      final now = DateTime(2026, 2, 22);
      final streakRepo = FakeStreakRepository();
      streakRepo.lastActivityDate = DateTime(2026, 2, 19);
      streakRepo.streakData = StreakModel(
        id: 1,
        currentStreak: 5,
        longestStreak: 10,
        lastActivityDate: DateTime(2026, 2, 19),
        freezeAvailable: false,
        freezeUsedDate: DateTime(2026, 2, 18),
      );

      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(_buildApp(
        prefsSource: SharedPreferencesSource(prefs),
        streakRepo: streakRepo,
        clock: () => now,
      ));
      await tester.pumpAndSettle();

      // Tap dismiss
      await tester.tap(find.text("C'est reparti"));
      await tester.pumpAndSettle();

      // Broken card dismissed, shows encouragement (streak = 0)
      expect(find.text('Série interrompue'), findsNothing);
      expect(
        find.text('Commencez une session pour lancer votre série !'),
        findsOneWidget,
      );
    });

    testWidgets('shows encouragement when streak is 0', (tester) async {
      final now = DateTime(2026, 2, 22);
      final streakRepo = FakeStreakRepository();
      streakRepo.lastActivityDate = DateTime(2026, 2, 22);
      streakRepo.streakData = StreakModel(
        id: 1,
        currentStreak: 0,
        longestStreak: 0,
        lastActivityDate: DateTime(2026, 2, 22),
        freezeAvailable: true,
      );

      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(_buildApp(
        prefsSource: SharedPreferencesSource(prefs),
        streakRepo: streakRepo,
        clock: () => now,
      ));
      await tester.pumpAndSettle();

      expect(
        find.text('Commencez une session pour lancer votre série !'),
        findsOneWidget,
      );
    });

    testWidgets('shows freeze used snackbar', (tester) async {
      final now = DateTime(2026, 2, 22);
      final streakRepo = FakeStreakRepository();
      streakRepo.lastActivityDate = DateTime(2026, 2, 20);
      streakRepo.streakData = StreakModel(
        id: 1,
        currentStreak: 5,
        longestStreak: 10,
        lastActivityDate: DateTime(2026, 2, 20), // 2 days ago → freeze
        freezeAvailable: true,
      );

      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(_buildApp(
        prefsSource: SharedPreferencesSource(prefs),
        streakRepo: streakRepo,
        clock: () => now,
      ));
      await tester.pumpAndSettle();

      expect(
        find.text('Votre gel de série a été utilisé ! Série préservée.'),
        findsOneWidget,
      );
    });
  });
}
