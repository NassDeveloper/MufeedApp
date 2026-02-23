import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/badge_type.dart';
import 'package:mufeed_app/presentation/extensions/badge_type_ui.dart';

void main() {
  group('BadgeType', () {
    test('all 10 values exist', () {
      expect(BadgeType.values, hasLength(10));
    });

    test('key returns the name', () {
      expect(BadgeType.firstWordReviewed.key, 'firstWordReviewed');
      expect(BadgeType.perfectQuiz.key, 'perfectQuiz');
    });

    test('fromKey returns correct type', () {
      for (final type in BadgeType.values) {
        expect(BadgeType.fromKey(type.key), type);
      }
    });

    test('fromKey returns null for unknown key', () {
      expect(BadgeType.fromKey('unknown'), isNull);
    });

    test('each type has a distinct icon via BadgeTypeUi extension', () {
      final icons = BadgeType.values.map((t) => t.icon).toSet();
      expect(icons.length, BadgeType.values.length);
    });
  });
}
