import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/user_progress_model.dart';
import 'package:mufeed_app/domain/models/reviewable_item_model.dart';
import 'package:mufeed_app/domain/models/session_model.dart';

void main() {
  group('UserProgressModel', () {
    test('creates with defaults', () {
      const model = UserProgressModel(
        itemId: 1,
        contentType: 'vocab',
      );

      expect(model.id, isNull);
      expect(model.itemId, 1);
      expect(model.contentType, 'vocab');
      expect(model.stability, 0);
      expect(model.difficulty, 0);
      expect(model.state, 'new');
      expect(model.lastReview, isNull);
      expect(model.nextReview, isNull);
      expect(model.reviewCount, 0);
      expect(model.elapsedDays, 0);
      expect(model.scheduledDays, 0);
      expect(model.reps, 0);
    });

    test('copyWith works', () {
      const original = UserProgressModel(
        id: 1,
        itemId: 10,
        contentType: 'vocab',
        stability: 5.0,
        difficulty: 3.0,
        state: 'review',
      );

      final copy = original.copyWith(stability: 10.0);

      expect(copy.stability, 10.0);
      expect(copy.id, 1);
      expect(copy.itemId, 10);
      expect(copy.state, 'review');
    });

    test('equality works', () {
      const a = UserProgressModel(itemId: 1, contentType: 'vocab');
      const b = UserProgressModel(itemId: 1, contentType: 'vocab');
      const c = UserProgressModel(itemId: 2, contentType: 'vocab');

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });

  group('ReviewableItemModel', () {
    test('creates correctly', () {
      const model = ReviewableItemModel(
        itemId: 1,
        contentType: 'vocab',
        arabic: 'كتاب',
        translationFr: 'livre',
        sortOrder: 1,
      );

      expect(model.itemId, 1);
      expect(model.contentType, 'vocab');
      expect(model.arabic, 'كتاب');
      expect(model.translationFr, 'livre');
      expect(model.progress, isNull);
      expect(model.effectiveState, 'new');
    });

    test('effectiveState returns progress state when available', () {
      const model = ReviewableItemModel(
        itemId: 1,
        contentType: 'vocab',
        arabic: 'كتاب',
        translationFr: 'livre',
        sortOrder: 1,
        progress: UserProgressModel(
          itemId: 1,
          contentType: 'vocab',
          state: 'review',
        ),
      );

      expect(model.effectiveState, 'review');
    });

    test('equality compares all fields', () {
      const a = ReviewableItemModel(
        itemId: 1,
        contentType: 'vocab',
        arabic: 'كتاب',
        translationFr: 'livre',
        sortOrder: 1,
      );
      const b = ReviewableItemModel(
        itemId: 1,
        contentType: 'vocab',
        arabic: 'كتاب',
        translationFr: 'livre',
        sortOrder: 1,
      );
      const c = ReviewableItemModel(
        itemId: 1,
        contentType: 'vocab',
        arabic: 'قلم',
        translationFr: 'stylo',
        sortOrder: 2,
      );

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });

  group('SessionModel', () {
    test('creates correctly', () {
      final now = DateTime.utc(2026, 2, 21);
      final model = SessionModel(
        sessionType: 'flashcard',
        startedAt: now,
        itemsReviewed: 10,
      );

      expect(model.id, isNull);
      expect(model.sessionType, 'flashcard');
      expect(model.startedAt, now);
      expect(model.completedAt, isNull);
      expect(model.itemsReviewed, 10);
      expect(model.resultsJson, isNull);
    });

    test('copyWith works', () {
      final now = DateTime.utc(2026, 2, 21);
      final later = DateTime.utc(2026, 2, 21, 1, 0);
      final model = SessionModel(
        sessionType: 'flashcard',
        startedAt: now,
      );

      final copy = model.copyWith(completedAt: later, itemsReviewed: 5);

      expect(copy.completedAt, later);
      expect(copy.itemsReviewed, 5);
      expect(copy.sessionType, 'flashcard');
    });
  });
}
