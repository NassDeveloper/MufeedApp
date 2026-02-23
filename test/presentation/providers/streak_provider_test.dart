import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/badge_model.dart';
import 'package:mufeed_app/domain/models/badge_type.dart';
import 'package:mufeed_app/domain/models/reviewable_item_model.dart';
import 'package:mufeed_app/domain/models/session_model.dart';
import 'package:mufeed_app/domain/models/streak_model.dart';
import 'package:mufeed_app/domain/models/user_progress_model.dart';
import 'package:mufeed_app/domain/repositories/badge_repository.dart';
import 'package:mufeed_app/domain/repositories/progress_repository.dart';
import 'package:mufeed_app/domain/repositories/streak_repository.dart';
import 'package:mufeed_app/presentation/providers/badge_provider.dart';
import 'package:mufeed_app/presentation/providers/srs_provider.dart';
import 'package:mufeed_app/presentation/providers/streak_provider.dart';

class FakeBadgeRepository implements BadgeRepository {
  @override
  Future<List<BadgeModel>> getAllBadges() async => [];
  @override
  Future<BadgeModel?> getBadge(BadgeType type) async => null;
  @override
  Future<void> unlockBadge(BadgeType type, DateTime at) async {}
  @override
  Future<void> markDisplayed(BadgeType type) async {}
}

class FakeProgressRepository implements ProgressRepository {
  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLesson(int lessonId) async => [];
  @override
  Future<List<UserProgressModel>> getDueItems() async => [];
  @override
  Future<List<ReviewableItemModel>> getDueReviewableItems() async => [];
  @override
  Future<UserProgressModel?> getProgressForItem(int itemId, String contentType) async => null;
  @override
  Future<void> saveProgress(UserProgressModel progress) async {}
  @override
  Future<int> createSession(SessionModel session) async => 1;
  @override
  Future<Map<String, int>> getProgressCountsByState() async => {};
  @override
  Future<int> getTotalItemCount() async => 0;
  @override
  Future<int> getSessionCount() async => 0;
  @override
  Future<List<UserProgressModel>> getProgressForLesson(int lessonId) async => [];
  @override
  Future<int> getTotalItemCountForLesson(int lessonId) async => 0;
  @override
  Future<List<({int lessonId, int totalItems, int masteredCount})>>
      getLessonProgressSummaryForLevel(int levelId) async => [];
  @override
  Future<int> getTotalWordsReviewed() async => 0;
  @override
  Future<int> getCompletedLessonCount() async => 0;
  @override
  Future<bool> hasPerfectQuiz() async => false;
}

class FakeStreakRepository implements StreakRepository {
  StreakModel? streakData;
  DateTime? lastActivityDate;
  StreakModel? lastSavedStreak;
  int updateCount = 0;

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
    lastSavedStreak = streak;
    streakData = streak;
    updateCount++;
  }
}

StreakModel _makeStreak({
  int currentStreak = 5,
  int longestStreak = 10,
  required DateTime lastActivityDate,
  bool freezeAvailable = true,
  DateTime? freezeUsedDate,
}) {
  return StreakModel(
    id: 1,
    currentStreak: currentStreak,
    longestStreak: longestStreak,
    lastActivityDate: lastActivityDate,
    freezeAvailable: freezeAvailable,
    freezeUsedDate: freezeUsedDate,
  );
}

void main() {
  late FakeStreakRepository fakeRepo;
  late ProviderContainer container;
  final fixedNow = DateTime(2026, 2, 22);

  setUp(() {
    fakeRepo = FakeStreakRepository();
    container = ProviderContainer(
      overrides: [
        streakRepositoryProvider.overrideWithValue(fakeRepo),
        clockProvider.overrideWithValue(() => fixedNow),
        badgeRepositoryProvider.overrideWithValue(FakeBadgeRepository()),
        progressRepositoryProvider.overrideWithValue(FakeProgressRepository()),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('StreakCheckNotifier.performCheck', () {
    test('does nothing when no streak exists', () async {
      fakeRepo.streakData = null;

      await container.read(streakCheckProvider.notifier).performCheck();

      expect(container.read(streakCheckProvider), isNull);
      expect(fakeRepo.updateCount, 0);
    });

    test('increments streak when last activity was yesterday', () async {
      fakeRepo.streakData = _makeStreak(
        currentStreak: 5,
        lastActivityDate: DateTime(2026, 2, 21),
      );

      await container.read(streakCheckProvider.notifier).performCheck();

      final result = container.read(streakCheckProvider);
      expect(result, isNotNull);
      expect(result!.streak.currentStreak, 6);
      expect(result.wasStreakBroken, false);
      expect(result.wasFreezeUsed, false);
      expect(fakeRepo.updateCount, 1);
    });

    test('detects streak broken when gap > 2 days without freeze', () async {
      fakeRepo.streakData = _makeStreak(
        currentStreak: 5,
        lastActivityDate: DateTime(2026, 2, 19), // 3 days ago
        freezeAvailable: false,
        freezeUsedDate: DateTime(2026, 2, 18),
      );

      await container.read(streakCheckProvider.notifier).performCheck();

      final result = container.read(streakCheckProvider);
      expect(result, isNotNull);
      expect(result!.streak.currentStreak, 0);
      expect(result.wasStreakBroken, true);
      expect(result.wasFreezeUsed, false);
    });

    test('detects freeze used when 2-day gap with freeze available', () async {
      fakeRepo.streakData = _makeStreak(
        currentStreak: 5,
        lastActivityDate: DateTime(2026, 2, 20), // 2 days ago
        freezeAvailable: true,
      );

      await container.read(streakCheckProvider.notifier).performCheck();

      final result = container.read(streakCheckProvider);
      expect(result, isNotNull);
      expect(result!.streak.currentStreak, 6);
      expect(result.wasStreakBroken, false);
      expect(result.wasFreezeUsed, true);
      expect(result.streak.freezeAvailable, false);
    });

    test('does not save when streak is unchanged (same day)', () async {
      fakeRepo.streakData = _makeStreak(
        currentStreak: 5,
        lastActivityDate: DateTime(2026, 2, 22), // same day
      );

      await container.read(streakCheckProvider.notifier).performCheck();

      final result = container.read(streakCheckProvider);
      expect(result, isNotNull);
      expect(result!.streak.currentStreak, 5);
      expect(fakeRepo.updateCount, 0);
    });

    test('wasFreezeUsed is false when streak was broken (even if freeze existed)', () async {
      // 3-day gap: freeze can't save this → reset
      fakeRepo.streakData = _makeStreak(
        currentStreak: 5,
        lastActivityDate: DateTime(2026, 2, 19),
        freezeAvailable: true,
      );

      await container.read(streakCheckProvider.notifier).performCheck();

      final result = container.read(streakCheckProvider);
      expect(result, isNotNull);
      expect(result!.wasStreakBroken, true);
      // freezeAvailable goes from true in raw → true in updated (freeze not used, streak reset)
      expect(result.wasFreezeUsed, false);
    });
  });

  group('processStreakOnSessionComplete', () {
    // Use a FutureProvider to invoke processStreakOnSessionComplete with
    // a valid Ref, since ProviderContainer is not a Ref in Riverpod 3.
    test('updates streak and saves', () async {
      fakeRepo.streakData = _makeStreak(
        currentStreak: 5,
        lastActivityDate: DateTime(2026, 2, 21),
      );

      final testProvider = FutureProvider<void>((ref) async {
        await processStreakOnSessionComplete(ref);
      });
      await container.read(testProvider.future);

      expect(fakeRepo.updateCount, 1);
      expect(fakeRepo.lastSavedStreak!.currentStreak, 6);
    });

    test('skips when no streak record', () async {
      fakeRepo.streakData = null;

      final logs = <String>[];
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) logs.add(message);
      };

      final testProvider = FutureProvider<void>((ref) async {
        await processStreakOnSessionComplete(ref);
      });
      await container.read(testProvider.future);

      debugPrint = debugPrintThrottled;
      expect(logs, contains('Streak update skipped: no streak record found'));
      expect(fakeRepo.updateCount, 0);
    });

    test('does not save when streak unchanged', () async {
      fakeRepo.streakData = _makeStreak(
        currentStreak: 5,
        lastActivityDate: DateTime(2026, 2, 22), // same day
      );

      final testProvider = FutureProvider<void>((ref) async {
        await processStreakOnSessionComplete(ref);
      });
      await container.read(testProvider.future);

      expect(fakeRepo.updateCount, 0);
    });
  });
}
