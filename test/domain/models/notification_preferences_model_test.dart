import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/notification_preferences_model.dart';

void main() {
  group('NotificationPreferences', () {
    test('has correct default values', () {
      const prefs = NotificationPreferences();
      expect(prefs.enabled, isFalse);
      expect(prefs.hour, 9);
      expect(prefs.minute, 0);
    });

    test('copyWith replaces only specified fields', () {
      const original = NotificationPreferences(
        enabled: false,
        hour: 9,
        minute: 0,
      );

      final withEnabled = original.copyWith(enabled: true);
      expect(withEnabled.enabled, isTrue);
      expect(withEnabled.hour, 9);
      expect(withEnabled.minute, 0);

      final withTime = original.copyWith(hour: 14, minute: 30);
      expect(withTime.enabled, isFalse);
      expect(withTime.hour, 14);
      expect(withTime.minute, 30);
    });

    test('copyWith with no arguments returns equal object', () {
      const original = NotificationPreferences(
        enabled: true,
        hour: 8,
        minute: 15,
      );
      final copy = original.copyWith();
      expect(copy, equals(original));
    });

    test('equality compares all fields', () {
      const a = NotificationPreferences(enabled: true, hour: 9, minute: 0);
      const b = NotificationPreferences(enabled: true, hour: 9, minute: 0);
      const c = NotificationPreferences(enabled: false, hour: 9, minute: 0);
      const d = NotificationPreferences(enabled: true, hour: 10, minute: 0);
      const e = NotificationPreferences(enabled: true, hour: 9, minute: 30);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a, isNot(equals(d)));
      expect(a, isNot(equals(e)));
    });

    test('hashCode is consistent with equality', () {
      const a = NotificationPreferences(enabled: true, hour: 9, minute: 0);
      const b = NotificationPreferences(enabled: true, hour: 9, minute: 0);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('toString includes all fields', () {
      const prefs = NotificationPreferences(
        enabled: true,
        hour: 14,
        minute: 30,
      );
      final str = prefs.toString();
      expect(str, contains('enabled: true'));
      expect(str, contains('hour: 14'));
      expect(str, contains('minute: 30'));
    });
  });
}
