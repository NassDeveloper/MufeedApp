import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/reviewable_item_model.dart';
import '../../domain/usecases/session_builder.dart';
import 'learning_mode_provider.dart';
import 'progress_provider.dart';
import 'srs_provider.dart';
import 'streak_provider.dart';

final sessionBuilderProvider = Provider<SessionBuilder>((ref) {
  return const SessionBuilder();
});

/// Provides the built daily session items: due items + N new items from the active level.
/// When a prolonged absence is detected, builds a lightweight resume session instead.
final dailySessionProvider =
    FutureProvider<List<ReviewableItemModel>>((ref) async {
  final repository = ref.watch(progressRepositoryProvider);
  final modeState = await ref.watch(learningModeProvider.future);
  final builder = ref.watch(sessionBuilderProvider);
  final isResume = await ref.watch(isResumeNeededProvider.future);
  final n = ref.watch(newWordsPerDayProvider);

  // 1. Get due reviewable items (with full content)
  final dueItems = await repository.getDueReviewableItems();

  // 2. If absence detected, build a lightweight resume session
  if (isResume) {
    return builder.buildResumeSession(overdueItems: dueItems);
  }

  // 3. Normal flow: compute remaining new words based on how many were
  //    introduced today (not FSRS-due count, which would be wrong after review).
  final introducedToday = await repository.getNewWordsIntroducedTodayCount();
  final remaining = max(0, n - introducedToday);
  List<ReviewableItemModel> newItems = [];
  if (remaining > 0) {
    newItems =
        await repository.getNewWordsForLevel(modeState.activeLevelId, remaining);
    // Fallback: if level 1 is exhausted, try level 2
    if (newItems.isEmpty && modeState.activeLevelId == 1) {
      newItems = await repository.getNewWordsForLevel(2, remaining);
    }
  }

  // 4. Build daily session
  return builder.buildDailySession(
    dueItems: dueItems,
    newItems: newItems,
    maxNewItems: remaining,
  );
});

/// Count of due items for the HomeScreen CTA.
final dueItemCountProvider = FutureProvider<int>((ref) async {
  final dueItems = await ref.watch(dueItemsProvider.future);
  return dueItems.length;
});
