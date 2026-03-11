import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/daily_activity_model.dart';
import '../../domain/models/lesson_progress_model.dart';
import '../../domain/models/progress_stats_model.dart';
import '../../domain/models/upcoming_reviews_model.dart';
import '../../domain/models/user_progress_model.dart';
import '../providers/preferences_provider.dart';
import 'srs_provider.dart';

ContentTypeStats _buildTypeStats({
  required int totalItems,
  required Map<String, int> stateCounts,
}) {
  final learning = stateCounts['learning'] ?? 0;
  final review = stateCounts['review'] ?? 0;
  final relearning = stateCounts['relearning'] ?? 0;
  final trackedNonNew = learning + review + relearning;
  return ContentTypeStats(
    totalItems: totalItems,
    newCount: totalItems - trackedNonNew,
    learningCount: learning,
    reviewCount: review,
    relearningCount: relearning,
  );
}

final progressStatsProvider = FutureProvider<ProgressStatsModel>((ref) async {
  final repo = ref.watch(progressRepositoryProvider);
  final results = await Future.wait([
    repo.getProgressCountsByState(),
    repo.getProgressCountsByStateAndType(),
    repo.getTotalItemCount(),
    repo.getTotalWordCount(),
    repo.getTotalVerbCount(),
    repo.getSessionCount(),
  ]);

  final stateCounts = results[0] as Map<String, int>;
  final stateByType = results[1] as Map<String, Map<String, int>>;
  final totalItems = results[2] as int;
  final totalWords = results[3] as int;
  final totalVerbs = results[4] as int;
  final sessionCount = results[5] as int;

  final trackedNonNew = (stateCounts['learning'] ?? 0) +
      (stateCounts['review'] ?? 0) +
      (stateCounts['relearning'] ?? 0);

  return ProgressStatsModel(
    totalItems: totalItems,
    newCount: totalItems - trackedNonNew,
    learningCount: stateCounts['learning'] ?? 0,
    reviewCount: stateCounts['review'] ?? 0,
    relearningCount: stateCounts['relearning'] ?? 0,
    sessionCount: sessionCount,
    vocabStats: _buildTypeStats(
      totalItems: totalWords,
      stateCounts: stateByType['vocab'] ?? {},
    ),
    verbStats: _buildTypeStats(
      totalItems: totalVerbs,
      stateCounts: stateByType['verb'] ?? {},
    ),
  );
});

final lessonProgressProvider =
    FutureProvider.family<LessonProgressModel, int>((ref, lessonId) async {
  final repo = ref.watch(progressRepositoryProvider);
  final results = await Future.wait([
    repo.getTotalItemCountForLesson(lessonId),
    repo.getProgressForLesson(lessonId),
  ]);

  final totalItems = results[0] as int;
  final progressList = results[1] as List<UserProgressModel>;
  final masteredCount =
      progressList.where((p) => p.state == 'review').length;

  return LessonProgressModel(
    totalItems: totalItems,
    masteredCount: masteredCount,
  );
});

final recentActivityProvider =
    FutureProvider<List<DailyActivityModel>>((ref) {
  return ref.watch(progressRepositoryProvider).getReviewActivity(days: 14);
});

final upcomingReviewsProvider = FutureProvider<UpcomingReviewsModel>((ref) {
  return ref.watch(progressRepositoryProvider).getUpcomingReviews();
});

/// Aggregated progress (mastered / total items) for an entire level.
final levelProgressProvider =
    FutureProvider.family<({int totalItems, int masteredItems}), int>(
        (ref, levelId) async {
  final summaries = await ref
      .watch(progressRepositoryProvider)
      .getLessonProgressSummaryForLevel(levelId);
  final total = summaries.fold(0, (s, e) => s + e.totalItems);
  final mastered = summaries.fold(0, (s, e) => s + e.masteredCount);
  return (totalItems: total, masteredItems: mastered);
});

/// Number of new words to introduce per day (configurable in settings).
class NewWordsPerDayNotifier extends Notifier<int> {
  @override
  int build() {
    return ref.read(sharedPreferencesSourceProvider).getNewWordsPerDay();
  }

  Future<void> setValue(int value) async {
    await ref.read(sharedPreferencesSourceProvider).setNewWordsPerDay(value);
    state = value;
  }
}

final newWordsPerDayProvider =
    NotifierProvider<NewWordsPerDayNotifier, int>(NewWordsPerDayNotifier.new);
