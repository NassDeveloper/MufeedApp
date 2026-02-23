import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/badge_model.dart';
import 'package:mufeed_app/domain/models/badge_type.dart';
import 'package:mufeed_app/domain/usecases/badge_manager.dart';

void main() {
  const manager = BadgeManager();

  BadgeModel locked(BadgeType type) => BadgeModel(
        id: type.index + 1,
        badgeType: type,
      );

  BadgeModel unlocked(BadgeType type) => BadgeModel(
        id: type.index + 1,
        badgeType: type,
        unlockedAt: DateTime(2026, 1, 1),
      );

  List<BadgeModel> allLocked() =>
      BadgeType.values.map(locked).toList();

  group('BadgeManager.checkBadges', () {
    test('returns empty list when context has no progress', () {
      final result = manager.checkBadges(
        currentBadges: allLocked(),
        context: const BadgeCheckContext(),
      );
      expect(result, isEmpty);
    });

    test('unlocks firstWordReviewed when totalWordsReviewed >= 1', () {
      final result = manager.checkBadges(
        currentBadges: allLocked(),
        context: const BadgeCheckContext(totalWordsReviewed: 1),
      );
      expect(result, contains(BadgeType.firstWordReviewed));
    });

    test('does not re-unlock already unlocked badges', () {
      final badges = allLocked();
      badges[0] = unlocked(BadgeType.firstWordReviewed);

      final result = manager.checkBadges(
        currentBadges: badges,
        context: const BadgeCheckContext(totalWordsReviewed: 1),
      );
      expect(result, isNot(contains(BadgeType.firstWordReviewed)));
    });

    test('unlocks words10 when wordsMastered >= 10', () {
      final result = manager.checkBadges(
        currentBadges: allLocked(),
        context: const BadgeCheckContext(wordsMastered: 10),
      );
      expect(result, contains(BadgeType.words10));
    });

    test('unlocks words50 when wordsMastered >= 50', () {
      final result = manager.checkBadges(
        currentBadges: allLocked(),
        context: const BadgeCheckContext(wordsMastered: 50),
      );
      expect(result, contains(BadgeType.words50));
      expect(result, contains(BadgeType.words10));
    });

    test('unlocks words100 when wordsMastered >= 100', () {
      final result = manager.checkBadges(
        currentBadges: allLocked(),
        context: const BadgeCheckContext(wordsMastered: 100),
      );
      expect(result, contains(BadgeType.words100));
    });

    test('unlocks words500 when wordsMastered >= 500', () {
      final result = manager.checkBadges(
        currentBadges: allLocked(),
        context: const BadgeCheckContext(wordsMastered: 500),
      );
      expect(result, contains(BadgeType.words500));
    });

    test('unlocks firstLessonCompleted when lessonsCompleted >= 1', () {
      final result = manager.checkBadges(
        currentBadges: allLocked(),
        context: const BadgeCheckContext(lessonsCompleted: 1),
      );
      expect(result, contains(BadgeType.firstLessonCompleted));
    });

    test('unlocks streak7 when longestStreak >= 7', () {
      final result = manager.checkBadges(
        currentBadges: allLocked(),
        context: const BadgeCheckContext(longestStreak: 7),
      );
      expect(result, contains(BadgeType.streak7));
    });

    test('unlocks streak30 when longestStreak >= 30', () {
      final result = manager.checkBadges(
        currentBadges: allLocked(),
        context: const BadgeCheckContext(longestStreak: 30),
      );
      expect(result, contains(BadgeType.streak30));
      expect(result, contains(BadgeType.streak7));
    });

    test('unlocks streak100 when longestStreak >= 100', () {
      final result = manager.checkBadges(
        currentBadges: allLocked(),
        context: const BadgeCheckContext(longestStreak: 100),
      );
      expect(result, contains(BadgeType.streak100));
    });

    test('unlocks perfectQuiz when hasPerfectQuiz is true', () {
      final result = manager.checkBadges(
        currentBadges: allLocked(),
        context: const BadgeCheckContext(hasPerfectQuiz: true),
      );
      expect(result, contains(BadgeType.perfectQuiz));
    });

    test('unlocks multiple badges at once', () {
      final result = manager.checkBadges(
        currentBadges: allLocked(),
        context: const BadgeCheckContext(
          totalWordsReviewed: 50,
          wordsMastered: 50,
          lessonsCompleted: 3,
          longestStreak: 10,
          hasPerfectQuiz: true,
        ),
      );
      expect(result, containsAll([
        BadgeType.firstWordReviewed,
        BadgeType.words10,
        BadgeType.words50,
        BadgeType.firstLessonCompleted,
        BadgeType.streak7,
        BadgeType.perfectQuiz,
      ]));
      expect(result, isNot(contains(BadgeType.words100)));
      expect(result, isNot(contains(BadgeType.streak30)));
    });

    test('does not unlock words10 when wordsMastered < 10', () {
      final result = manager.checkBadges(
        currentBadges: allLocked(),
        context: const BadgeCheckContext(wordsMastered: 9),
      );
      expect(result, isNot(contains(BadgeType.words10)));
    });
  });
}
