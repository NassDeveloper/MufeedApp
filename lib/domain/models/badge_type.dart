import '../../l10n/app_localizations.dart';

enum BadgeType {
  firstWordReviewed,
  words10,
  words50,
  words100,
  words500,
  firstLessonCompleted,
  streak7,
  streak30,
  streak100,
  perfectQuiz;

  String label(AppLocalizations l10n) => switch (this) {
        firstWordReviewed => l10n.badgeFirstWordReviewed,
        words10 => l10n.badgeWords10,
        words50 => l10n.badgeWords50,
        words100 => l10n.badgeWords100,
        words500 => l10n.badgeWords500,
        firstLessonCompleted => l10n.badgeFirstLessonCompleted,
        streak7 => l10n.badgeStreak7,
        streak30 => l10n.badgeStreak30,
        streak100 => l10n.badgeStreak100,
        perfectQuiz => l10n.badgePerfectQuiz,
      };

  String description(AppLocalizations l10n) => switch (this) {
        firstWordReviewed => l10n.badgeFirstWordReviewedDesc,
        words10 => l10n.badgeWords10Desc,
        words50 => l10n.badgeWords50Desc,
        words100 => l10n.badgeWords100Desc,
        words500 => l10n.badgeWords500Desc,
        firstLessonCompleted => l10n.badgeFirstLessonCompletedDesc,
        streak7 => l10n.badgeStreak7Desc,
        streak30 => l10n.badgeStreak30Desc,
        streak100 => l10n.badgeStreak100Desc,
        perfectQuiz => l10n.badgePerfectQuizDesc,
      };

  String get key => name;

  static BadgeType? fromKey(String key) {
    for (final type in values) {
      if (type.key == key) return type;
    }
    return null;
  }
}
