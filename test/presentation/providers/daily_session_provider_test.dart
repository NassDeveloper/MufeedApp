import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/data/datasources/shared_preferences_source.dart';
import 'package:mufeed_app/domain/models/reviewable_item_model.dart';
import 'package:mufeed_app/domain/models/session_model.dart';
import 'package:mufeed_app/domain/models/streak_model.dart';
import 'package:mufeed_app/domain/models/user_progress_model.dart';
import 'package:mufeed_app/domain/repositories/progress_repository.dart';
import 'package:mufeed_app/domain/repositories/streak_repository.dart';
import 'package:mufeed_app/presentation/providers/daily_session_provider.dart';
import 'package:mufeed_app/presentation/providers/preferences_provider.dart';
import 'package:mufeed_app/presentation/providers/srs_provider.dart';
import 'package:mufeed_app/presentation/providers/streak_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mufeed_app/domain/models/daily_activity_model.dart';
import 'package:mufeed_app/domain/models/upcoming_reviews_model.dart';

class FakeProgressRepository implements ProgressRepository {
  List<ReviewableItemModel> dueReviewableItems = [];
  List<ReviewableItemModel> lessonItems = [];
  List<({int lessonId, int totalItems, int masteredCount})>
      lessonProgressSummary = [];

  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLesson(
          int lessonId) async =>
      lessonItems;
  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLessons(List<int> lessonIds) async => [];
  @override
  Future<List<UserProgressModel>> getDueItems() async => [];
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
  Future<int> getSessionCount() async => 0;
  @override
  Future<List<UserProgressModel>> getProgressForLesson(int lessonId) async =>
      [];
  @override
  Future<int> getTotalItemCountForLesson(int lessonId) async => 0;
  @override
  Future<List<({int lessonId, int totalItems, int masteredCount})>>
      getLessonProgressSummaryForLevel(int levelId) async =>
          lessonProgressSummary;

  @override
  Future<int> getTotalWordsReviewed() async => 0;
  @override
  Future<int> getCompletedLessonCount() async => 0;
  @override
  Future<bool> hasPerfectQuiz() async => false;

  @override
  Future<List<DailyActivityModel>> getReviewActivity({int days = 14}) async => [];
  @override
  Future<UpcomingReviewsModel> getUpcomingReviews() async =>
      const UpcomingReviewsModel(dueToday: 0, dueTomorrow: 0, dueThisWeek: 0);

  @override
  Future<List<ReviewableItemModel>> getNewWordsForLevel(int levelId, int limit) =>
      Future.value([]);

  @override
  Future<({int lessonId, int totalItems, int masteredCount})>
      getLessonProgressSummary(int lessonId) =>
      Future.value((lessonId: lessonId, totalItems: 0, masteredCount: 0));
  @override
  Future<int> getNewWordsIntroducedTodayCount() => Future.value(0);

}

class FakeStreakRepository implements StreakRepository {
  DateTime? lastActivityDate;

  @override
  Future<StreakModel?> getStreak() async => null;
  @override
  Future<DateTime?> getLastActivityDate() async => lastActivityDate;
  @override
  Future<void> updateLastActivityDate(DateTime date) async {
    lastActivityDate = date;
  }

  @override
  Future<void> updateStreak(StreakModel streak) async {}
}

void main() {
  group('dailySessionProvider', () {
    test('returns resume session when absence is detected', () async {
      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      final fakeRepo = FakeProgressRepository();
      fakeRepo.dueReviewableItems = [
        const ReviewableItemModel(
          itemId: 1,
          contentType: 'vocab',
          arabic: 'كتاب',
          translationFr: 'livre',
          sortOrder: 1,
          progress: UserProgressModel(
            itemId: 1,
            contentType: 'vocab',
            state: 'review',
            lastReview: null,
          ),
        ),
        const ReviewableItemModel(
          itemId: 2,
          contentType: 'vocab',
          arabic: 'قلم',
          translationFr: 'stylo',
          sortOrder: 2,
          progress: UserProgressModel(
            itemId: 2,
            contentType: 'vocab',
            state: 'new',
            lastReview: null,
          ),
        ),
      ];

      final streakRepo = FakeStreakRepository();
      streakRepo.lastActivityDate =
          DateTime.now().subtract(const Duration(days: 5));

      final container = ProviderContainer(
        overrides: [
          progressRepositoryProvider.overrideWithValue(fakeRepo),
          sharedPreferencesSourceProvider
              .overrideWithValue(SharedPreferencesSource(prefs)),
          streakRepositoryProvider.overrideWithValue(streakRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(dailySessionProvider.future);

      // Resume session excludes 'new' items, only includes review/learning/relearning
      expect(result, hasLength(1));
      expect(result.first.itemId, 1);
    });

    test('returns normal daily session when no absence', () async {
      SharedPreferences.setMockInitialValues({
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final prefs = await SharedPreferences.getInstance();

      final fakeRepo = FakeProgressRepository();
      fakeRepo.dueReviewableItems = [
        const ReviewableItemModel(
          itemId: 1,
          contentType: 'vocab',
          arabic: 'كتاب',
          translationFr: 'livre',
          sortOrder: 1,
          progress: UserProgressModel(
            itemId: 1,
            contentType: 'vocab',
            state: 'review',
            lastReview: null,
          ),
        ),
      ];

      final streakRepo = FakeStreakRepository();
      streakRepo.lastActivityDate = DateTime.now();

      final container = ProviderContainer(
        overrides: [
          progressRepositoryProvider.overrideWithValue(fakeRepo),
          sharedPreferencesSourceProvider
              .overrideWithValue(SharedPreferencesSource(prefs)),
          streakRepositoryProvider.overrideWithValue(streakRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(dailySessionProvider.future);

      // Normal session includes due items (buildDailySession)
      expect(result, hasLength(1));
      expect(result.first.itemId, 1);
    });
  });
}
