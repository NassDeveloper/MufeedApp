import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/core/constants/notification_constants.dart';
import 'package:mufeed_app/domain/models/notification_preferences_model.dart';
import 'package:mufeed_app/domain/usecases/notification_scheduler.dart';

// Test date constants (DateTime is not const-constructible).
final _jan1At8 = DateTime(2026, 1, 1, 8);
final _jan1At10 = DateTime(2026, 1, 1, 10);
final _dec31 = DateTime(2025, 12, 31, 15);

void main() {
  const scheduler = NotificationScheduler();

  NotificationPreferences enabledPrefs({int hour = 9, int minute = 0}) =>
      NotificationPreferences(enabled: true, hour: hour, minute: minute);

  const disabledPrefs = NotificationPreferences();

  group('NotificationScheduler.computeSchedule', () {
    test('returns empty list when notifications disabled and no streak', () {
      final result = scheduler.computeSchedule(
        prefs: disabledPrefs,
        context: NotificationContext(now: _jan1At10),
      );
      expect(result, isEmpty);
    });

    test('schedules daily reminder when enabled', () {
      final result = scheduler.computeSchedule(
        prefs: enabledPrefs(hour: 9, minute: 30),
        context: NotificationContext(now: _jan1At8),
      );
      final daily = result.where(
        (n) => n.id == NotificationConstants.dailyReminderId,
      );
      expect(daily, hasLength(1));
      expect(daily.first.repeating, isTrue);
      expect(daily.first.scheduledDate.hour, 9);
      expect(daily.first.scheduledDate.minute, 30);
    });

    test('daily reminder schedules for next day if time already passed', () {
      final result = scheduler.computeSchedule(
        prefs: enabledPrefs(hour: 8),
        context: NotificationContext(now: _jan1At10),
      );
      final daily = result.firstWhere(
        (n) => n.id == NotificationConstants.dailyReminderId,
      );
      expect(daily.scheduledDate.day, 2); // Next day
    });

    test('does not schedule daily reminder when disabled', () {
      final result = scheduler.computeSchedule(
        prefs: disabledPrefs,
        context: NotificationContext(
          now: _jan1At10,
          currentStreak: 5,
          lastActivityDate: _dec31,
        ),
      );
      final daily = result.where(
        (n) => n.id == NotificationConstants.dailyReminderId,
      );
      expect(daily, isEmpty);
    });

    test('schedules streak danger when streak > 0 and no activity today', () {
      final result = scheduler.computeSchedule(
        prefs: disabledPrefs,
        context: NotificationContext(
          now: _jan1At10,
          currentStreak: 5,
          lastActivityDate: _dec31,
        ),
      );
      final danger = result.where(
        (n) => n.id == NotificationConstants.streakDangerId,
      );
      expect(danger, hasLength(1));
      expect(danger.first.scheduledDate.hour, 20);
      expect(danger.first.repeating, isFalse);
    });

    test('does not schedule streak danger when streak is 0', () {
      final result = scheduler.computeSchedule(
        prefs: disabledPrefs,
        context: NotificationContext(
          now: _jan1At10,
          currentStreak: 0,
          lastActivityDate: _dec31,
        ),
      );
      final danger = result.where(
        (n) => n.id == NotificationConstants.streakDangerId,
      );
      expect(danger, isEmpty);
    });

    test('does not schedule streak danger when activity is today', () {
      final result = scheduler.computeSchedule(
        prefs: disabledPrefs,
        context: NotificationContext(
          now: _jan1At10,
          currentStreak: 5,
          lastActivityDate: DateTime(2026, 1, 1, 8), // Today at 8am
        ),
      );
      final danger = result.where(
        (n) => n.id == NotificationConstants.streakDangerId,
      );
      expect(danger, isEmpty);
    });

    test('does not schedule streak danger when 20h already passed', () {
      final result = scheduler.computeSchedule(
        prefs: disabledPrefs,
        context: NotificationContext(
          now: DateTime(2026, 1, 1, 21), // 21:00
          currentStreak: 5,
          lastActivityDate: _dec31,
        ),
      );
      final danger = result.where(
        (n) => n.id == NotificationConstants.streakDangerId,
      );
      expect(danger, isEmpty);
    });

    test('schedules 3-day re-engagement notification', () {
      final result = scheduler.computeSchedule(
        prefs: disabledPrefs,
        context: NotificationContext(
          now: _jan1At10,
          lastActivityDate: _dec31, // Yesterday
        ),
      );
      final reengage3 = result.where(
        (n) => n.id == NotificationConstants.reengagement3DaysId,
      );
      expect(reengage3, hasLength(1));
      // Dec 31 + 3 days = Jan 3 at 10:00
      expect(reengage3.first.scheduledDate, DateTime(2026, 1, 3, 10));
    });

    test('schedules 7-day re-engagement notification', () {
      final result = scheduler.computeSchedule(
        prefs: disabledPrefs,
        context: NotificationContext(
          now: _jan1At10,
          lastActivityDate: _dec31,
        ),
      );
      final reengage7 = result.where(
        (n) => n.id == NotificationConstants.reengagement7DaysId,
      );
      expect(reengage7, hasLength(1));
      // Dec 31 + 7 days = Jan 7 at 10:00
      expect(reengage7.first.scheduledDate, DateTime(2026, 1, 7, 10));
    });

    test('does not schedule re-engagement if date already passed', () {
      final result = scheduler.computeSchedule(
        prefs: disabledPrefs,
        context: NotificationContext(
          now: DateTime(2026, 1, 10), // Jan 10
          lastActivityDate: _dec31, // Dec 31
        ),
      );
      // Both 3-day (Jan 3) and 7-day (Jan 7) are in the past
      final reengage = result.where(
        (n) =>
            n.id == NotificationConstants.reengagement3DaysId ||
            n.id == NotificationConstants.reengagement7DaysId,
      );
      expect(reengage, isEmpty);
    });

    test('does not schedule re-engagement when no lastActivityDate', () {
      final result = scheduler.computeSchedule(
        prefs: disabledPrefs,
        context: NotificationContext(now: _jan1At10),
      );
      final reengage = result.where(
        (n) =>
            n.id == NotificationConstants.reengagement3DaysId ||
            n.id == NotificationConstants.reengagement7DaysId,
      );
      expect(reengage, isEmpty);
    });

    test('schedules multiple notifications at once', () {
      final result = scheduler.computeSchedule(
        prefs: enabledPrefs(),
        context: NotificationContext(
          now: _jan1At8,
          currentStreak: 3,
          lastActivityDate: _dec31,
        ),
      );
      // daily + streak danger + 3-day + 7-day = 4
      expect(result, hasLength(4));
    });
  });
}
