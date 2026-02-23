import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/streak_model.dart';
import 'package:mufeed_app/domain/usecases/streak_manager.dart';

StreakModel _makeStreak({
  int currentStreak = 5,
  int longestStreak = 10,
  required DateTime lastActivityDate,
  bool freezeAvailable = true,
  DateTime? freezeUsedDate,
}) {
  return StreakModel(
    id: 1,
    currentStreak: currentStreak,
    longestStreak: longestStreak,
    lastActivityDate: lastActivityDate,
    freezeAvailable: freezeAvailable,
    freezeUsedDate: freezeUsedDate,
  );
}

void main() {
  const manager = StreakManager();

  group('StreakManager.isAbsenceProlonged', () {
    test('returns true when absence is 4 days', () {
      final lastActivity = DateTime(2026, 2, 18);
      final now = DateTime(2026, 2, 22);
      expect(
        manager.isAbsenceProlonged(lastActivityDate: lastActivity, now: now),
        isTrue,
      );
    });

    test('returns true when absence is exactly 3 days', () {
      final lastActivity = DateTime(2026, 2, 19);
      final now = DateTime(2026, 2, 22);
      expect(
        manager.isAbsenceProlonged(lastActivityDate: lastActivity, now: now),
        isTrue,
      );
    });

    test('returns false when absence is 2 days', () {
      final lastActivity = DateTime(2026, 2, 20);
      final now = DateTime(2026, 2, 22);
      expect(
        manager.isAbsenceProlonged(lastActivityDate: lastActivity, now: now),
        isFalse,
      );
    });

    test('returns false when activity is same day', () {
      final lastActivity = DateTime(2026, 2, 22, 8, 30);
      final now = DateTime(2026, 2, 22, 20, 0);
      expect(
        manager.isAbsenceProlonged(lastActivityDate: lastActivity, now: now),
        isFalse,
      );
    });

    test('returns false when absence is 1 day', () {
      final lastActivity = DateTime(2026, 2, 21);
      final now = DateTime(2026, 2, 22);
      expect(
        manager.isAbsenceProlonged(lastActivityDate: lastActivity, now: now),
        isFalse,
      );
    });

    test('supports custom threshold', () {
      final lastActivity = DateTime(2026, 2, 15);
      final now = DateTime(2026, 2, 22);
      expect(
        manager.isAbsenceProlonged(
          lastActivityDate: lastActivity,
          now: now,
          thresholdDays: 7,
        ),
        isTrue,
      );
    });

    test('uses calendar days not 24h periods', () {
      // Last activity at 23:59 on day 1, now at 00:01 on day 4 → 3 calendar days
      final lastActivity = DateTime(2026, 2, 19, 23, 59);
      final now = DateTime(2026, 2, 22, 0, 1);
      expect(
        manager.isAbsenceProlonged(lastActivityDate: lastActivity, now: now),
        isTrue,
      );
    });
  });

  group('StreakManager.calculateStreakUpdate', () {
    test('returns unchanged model if already active today', () {
      final now = DateTime(2026, 2, 22, 18, 0);
      final streak = _makeStreak(
        currentStreak: 5,
        lastActivityDate: DateTime(2026, 2, 22, 8, 0),
      );
      final result = manager.calculateStreakUpdate(
        currentStreak: streak,
        now: now,
      );
      expect(result.currentStreak, 5);
      expect(result.lastActivityDate, streak.lastActivityDate);
    });

    test('increments streak if last activity was yesterday', () {
      final now = DateTime(2026, 2, 22);
      final streak = _makeStreak(
        currentStreak: 5,
        lastActivityDate: DateTime(2026, 2, 21),
      );
      final result = manager.calculateStreakUpdate(
        currentStreak: streak,
        now: now,
      );
      expect(result.currentStreak, 6);
      expect(result.lastActivityDate, now);
    });

    test('updates longest_streak when current exceeds it', () {
      final now = DateTime(2026, 2, 22);
      final streak = _makeStreak(
        currentStreak: 10,
        longestStreak: 10,
        lastActivityDate: DateTime(2026, 2, 21),
      );
      final result = manager.calculateStreakUpdate(
        currentStreak: streak,
        now: now,
      );
      expect(result.currentStreak, 11);
      expect(result.longestStreak, 11);
    });

    test('does not update longest_streak when current does not exceed', () {
      final now = DateTime(2026, 2, 22);
      final streak = _makeStreak(
        currentStreak: 3,
        longestStreak: 10,
        lastActivityDate: DateTime(2026, 2, 21),
      );
      final result = manager.calculateStreakUpdate(
        currentStreak: streak,
        now: now,
      );
      expect(result.currentStreak, 4);
      expect(result.longestStreak, 10);
    });

    test('uses freeze when absent 2 days and freeze available', () {
      final now = DateTime(2026, 2, 22);
      final streak = _makeStreak(
        currentStreak: 5,
        lastActivityDate: DateTime(2026, 2, 20), // avant-hier
        freezeAvailable: true,
      );
      final result = manager.calculateStreakUpdate(
        currentStreak: streak,
        now: now,
      );
      expect(result.currentStreak, 6);
      expect(result.freezeAvailable, false);
      expect(result.freezeUsedDate, now);
      expect(result.lastActivityDate, now);
    });

    test('resets streak when absent 2 days and no freeze', () {
      final now = DateTime(2026, 2, 22);
      final streak = _makeStreak(
        currentStreak: 5,
        lastActivityDate: DateTime(2026, 2, 20),
        freezeAvailable: false,
        freezeUsedDate: DateTime(2026, 2, 19),
      );
      final result = manager.calculateStreakUpdate(
        currentStreak: streak,
        now: now,
      );
      expect(result.currentStreak, 0);
      expect(result.lastActivityDate, now);
    });

    test('resets streak when absent 3+ days even with freeze', () {
      final now = DateTime(2026, 2, 22);
      final streak = _makeStreak(
        currentStreak: 5,
        lastActivityDate: DateTime(2026, 2, 19), // 3 jours
        freezeAvailable: true,
      );
      final result = manager.calculateStreakUpdate(
        currentStreak: streak,
        now: now,
      );
      expect(result.currentStreak, 0);
    });

    test('preserves longest_streak on reset', () {
      final now = DateTime(2026, 2, 22);
      final streak = _makeStreak(
        currentStreak: 5,
        longestStreak: 10,
        lastActivityDate: DateTime(2026, 2, 19),
      );
      final result = manager.calculateStreakUpdate(
        currentStreak: streak,
        now: now,
      );
      expect(result.currentStreak, 0);
      expect(result.longestStreak, 10);
    });

    test('refreshes freeze before calculating if new week', () {
      // Freeze used on Sunday 2026-02-15 (week 7)
      // Now is Monday 2026-02-16 (week 8) → freeze should be renewed
      // Last activity was Saturday 2026-02-14 (2 days before Monday)
      final now = DateTime(2026, 2, 16); // Monday
      final streak = _makeStreak(
        currentStreak: 5,
        lastActivityDate: DateTime(2026, 2, 14), // Saturday
        freezeAvailable: false,
        freezeUsedDate: DateTime(2026, 2, 15), // Sunday week 7
      );
      final result = manager.calculateStreakUpdate(
        currentStreak: streak,
        now: now,
      );
      // Freeze should have been refreshed (new week) then used
      expect(result.currentStreak, 6);
      expect(result.freezeAvailable, false);
      expect(result.freezeUsedDate, now);
    });

    test('uses calendar days not 24h periods', () {
      // 23:59 yesterday to 00:01 today = 1 calendar day
      final now = DateTime(2026, 2, 22, 0, 1);
      final streak = _makeStreak(
        currentStreak: 5,
        lastActivityDate: DateTime(2026, 2, 21, 23, 59),
      );
      final result = manager.calculateStreakUpdate(
        currentStreak: streak,
        now: now,
      );
      expect(result.currentStreak, 6);
    });

    test('returns unchanged model if now is before lastActivityDate', () {
      // Clock went backwards
      final now = DateTime(2026, 2, 20);
      final streak = _makeStreak(
        currentStreak: 5,
        lastActivityDate: DateTime(2026, 2, 22),
      );
      final result = manager.calculateStreakUpdate(
        currentStreak: streak,
        now: now,
      );
      expect(result.currentStreak, 5);
      expect(result.lastActivityDate, streak.lastActivityDate);
    });
  });

  group('StreakManager.shouldResetStreak', () {
    test('returns true when more than 1 calendar day gap', () {
      expect(
        manager.shouldResetStreak(
          lastActivityDate: DateTime(2026, 2, 20),
          now: DateTime(2026, 2, 22),
        ),
        isTrue,
      );
    });

    test('returns false when 1 calendar day gap (yesterday)', () {
      expect(
        manager.shouldResetStreak(
          lastActivityDate: DateTime(2026, 2, 21),
          now: DateTime(2026, 2, 22),
        ),
        isFalse,
      );
    });

    test('returns false when same day', () {
      expect(
        manager.shouldResetStreak(
          lastActivityDate: DateTime(2026, 2, 22, 8, 0),
          now: DateTime(2026, 2, 22, 20, 0),
        ),
        isFalse,
      );
    });
  });

  group('StreakManager.isFreezeAvailable', () {
    test('returns true when freeze is available', () {
      final streak = _makeStreak(
        lastActivityDate: DateTime(2026, 2, 22),
        freezeAvailable: true,
      );
      expect(
        manager.isFreezeAvailable(
          streak: streak,
          now: DateTime(2026, 2, 22),
        ),
        isTrue,
      );
    });

    test('returns false when freeze is not available same week', () {
      final streak = _makeStreak(
        lastActivityDate: DateTime(2026, 2, 22),
        freezeAvailable: false,
        freezeUsedDate: DateTime(2026, 2, 20), // same week
      );
      expect(
        manager.isFreezeAvailable(
          streak: streak,
          now: DateTime(2026, 2, 22),
        ),
        isFalse,
      );
    });

    test('returns true when freeze used last week and new week started', () {
      // Used on Sunday Feb 15 (week 7), now Monday Feb 16 (week 8)
      final streak = _makeStreak(
        lastActivityDate: DateTime(2026, 2, 15),
        freezeAvailable: false,
        freezeUsedDate: DateTime(2026, 2, 15),
      );
      expect(
        manager.isFreezeAvailable(
          streak: streak,
          now: DateTime(2026, 2, 16), // Monday next week
        ),
        isTrue,
      );
    });
  });

  group('StreakManager.refreshFreezeAvailability', () {
    test('returns unchanged if freeze already available', () {
      final streak = _makeStreak(
        lastActivityDate: DateTime(2026, 2, 22),
        freezeAvailable: true,
      );
      final result = manager.refreshFreezeAvailability(
        streak: streak,
        now: DateTime(2026, 2, 22),
      );
      expect(result.freezeAvailable, true);
    });

    test('returns unchanged if no freeze used date', () {
      final streak = _makeStreak(
        lastActivityDate: DateTime(2026, 2, 22),
        freezeAvailable: false,
        freezeUsedDate: null,
      );
      final result = manager.refreshFreezeAvailability(
        streak: streak,
        now: DateTime(2026, 2, 22),
      );
      expect(result.freezeAvailable, false);
    });

    test('renews freeze when new week started (Monday boundary)', () {
      // Freeze used Thursday Feb 19 (week 8)
      // Now Monday Feb 23 (week 9)
      final streak = _makeStreak(
        lastActivityDate: DateTime(2026, 2, 19),
        freezeAvailable: false,
        freezeUsedDate: DateTime(2026, 2, 19),
      );
      final result = manager.refreshFreezeAvailability(
        streak: streak,
        now: DateTime(2026, 2, 23),
      );
      expect(result.freezeAvailable, true);
    });

    test('does not renew freeze within same week', () {
      // Freeze used Monday Feb 16 (week 8)
      // Now Friday Feb 20 (still week 8)
      final streak = _makeStreak(
        lastActivityDate: DateTime(2026, 2, 16),
        freezeAvailable: false,
        freezeUsedDate: DateTime(2026, 2, 16),
      );
      final result = manager.refreshFreezeAvailability(
        streak: streak,
        now: DateTime(2026, 2, 20),
      );
      expect(result.freezeAvailable, false);
    });

    test('renews freeze across year boundary', () {
      // Freeze used Dec 30, 2025
      // Now Jan 5, 2026 (different ISO week)
      final streak = _makeStreak(
        lastActivityDate: DateTime(2025, 12, 30),
        freezeAvailable: false,
        freezeUsedDate: DateTime(2025, 12, 30),
      );
      final result = manager.refreshFreezeAvailability(
        streak: streak,
        now: DateTime(2026, 1, 5),
      );
      expect(result.freezeAvailable, true);
    });
  });
}
