class LessonProgressModel {
  const LessonProgressModel({
    required this.totalItems,
    required this.masteredCount,
  });

  final int totalItems;
  final int masteredCount;

  double get masteredPercentage =>
      totalItems > 0 ? masteredCount / totalItems : 0.0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonProgressModel &&
          totalItems == other.totalItems &&
          masteredCount == other.masteredCount;

  @override
  int get hashCode => Object.hash(totalItems, masteredCount);
}
