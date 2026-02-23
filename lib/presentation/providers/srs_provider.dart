import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/reviewable_item_model.dart';
import '../../domain/models/user_progress_model.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/usecases/srs_engine.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  throw UnimplementedError(
    'progressRepositoryProvider must be overridden in main.dart',
  );
});

final srsEngineProvider = Provider<SrsEngine>((ref) {
  return SrsEngine();
});

final reviewableItemsProvider =
    FutureProvider.family<List<ReviewableItemModel>, int>((ref, lessonId) {
  return ref.watch(progressRepositoryProvider).getReviewableItemsForLesson(lessonId);
});

final dueItemsProvider = FutureProvider<List<UserProgressModel>>((ref) {
  return ref.watch(progressRepositoryProvider).getDueItems();
});
