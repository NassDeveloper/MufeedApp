import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/reviewable_item_model.dart';
import 'package:mufeed_app/domain/models/user_progress_model.dart';
import 'package:mufeed_app/domain/usecases/session_builder.dart';

ReviewableItemModel _dueItem(int id, DateTime nextReview) => ReviewableItemModel(
      itemId: id,
      contentType: 'vocab',
      arabic: 'عربي $id',
      translationFr: 'mot $id',
      sortOrder: id,
      progress: UserProgressModel(
        itemId: id,
        contentType: 'vocab',
        state: 'review',
        nextReview: nextReview,
        stability: 1,
        difficulty: 0.5,
      ),
    );

ReviewableItemModel _newItem(int id) => ReviewableItemModel(
      itemId: id,
      contentType: 'vocab',
      arabic: 'جديد $id',
      translationFr: 'nouveau $id',
      sortOrder: id,
    );

ReviewableItemModel _learningItem(int id) => ReviewableItemModel(
      itemId: id,
      contentType: 'vocab',
      arabic: 'تعلم $id',
      translationFr: 'apprendre $id',
      sortOrder: id,
      progress: UserProgressModel(
        itemId: id,
        contentType: 'vocab',
        state: 'learning',
      ),
    );

void main() {
  late SessionBuilder builder;

  setUp(() {
    builder = const SessionBuilder();
  });

  group('SessionBuilder.buildDailySession', () {
    test('due items are sorted by nextReview ASC (most overdue first)', () {
      final now = DateTime(2026, 2, 22);
      final dueItems = [
        _dueItem(1, now.subtract(const Duration(days: 1))),
        _dueItem(2, now.subtract(const Duration(days: 5))),
        _dueItem(3, now.subtract(const Duration(days: 3))),
      ];

      final result = builder.buildDailySession(
        dueItems: dueItems,
        newItems: [],
      );

      expect(result.length, 3);
      expect(result[0].itemId, 2); // 5 days overdue
      expect(result[1].itemId, 3); // 3 days overdue
      expect(result[2].itemId, 1); // 1 day overdue
    });

    test('new items are appended after due items', () {
      final now = DateTime(2026, 2, 22);
      final dueItems = [_dueItem(1, now)];
      final newItems = [_newItem(10), _newItem(11)];

      final result = builder.buildDailySession(
        dueItems: dueItems,
        newItems: newItems,
      );

      expect(result.length, 3);
      expect(result[0].itemId, 1); // due item first
      expect(result[1].itemId, 10); // new item
      expect(result[2].itemId, 11); // new item
    });

    test('maxNewItems limits new items added', () {
      final newItems = [
        _newItem(1),
        _newItem(2),
        _newItem(3),
        _newItem(4),
        _newItem(5),
        _newItem(6),
      ];

      final result = builder.buildDailySession(
        dueItems: [],
        newItems: newItems,
        maxNewItems: 3,
      );

      expect(result.length, 3);
      expect(result[0].itemId, 1);
      expect(result[2].itemId, 3);
    });

    test('default maxNewItems is 5', () {
      final newItems = List.generate(10, (i) => _newItem(i + 1));

      final result = builder.buildDailySession(
        dueItems: [],
        newItems: newItems,
      );

      expect(result.length, 5);
    });

    test('only items with effectiveState == new are taken from newItems', () {
      final mixedItems = [
        _newItem(1), // effectiveState == 'new'
        _learningItem(2), // effectiveState == 'learning'
        _newItem(3), // effectiveState == 'new'
      ];

      final result = builder.buildDailySession(
        dueItems: [],
        newItems: mixedItems,
      );

      expect(result.length, 2);
      expect(result[0].itemId, 1);
      expect(result[1].itemId, 3);
    });

    test('returns empty list when no due items and no new items', () {
      final result = builder.buildDailySession(
        dueItems: [],
        newItems: [],
      );

      expect(result, isEmpty);
    });

    test('due items only (no new items available)', () {
      final now = DateTime(2026, 2, 22);
      final dueItems = [_dueItem(1, now), _dueItem(2, now)];

      final result = builder.buildDailySession(
        dueItems: dueItems,
        newItems: [],
      );

      expect(result.length, 2);
    });

    test('all due items are included regardless of count', () {
      final now = DateTime(2026, 2, 22);
      final dueItems = List.generate(
        50,
        (i) => _dueItem(i + 1, now.subtract(Duration(days: i))),
      );

      final result = builder.buildDailySession(
        dueItems: dueItems,
        newItems: [],
      );

      expect(result.length, 50);
    });

    test('duplicates between due and new items are excluded', () {

      final now = DateTime(2026, 2, 22);
      // Item id=1 appears as due (with progress) AND in newItems (without progress)
      final dueItems = [_dueItem(1, now), _dueItem(2, now)];
      final newItems = [_newItem(1), _newItem(3), _newItem(4)];

      final result = builder.buildDailySession(
        dueItems: dueItems,
        newItems: newItems,
      );

      // Due: 1, 2. New: 3, 4 (item 1 excluded as duplicate)
      expect(result.length, 4);
      expect(result.map((e) => e.itemId).toList(), [1, 2, 3, 4]);
    });
  });

  group('SessionBuilder.buildResumeSession', () {
    ReviewableItemModel reviewItem(int id, DateTime? lastReview) =>
        ReviewableItemModel(
          itemId: id,
          contentType: 'vocab',
          arabic: 'عربي $id',
          translationFr: 'mot $id',
          sortOrder: id,
          progress: UserProgressModel(
            itemId: id,
            contentType: 'vocab',
            state: 'review',
            lastReview: lastReview,
            nextReview: DateTime(2026, 2, 10),
          ),
        );

    ReviewableItemModel relearningItem(int id, DateTime? lastReview) =>
        ReviewableItemModel(
          itemId: id,
          contentType: 'vocab',
          arabic: 'عربي $id',
          translationFr: 'mot $id',
          sortOrder: id,
          progress: UserProgressModel(
            itemId: id,
            contentType: 'vocab',
            state: 'relearning',
            lastReview: lastReview,
          ),
        );

    test('sorts by lastReview ascending (oldest first)', () {
      final items = [
        reviewItem(1, DateTime(2026, 2, 15)),
        reviewItem(2, DateTime(2026, 2, 10)),
        reviewItem(3, DateTime(2026, 2, 20)),
      ];

      final result = builder.buildResumeSession(overdueItems: items);

      expect(result.map((e) => e.itemId).toList(), [2, 1, 3]);
    });

    test('null lastReview comes first', () {
      final items = [
        reviewItem(1, DateTime(2026, 2, 15)),
        reviewItem(2, null),
        reviewItem(3, DateTime(2026, 2, 10)),
      ];

      final result = builder.buildResumeSession(overdueItems: items);

      expect(result[0].itemId, 2); // null lastReview first
      expect(result[1].itemId, 3);
      expect(result[2].itemId, 1);
    });

    test('respects maxItems limit', () {
      final items = List.generate(
        20,
        (i) => reviewItem(
          i + 1,
          DateTime(2026, 2, 1).add(Duration(days: i)),
        ),
      );

      final result = builder.buildResumeSession(
        overdueItems: items,
        maxItems: 10,
      );

      expect(result.length, 10);
    });

    test('default maxItems is 12', () {
      final items = List.generate(
        20,
        (i) => reviewItem(
          i + 1,
          DateTime(2026, 2, 1).add(Duration(days: i)),
        ),
      );

      final result = builder.buildResumeSession(overdueItems: items);

      expect(result.length, 12);
    });

    test('excludes items with effectiveState == new', () {
      final items = [
        reviewItem(1, DateTime(2026, 2, 10)),
        _newItem(2), // effectiveState == 'new' → excluded
        reviewItem(3, DateTime(2026, 2, 15)),
      ];

      final result = builder.buildResumeSession(overdueItems: items);

      expect(result.length, 2);
      expect(result.map((e) => e.itemId).toList(), [1, 3]);
    });

    test('includes learning and relearning items', () {
      final items = [
        reviewItem(1, DateTime(2026, 2, 15)),
        _learningItem(2), // effectiveState == 'learning'
        relearningItem(3, DateTime(2026, 2, 10)),
      ];

      final result = builder.buildResumeSession(overdueItems: items);

      expect(result.length, 3);
    });

    test('returns empty list when no eligible items', () {
      final items = [_newItem(1), _newItem(2)];

      final result = builder.buildResumeSession(overdueItems: items);

      expect(result, isEmpty);
    });

    test('returns empty list when input is empty', () {
      final result = builder.buildResumeSession(overdueItems: []);

      expect(result, isEmpty);
    });
  });
}
