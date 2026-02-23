class ContentTypeStats {
  const ContentTypeStats({
    required this.totalItems,
    required this.newCount,
    required this.learningCount,
    required this.reviewCount,
    required this.relearningCount,
  });

  final int totalItems;
  final int newCount;
  final int learningCount;
  final int reviewCount;
  final int relearningCount;

  int get masteredCount => reviewCount;

  double get masteredPercentage =>
      totalItems > 0 ? masteredCount / totalItems : 0.0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentTypeStats &&
          totalItems == other.totalItems &&
          newCount == other.newCount &&
          learningCount == other.learningCount &&
          reviewCount == other.reviewCount &&
          relearningCount == other.relearningCount;

  @override
  int get hashCode => Object.hash(
        totalItems,
        newCount,
        learningCount,
        reviewCount,
        relearningCount,
      );
}

class ProgressStatsModel {
  const ProgressStatsModel({
    required this.totalItems,
    required this.newCount,
    required this.learningCount,
    required this.reviewCount,
    required this.relearningCount,
    required this.sessionCount,
    required this.vocabStats,
    required this.verbStats,
  });

  final int totalItems;
  final int newCount;
  final int learningCount;
  final int reviewCount;
  final int relearningCount;
  final int sessionCount;
  final ContentTypeStats vocabStats;
  final ContentTypeStats verbStats;

  int get masteredCount => reviewCount;

  double get masteredPercentage =>
      totalItems > 0 ? masteredCount / totalItems : 0.0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressStatsModel &&
          totalItems == other.totalItems &&
          newCount == other.newCount &&
          learningCount == other.learningCount &&
          reviewCount == other.reviewCount &&
          relearningCount == other.relearningCount &&
          sessionCount == other.sessionCount &&
          vocabStats == other.vocabStats &&
          verbStats == other.verbStats;

  @override
  int get hashCode => Object.hash(
        totalItems,
        newCount,
        learningCount,
        reviewCount,
        relearningCount,
        sessionCount,
        vocabStats,
        verbStats,
      );
}
