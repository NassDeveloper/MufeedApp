class ProgressStatsModel {
  const ProgressStatsModel({
    required this.totalItems,
    required this.newCount,
    required this.learningCount,
    required this.reviewCount,
    required this.relearningCount,
    required this.sessionCount,
  });

  final int totalItems;
  final int newCount;
  final int learningCount;
  final int reviewCount;
  final int relearningCount;
  final int sessionCount;

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
          sessionCount == other.sessionCount;

  @override
  int get hashCode => Object.hash(
        totalItems,
        newCount,
        learningCount,
        reviewCount,
        relearningCount,
        sessionCount,
      );
}
