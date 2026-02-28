import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/daily_activity_model.dart';
import 'package:mufeed_app/domain/models/lesson_progress_model.dart';
import 'package:mufeed_app/domain/models/progress_stats_model.dart';
import 'package:mufeed_app/domain/models/reviewable_item_model.dart';
import 'package:mufeed_app/domain/models/session_model.dart';
import 'package:mufeed_app/domain/models/upcoming_reviews_model.dart';
import 'package:mufeed_app/domain/models/user_progress_model.dart';
import 'package:mufeed_app/domain/repositories/progress_repository.dart';
import 'package:mufeed_app/presentation/providers/progress_provider.dart';
import 'package:mufeed_app/presentation/providers/srs_provider.dart';

class FakeProgressRepository implements ProgressRepository {
  Map<String, int> stateCounts = {};
  Map<String, Map<String, int>> stateByType = {};
  int totalItemCount = 0;
  int totalWordCount = 0;
  int totalVerbCount = 0;
  int sessionCount = 0;
  List<UserProgressModel> lessonProgress = [];
  int lessonItemCount = 0;

  @override
  Future<Map<String, int>> getProgressCountsByState() async => stateCounts;

  @override
  Future<Map<String, Map<String, int>>> getProgressCountsByStateAndType() async => stateByType;

  @override
  Future<int> getTotalWordCount() async => totalWordCount;

  @override
  Future<int> getTotalVerbCount() async => totalVerbCount;

  @override
  Future<int> getTotalItemCount() async => totalItemCount;

  @override
  Future<int> getSessionCount() async => sessionCount;

  @override
  Future<List<UserProgressModel>> getProgressForLesson(int lessonId) async =>
      lessonProgress;

  @override
  Future<int> getTotalItemCountForLesson(int lessonId) async =>
      lessonItemCount;

  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLesson(
          int lessonId) async =>
      [];

  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLessons(List<int> lessonIds) async => [];

  @override
  Future<List<UserProgressModel>> getDueItems() async => [];
  @override
  Future<List<ReviewableItemModel>> getDueReviewableItems() async => [];

  @override
  Future<UserProgressModel?> getProgressForItem(
          int itemId, String contentType) async =>
      null;

  @override
  Future<void> saveProgress(UserProgressModel progress) async {}

  @override
  Future<int> createSession(SessionModel session) async => 1;

  @override
  Future<List<({int lessonId, int totalItems, int masteredCount})>>
      getLessonProgressSummaryForLevel(int levelId) async => [];

  @override
  Future<int> getTotalWordsReviewed() async => 0;
  @override
  Future<int> getCompletedLessonCount() async => 0;
  @override
  Future<bool> hasPerfectQuiz() async => false;

  List<DailyActivityModel> activityData = [];
  UpcomingReviewsModel upcomingData = const UpcomingReviewsModel(
    dueToday: 0,
    dueTomorrow: 0,
    dueThisWeek: 0,
  );

  @override
  Future<List<DailyActivityModel>> getReviewActivity({int days = 14}) async =>
      activityData;

  @override
  Future<UpcomingReviewsModel> getUpcomingReviews() async => upcomingData;
}

void main() {
  group('progressStatsProvider', () {
    late ProviderContainer container;
    late FakeProgressRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeProgressRepository();
      container = ProviderContainer(
        overrides: [
          progressRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('computes newCount correctly excluding tracked non-new states', () async {
      fakeRepo.totalItemCount = 100;
      fakeRepo.stateCounts = {
        'new': 10,
        'learning': 15,
        'review': 20,
        'relearning': 5,
      };
      fakeRepo.sessionCount = 3;

      final stats = await container.read(progressStatsProvider.future);

      // newCount = totalItems - (learning + review + relearning) = 100 - 40 = 60
      // The 10 'new' state records in DB are included in newCount
      expect(stats, isA<ProgressStatsModel>());
      expect(stats.totalItems, 100);
      expect(stats.newCount, 60);
      expect(stats.learningCount, 15);
      expect(stats.reviewCount, 20);
      expect(stats.relearningCount, 5);
      expect(stats.sessionCount, 3);
    });

    test('newCount equals totalItems when no progress exists', () async {
      fakeRepo.totalItemCount = 50;
      fakeRepo.stateCounts = {};
      fakeRepo.sessionCount = 0;

      final stats = await container.read(progressStatsProvider.future);

      expect(stats.newCount, 50);
      expect(stats.learningCount, 0);
      expect(stats.reviewCount, 0);
      expect(stats.relearningCount, 0);
    });
  });

  group('lessonProgressProvider', () {
    late ProviderContainer container;
    late FakeProgressRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeProgressRepository();
      container = ProviderContainer(
        overrides: [
          progressRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('computes mastered count from review state', () async {
      fakeRepo.lessonItemCount = 20;
      fakeRepo.lessonProgress = [
        const UserProgressModel(itemId: 1, contentType: 'vocab', state: 'review'),
        const UserProgressModel(itemId: 2, contentType: 'vocab', state: 'learning'),
        const UserProgressModel(itemId: 3, contentType: 'vocab', state: 'review'),
        const UserProgressModel(itemId: 4, contentType: 'verb', state: 'relearning'),
      ];

      final progress =
          await container.read(lessonProgressProvider(1).future);

      expect(progress, isA<LessonProgressModel>());
      expect(progress.totalItems, 20);
      expect(progress.masteredCount, 2);
    });

    test('returns zero mastered when no progress', () async {
      fakeRepo.lessonItemCount = 10;
      fakeRepo.lessonProgress = [];

      final progress =
          await container.read(lessonProgressProvider(1).future);

      expect(progress.totalItems, 10);
      expect(progress.masteredCount, 0);
    });
  });

  group('recentActivityProvider', () {
    late ProviderContainer container;
    late FakeProgressRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeProgressRepository();
      container = ProviderContainer(
        overrides: [
          progressRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('returns activity data from repository', () async {
      final today = DateTime.now();
      fakeRepo.activityData = [
        DailyActivityModel(date: today, count: 5),
        DailyActivityModel(
            date: today.subtract(const Duration(days: 1)), count: 3),
      ];

      final data = await container.read(recentActivityProvider.future);

      expect(data, hasLength(2));
      expect(data.first.count, 5);
    });

    test('returns empty list when no activity', () async {
      fakeRepo.activityData = [];

      final data = await container.read(recentActivityProvider.future);

      expect(data, isEmpty);
    });
  });

  group('upcomingReviewsProvider', () {
    late ProviderContainer container;
    late FakeProgressRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeProgressRepository();
      container = ProviderContainer(
        overrides: [
          progressRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('returns upcoming reviews from repository', () async {
      fakeRepo.upcomingData = const UpcomingReviewsModel(
        dueToday: 10,
        dueTomorrow: 5,
        dueThisWeek: 25,
      );

      final data = await container.read(upcomingReviewsProvider.future);

      expect(data.dueToday, 10);
      expect(data.dueTomorrow, 5);
      expect(data.dueThisWeek, 25);
    });

    test('returns zeros when no reviews pending', () async {
      final data = await container.read(upcomingReviewsProvider.future);

      expect(data.dueToday, 0);
      expect(data.dueTomorrow, 0);
      expect(data.dueThisWeek, 0);
    });
  });
}
