import '../models/reviewable_item_model.dart';

class SessionBuilder {
  const SessionBuilder();

  /// Builds a daily session combining due items and new items.
  ///
  /// [dueItems] are sorted by nextReview ASC (most overdue first).
  /// [newItems] are filtered to effectiveState == 'new' and capped at [maxNewItems].
  /// Returns: due items first, then new items.
  List<ReviewableItemModel> buildDailySession({
    required List<ReviewableItemModel> dueItems,
    required List<ReviewableItemModel> newItems,
    int maxNewItems = 5,
  }) {
    // Sort due items by nextReview ascending (most overdue first)
    final sortedDue = List<ReviewableItemModel>.from(dueItems)
      ..sort((a, b) {
        final aDate = a.progress?.nextReview;
        final bDate = b.progress?.nextReview;
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return aDate.compareTo(bDate);
      });

    // Collect due item keys for deduplication
    final dueKeys = <(int, String)>{
      for (final item in sortedDue) (item.itemId, item.contentType),
    };

    // Filter to truly new items, exclude duplicates, cap at maxNewItems
    final filteredNew = newItems
        .where((item) =>
            item.effectiveState == 'new' &&
            !dueKeys.contains((item.itemId, item.contentType)))
        .take(maxNewItems)
        .toList();

    return [...sortedDue, ...filteredNew];
  }

  /// Builds a lightweight resume session for users returning after absence.
  ///
  /// Only includes items with progress (no 'new' items).
  /// Sorted by [lastReview] ASC (most anciently reviewed first, null first).
  /// Capped at [maxItems] (default 12, within the 10-15 range).
  List<ReviewableItemModel> buildResumeSession({
    required List<ReviewableItemModel> overdueItems,
    int maxItems = 12,
  }) {
    const resumeStates = {'review', 'relearning', 'learning'};

    final filtered = overdueItems
        .where((item) => resumeStates.contains(item.effectiveState))
        .toList();

    // Sort by lastReview ascending: null first (never reviewed), then oldest
    filtered.sort((a, b) {
      final aDate = a.progress?.lastReview;
      final bDate = b.progress?.lastReview;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return -1;
      if (bDate == null) return 1;
      return aDate.compareTo(bDate);
    });

    return filtered.take(maxItems).toList();
  }
}
