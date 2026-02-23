import '../../core/constants/srs_constants.dart';

class LessonWithProgress {
  const LessonWithProgress({
    required this.lessonId,
    required this.totalItems,
    required this.masteredCount,
  });

  final int lessonId;
  final int totalItems;
  final int masteredCount;
}

class ProgressCalculator {
  /// Returns the mastery percentage for a lesson (mastered items in 'review' state / total).
  /// Empty lessons (0 items) are considered mastered (returns 1.0).
  double calculateLessonMasteryPercent(int totalItems, int masteredCount) {
    if (totalItems == 0) return 1.0;
    return masteredCount / totalItems;
  }

  /// Returns true if the lesson is considered mastered (>= threshold).
  bool isLessonMastered(
    int totalItems,
    int masteredCount, {
    double threshold = SrsConstants.masteryThreshold,
  }) {
    return calculateLessonMasteryPercent(totalItems, masteredCount) >= threshold;
  }

  /// Returns the ID of the first non-mastered lesson, or null if all are mastered.
  int? findNextLessonToStudy(List<LessonWithProgress> lessons) {
    for (final lesson in lessons) {
      if (!isLessonMastered(lesson.totalItems, lesson.masteredCount)) {
        return lesson.lessonId;
      }
    }
    return null;
  }
}
