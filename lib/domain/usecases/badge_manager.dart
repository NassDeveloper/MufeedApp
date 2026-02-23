import '../models/badge_model.dart';
import '../models/badge_type.dart';

class BadgeCheckContext {
  const BadgeCheckContext({
    this.totalWordsReviewed = 0,
    this.wordsMastered = 0,
    this.lessonsCompleted = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.hasPerfectQuiz = false,
  });

  final int totalWordsReviewed;
  final int wordsMastered;
  final int lessonsCompleted;
  final int currentStreak;
  final int longestStreak;
  final bool hasPerfectQuiz;
}

class BadgeManager {
  const BadgeManager();

  List<BadgeType> checkBadges({
    required List<BadgeModel> currentBadges,
    required BadgeCheckContext context,
  }) {
    final unlockedTypes =
        currentBadges.where((b) => b.isUnlocked).map((b) => b.badgeType).toSet();

    final newlyUnlocked = <BadgeType>[];

    for (final type in BadgeType.values) {
      if (unlockedTypes.contains(type)) continue;
      if (_isSatisfied(type, context)) {
        newlyUnlocked.add(type);
      }
    }

    return newlyUnlocked;
  }

  bool _isSatisfied(BadgeType type, BadgeCheckContext context) {
    return switch (type) {
      BadgeType.firstWordReviewed => context.totalWordsReviewed >= 1,
      BadgeType.words10 => context.wordsMastered >= 10,
      BadgeType.words50 => context.wordsMastered >= 50,
      BadgeType.words100 => context.wordsMastered >= 100,
      BadgeType.words500 => context.wordsMastered >= 500,
      BadgeType.firstLessonCompleted => context.lessonsCompleted >= 1,
      BadgeType.streak7 => context.longestStreak >= 7,
      BadgeType.streak30 => context.longestStreak >= 30,
      BadgeType.streak100 => context.longestStreak >= 100,
      BadgeType.perfectQuiz => context.hasPerfectQuiz,
    };
  }
}
