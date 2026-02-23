import 'package:fsrs/fsrs.dart' as fsrs;

import '../../core/constants/srs_constants.dart';
import '../models/user_progress_model.dart';

/// Pure Dart use case that bridges our [UserProgressModel] with the FSRS library.
class SrsEngine {
  SrsEngine({fsrs.Scheduler? scheduler, bool enableFuzzing = true})
      : _scheduler = scheduler ??
            fsrs.Scheduler(
              desiredRetention: SrsConstants.desiredRetention,
              enableFuzzing: enableFuzzing,
            );

  final fsrs.Scheduler _scheduler;

  /// Reviews an item and returns the updated progress.
  ///
  /// If [current] is null (first review), a new progress record is created.
  /// [rating] must be 1-4 (again/hard/good/easy).
  UserProgressModel reviewItem({
    UserProgressModel? current,
    required int rating,
    required int itemId,
    required String contentType,
    DateTime? now,
  }) {
    assert(rating >= 1 && rating <= 4, 'Rating must be between 1 and 4');

    final reviewTime = (now ?? DateTime.now()).toUtc();
    final fsrsRating = fsrs.Rating.fromValue(rating);

    // Convert our model to an FSRS Card
    final card = _toFsrsCard(current, itemId, reviewTime);

    // Perform the review
    final result = _scheduler.reviewCard(
      card,
      fsrsRating,
      reviewDateTime: reviewTime,
    );

    // Convert back to our model
    return _fromFsrsCard(
      result.card,
      current: current,
      itemId: itemId,
      contentType: contentType,
      reviewTime: reviewTime,
    );
  }

  fsrs.Card _toFsrsCard(
      UserProgressModel? current, int itemId, DateTime reviewTime) {
    if (current == null || current.state == 'new') {
      return fsrs.Card(cardId: itemId);
    }

    return fsrs.Card(
      cardId: itemId,
      state: _toFsrsState(current.state),
      stability: current.stability > 0 ? current.stability : null,
      difficulty: current.difficulty > 0 ? current.difficulty : null,
      due: current.nextReview ?? reviewTime,
      lastReview: current.lastReview,
    );
  }

  UserProgressModel _fromFsrsCard(
    fsrs.Card card, {
    UserProgressModel? current,
    required int itemId,
    required String contentType,
    required DateTime reviewTime,
  }) {
    final elapsedDays = current?.lastReview != null
        ? reviewTime.difference(current!.lastReview!).inDays
        : 0;
    final scheduledDays = card.due.difference(reviewTime).inDays;

    return UserProgressModel(
      id: current?.id,
      itemId: itemId,
      contentType: contentType,
      stability: card.stability ?? 0,
      difficulty: card.difficulty ?? 0,
      state: _fromFsrsState(card.state),
      lastReview: reviewTime,
      nextReview: card.due,
      reviewCount: (current?.reviewCount ?? 0) + 1,
      elapsedDays: elapsedDays,
      scheduledDays: scheduledDays,
      reps: (current?.reps ?? 0) + 1,
    );
  }

  static fsrs.State _toFsrsState(String state) {
    return switch (state) {
      'learning' => fsrs.State.learning,
      'review' => fsrs.State.review,
      'relearning' => fsrs.State.relearning,
      _ => fsrs.State.learning,
    };
  }

  static String _fromFsrsState(fsrs.State state) {
    return switch (state) {
      fsrs.State.learning => 'learning',
      fsrs.State.review => 'review',
      fsrs.State.relearning => 'relearning',
    };
  }
}
