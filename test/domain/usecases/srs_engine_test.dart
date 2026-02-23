import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/usecases/srs_engine.dart';
import 'package:mufeed_app/domain/models/user_progress_model.dart';

void main() {
  late SrsEngine engine;

  setUp(() {
    engine = SrsEngine(enableFuzzing: false);
  });

  group('SrsEngine', () {
    test('first review creates progress with learning state', () {
      final result = engine.reviewItem(
        current: null,
        rating: 3,
        itemId: 1,
        contentType: 'vocab',
        now: DateTime.utc(2026, 2, 21, 12, 0),
      );

      expect(result.itemId, 1);
      expect(result.contentType, 'vocab');
      expect(result.reviewCount, 1);
      expect(result.reps, 1);
      expect(result.lastReview, isNotNull);
      expect(result.nextReview, isNotNull);
      expect(result.stability, greaterThan(0));
      expect(result.difficulty, greaterThan(0));
    });

    test('first review with state new creates progress', () {
      const current = UserProgressModel(
        itemId: 1,
        contentType: 'vocab',
        state: 'new',
      );

      final result = engine.reviewItem(
        current: current,
        rating: 3,
        itemId: 1,
        contentType: 'vocab',
        now: DateTime.utc(2026, 2, 21, 12, 0),
      );

      expect(result.reviewCount, 1);
      expect(result.stability, greaterThan(0));
    });

    test('rating 1 (again) produces shorter interval than rating 4 (easy)', () {
      final now = DateTime.utc(2026, 2, 21, 12, 0);

      final resultAgain = engine.reviewItem(
        current: null,
        rating: 1,
        itemId: 1,
        contentType: 'vocab',
        now: now,
      );

      final resultEasy = engine.reviewItem(
        current: null,
        rating: 4,
        itemId: 2,
        contentType: 'vocab',
        now: now,
      );

      expect(
        resultAgain.nextReview!.isBefore(resultEasy.nextReview!),
        isTrue,
        reason: 'Again should schedule earlier than Easy',
      );
    });

    test('all 4 ratings produce valid results', () {
      final now = DateTime.utc(2026, 2, 21, 12, 0);

      for (final rating in [1, 2, 3, 4]) {
        final result = engine.reviewItem(
          current: null,
          rating: rating,
          itemId: rating,
          contentType: 'vocab',
          now: now,
        );

        expect(result.stability, greaterThanOrEqualTo(0));
        expect(result.difficulty, greaterThanOrEqualTo(0));
        expect(result.nextReview, isNotNull);
        expect(result.lastReview, now);
      }
    });

    test('subsequent review updates existing progress', () {
      final now = DateTime.utc(2026, 2, 21, 12, 0);
      final later = DateTime.utc(2026, 2, 22, 12, 0);

      final first = engine.reviewItem(
        current: null,
        rating: 3,
        itemId: 1,
        contentType: 'vocab',
        now: now,
      );

      final second = engine.reviewItem(
        current: first,
        rating: 3,
        itemId: 1,
        contentType: 'vocab',
        now: later,
      );

      expect(second.reviewCount, 2);
      expect(second.reps, 2);
      expect(second.lastReview, later);
      expect(second.elapsedDays, 1);
    });

    test('preserves id from existing progress', () {
      final current = UserProgressModel(
        id: 42,
        itemId: 1,
        contentType: 'vocab',
        state: 'review',
        stability: 5.0,
        difficulty: 3.0,
        lastReview: DateTime.utc(2026, 2, 20, 12, 0),
        nextReview: DateTime.utc(2026, 2, 25, 12, 0),
        reviewCount: 3,
        reps: 3,
      );

      final result = engine.reviewItem(
        current: current,
        rating: 3,
        itemId: 1,
        contentType: 'vocab',
        now: DateTime.utc(2026, 2, 21, 12, 0),
      );

      expect(result.id, 42);
      expect(result.reviewCount, 4);
    });

    test('review with verb content type works', () {
      final result = engine.reviewItem(
        current: null,
        rating: 3,
        itemId: 1,
        contentType: 'verb',
        now: DateTime.utc(2026, 2, 21, 12, 0),
      );

      expect(result.contentType, 'verb');
    });
  });
}
