import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/app_error.dart';
import '../../domain/models/reviewable_item_model.dart';
import '../../domain/models/session_model.dart';
import 'badge_provider.dart';
import 'preferences_provider.dart';
import 'progress_provider.dart';
import 'srs_provider.dart';
import 'streak_provider.dart';

class FlashcardSessionState {
  FlashcardSessionState({
    required List<ReviewableItemModel> items,
    required this.currentIndex,
    required this.lessonId,
    this.isFlipped = false,
    Map<int, int> ratingCounts = const {1: 0, 2: 0, 3: 0, 4: 0},
    this.isCompleted = false,
    this.isDailySession = false,
    DateTime? startedAt,
  })  : items = List.unmodifiable(items),
        ratingCounts = Map.unmodifiable(ratingCounts),
        startedAt = startedAt ?? DateTime.now();

  final List<ReviewableItemModel> items;
  final int currentIndex;
  final int lessonId;
  final bool isFlipped;
  final Map<int, int> ratingCounts;
  final bool isCompleted;
  final bool isDailySession;
  final DateTime startedAt;

  ReviewableItemModel get currentItem => items[currentIndex];
  int get totalItems => items.length;
  bool get isFirst => currentIndex == 0;
  bool get isLast => currentIndex == items.length - 1;
  int get evaluatedCount =>
      ratingCounts.values.fold(0, (sum, count) => sum + count);

  FlashcardSessionState copyWith({
    List<ReviewableItemModel>? items,
    int? currentIndex,
    int? lessonId,
    bool? isFlipped,
    Map<int, int>? ratingCounts,
    bool? isCompleted,
    bool? isDailySession,
    DateTime? startedAt,
  }) {
    return FlashcardSessionState(
      items: items ?? this.items,
      currentIndex: currentIndex ?? this.currentIndex,
      lessonId: lessonId ?? this.lessonId,
      isFlipped: isFlipped ?? this.isFlipped,
      ratingCounts: ratingCounts ?? this.ratingCounts,
      isCompleted: isCompleted ?? this.isCompleted,
      isDailySession: isDailySession ?? this.isDailySession,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}

class FlashcardSessionNotifier extends Notifier<FlashcardSessionState?> {
  @override
  FlashcardSessionState? build() => null;

  Future<void> startSession(int lessonId, {int startIndex = 0}) async {
    final repository = ref.read(progressRepositoryProvider);
    final items = await repository.getReviewableItemsForLesson(lessonId);

    if (items.isEmpty) return;

    final clampedIndex = startIndex.clamp(0, items.length - 1);
    state = FlashcardSessionState(
      items: items,
      currentIndex: clampedIndex,
      lessonId: lessonId,
    );
    unawaited(_savePosition());
  }

  Future<void> startMultiLessonSession(List<int> lessonIds) async {
    final repository = ref.read(progressRepositoryProvider);
    final items = await repository.getReviewableItemsForLessons(lessonIds);

    if (items.isEmpty) return;

    state = FlashcardSessionState(
      items: items,
      currentIndex: 0,
      lessonId: 0,
    );
  }

  void startDailySession(List<ReviewableItemModel> items) {
    if (items.isEmpty) return;

    state = FlashcardSessionState(
      items: items,
      currentIndex: 0,
      lessonId: 0,
      isDailySession: true,
    );
  }

  void flipCard() {
    if (state == null) return;
    state = state!.copyWith(isFlipped: !state!.isFlipped);
  }

  void goToPage(int index) {
    if (state == null) return;
    if (index < 0 || index >= state!.totalItems) return;
    state = state!.copyWith(currentIndex: index, isFlipped: false);
    if (!state!.isDailySession) unawaited(_savePosition());
  }

  void nextCard() {
    if (state == null || state!.isLast) return;
    state = state!.copyWith(
      currentIndex: state!.currentIndex + 1,
      isFlipped: false,
    );
    if (!state!.isDailySession) unawaited(_savePosition());
  }

  void previousCard() {
    if (state == null || state!.isFirst) return;
    state = state!.copyWith(
      currentIndex: state!.currentIndex - 1,
      isFlipped: false,
    );
    if (!state!.isDailySession) unawaited(_savePosition());
  }

  Future<void> rateCard(int rating) async {
    if (state == null || state!.isCompleted) return;
    assert(rating >= 1 && rating <= 4, 'Rating must be between 1 and 4');

    final currentItem = state!.currentItem;
    final srsEngine = ref.read(srsEngineProvider);
    final repository = ref.read(progressRepositoryProvider);

    // Calculate new progress via FSRS
    final updatedProgress = srsEngine.reviewItem(
      current: currentItem.progress,
      rating: rating,
      itemId: currentItem.itemId,
      contentType: currentItem.contentType,
    );

    // Save to database
    await repository.saveProgress(updatedProgress);

    // Update rating counts
    final newCounts = Map<int, int>.from(state!.ratingCounts);
    newCounts[rating] = (newCounts[rating] ?? 0) + 1;

    final isLastCard = state!.isLast;

    if (isLastCard) {
      // Session complete
      state = state!.copyWith(
        ratingCounts: newCounts,
        isCompleted: true,
        isFlipped: false,
      );
      await _completeSession();
    } else {
      // Advance to next card
      state = state!.copyWith(
        currentIndex: state!.currentIndex + 1,
        isFlipped: false,
        ratingCounts: newCounts,
      );
      if (!state!.isDailySession) unawaited(_savePosition());
    }
  }

  Future<void> _completeSession() async {
    final repository = ref.read(progressRepositoryProvider);
    if (!state!.isDailySession) {
      unawaited(_clearSavedPosition());
    }

    await repository.createSession(SessionModel(
      sessionType: state!.isDailySession ? 'daily' : 'flashcard',
      startedAt: state!.startedAt,
      completedAt: DateTime.now(),
      itemsReviewed: state!.totalItems,
      resultsJson: jsonEncode(state!.ratingCounts.map(
        (key, value) => MapEntry(key.toString(), value),
      )),
    ));

    // Update streak + check badges
    try {
      final result = await processStreakOnSessionComplete(ref);
      if (result.newBadges.isNotEmpty) {
        ref.read(newBadgesProvider.notifier).set(result.newBadges);
      }
    } on AppError catch (e) {
      debugPrint('Streak update failed: $e');
    }

    // Invalidate stats so they refresh on next access
    ref.invalidate(progressStatsProvider);
    if (!state!.isDailySession) {
      ref.invalidate(lessonProgressProvider(state!.lessonId));
    }
  }

  void endSession() {
    if (state != null && !state!.isDailySession) {
      unawaited(_clearSavedPosition());
    }
    state = null;
  }

  Future<void> _savePosition() async {
    if (state == null) return;
    final prefs = ref.read(sharedPreferencesSourceProvider);
    await prefs.saveFlashcardSession(
      lessonId: state!.lessonId,
      index: state!.currentIndex,
    );
  }

  Future<void> _clearSavedPosition() async {
    final prefs = ref.read(sharedPreferencesSourceProvider);
    await prefs.clearFlashcardSession();
  }
}

final flashcardSessionProvider =
    NotifierProvider<FlashcardSessionNotifier, FlashcardSessionState?>(
  FlashcardSessionNotifier.new,
);
