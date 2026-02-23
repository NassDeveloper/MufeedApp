import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/lesson_progress_model.dart';
import '../../domain/models/progress_stats_model.dart';
import '../../domain/models/user_progress_model.dart';
import 'srs_provider.dart';

final progressStatsProvider = FutureProvider<ProgressStatsModel>((ref) async {
  final repo = ref.watch(progressRepositoryProvider);
  final results = await Future.wait([
    repo.getProgressCountsByState(),
    repo.getTotalItemCount(),
    repo.getSessionCount(),
  ]);

  final stateCounts = results[0] as Map<String, int>;
  final totalItems = results[1] as int;
  final sessionCount = results[2] as int;

  // Items tracked in DB include 'new' state records — count them with untracked items
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
