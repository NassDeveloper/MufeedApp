import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/badge_model.dart';
import 'package:mufeed_app/domain/models/badge_type.dart';

void main() {
  group('BadgeModel', () {
    test('isUnlocked returns false when unlockedAt is null', () {
      const badge = BadgeModel(
        id: 1,
        badgeType: BadgeType.firstWordReviewed,
      );
      expect(badge.isUnlocked, false);
    });

    test('isUnlocked returns true when unlockedAt is set', () {
      final badge = BadgeModel(
        id: 1,
        badgeType: BadgeType.firstWordReviewed,
        unlockedAt: DateTime(2026, 1, 1),
      );
      expect(badge.isUnlocked, true);
    });

    test('copyWith preserves values when no args', () {
      final badge = BadgeModel(
        id: 1,
        badgeType: BadgeType.words10,
        unlockedAt: DateTime(2026, 1, 1),
        displayed: true,
      );
      final copy = badge.copyWith();
      expect(copy, badge);
    });

    test('copyWith updates unlockedAt to null', () {
      final badge = BadgeModel(
        id: 1,
        badgeType: BadgeType.words10,
        unlockedAt: DateTime(2026, 1, 1),
      );
      final copy = badge.copyWith(unlockedAt: null);
      expect(copy.unlockedAt, isNull);
    });

    test('equality works correctly', () {
      final a = BadgeModel(
        id: 1,
        badgeType: BadgeType.streak7,
        unlockedAt: DateTime(2026, 2, 1),
      );
      final b = BadgeModel(
        id: 1,
        badgeType: BadgeType.streak7,
        unlockedAt: DateTime(2026, 2, 1),
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('inequality when fields differ', () {
      const a = BadgeModel(id: 1, badgeType: BadgeType.streak7);
      const b = BadgeModel(id: 2, badgeType: BadgeType.streak7);
      expect(a, isNot(b));
    });
  });
}
