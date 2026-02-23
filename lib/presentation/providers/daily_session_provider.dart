import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/reviewable_item_model.dart';
import '../../domain/usecases/session_builder.dart';
import 'learning_mode_provider.dart';
import 'srs_provider.dart';
import 'streak_provider.dart';

final sessionBuilderProvider = Provider<SessionBuilder>((ref) {
  return const SessionBuilder();
});

/// Provides the built daily session items: due items + new items from active lesson.
/// When a prolonged absence is detected, builds a lightweight resume session instead.
final dailySessionProvider =
    FutureProvider<List<ReviewableItemModel>>((ref) async {
  final repository = ref.watch(progressRepositoryProvider);
  final modeState = await ref.watch(learningModeProvider.future);
  final builder = ref.watch(sessionBuilderProvider);
  final isResume = await ref.watch(isResumeNeededProvider.future);

  // 1. Get due reviewable items (with full content)
  final dueItems = await repository.getDueReviewableItems();

  // 2. If absence detected, build a lightweight resume session
  if (isResume) {
    return builder.buildResumeSession(overdueItems: dueItems);
  }

  // 3. Normal flow: get new items from active lesson
  final activeLessonId =
      modeState.activeLessonId ?? modeState.suggestedLessonId;
  List<ReviewableItemModel> lessonItems = [];
  if (activeLessonId != null) {
    lessonItems =
        await repository.getReviewableItemsForLesson(activeLessonId);
  }

  // 4. Build daily session
  return builder.buildDailySession(
    dueItems: dueItems,
    newItems: lessonItems,
  );
});

/// Count of due items for the HomeScreen CTA.
final dueItemCountProvider = FutureProvider<int>((ref) async {
  final dueItems = await ref.watch(dueItemsProvider.future);
  return dueItems.length;
});
