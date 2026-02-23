import 'package:flutter/foundation.dart';

import '../../core/constants/notification_constants.dart';
import '../models/notification_preferences_model.dart';

/// A scheduled notification computed by [NotificationScheduler].
@immutable
class ScheduledNotification {
  const ScheduledNotification({
    required this.id,
    required this.scheduledDate,
    this.repeating = false,
  });

  final int id;
  final DateTime scheduledDate;
  final bool repeating;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduledNotification &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          scheduledDate == other.scheduledDate &&
          repeating == other.repeating;

  @override
  int get hashCode => Object.hash(id, scheduledDate, repeating);

  @override
  String toString() =>
      'ScheduledNotification(id: $id, scheduledDate: $scheduledDate, repeating: $repeating)';
}

/// Context for computing notification schedules.
@immutable
class NotificationContext {
  const NotificationContext({
    required this.now,
    this.lastActivityDate,
    this.currentStreak = 0,
  });

  final DateTime now;
  final DateTime? lastActivityDate;
  final int currentStreak;
}

/// Pure, functional use case that computes which notifications to schedule.
///
/// Same pattern as [BadgeManager] and [StreakManager] — `const`, no side
/// effects. Input = preferences + context, output = list of notifications.
class NotificationScheduler {
  const NotificationScheduler();

  /// Computes the list of notifications that should be scheduled.
  ///
  /// The caller is responsible for cancelling all existing notifications
  /// before scheduling these new ones.
  List<ScheduledNotification> computeSchedule({
    required NotificationPreferences prefs,
    required NotificationContext context,
  }) {
    final result = <ScheduledNotification>[];

    if (prefs.enabled) {
      result.add(_dailyReminder(prefs, context.now));
    }

    final streakDanger = _streakDanger(context);
    if (streakDanger != null) {
      result.add(streakDanger);
    }

    final reengagement3 = _reengagement(
      context,
      days: NotificationConstants.reengagement3Days,
      id: NotificationConstants.reengagement3DaysId,
    );
    if (reengagement3 != null) {
      result.add(reengagement3);
    }

    final reengagement7 = _reengagement(
      context,
      days: NotificationConstants.reengagement7Days,
      id: NotificationConstants.reengagement7DaysId,
    );
    if (reengagement7 != null) {
      result.add(reengagement7);
    }

    return result;
  }

  ScheduledNotification _dailyReminder(
    NotificationPreferences prefs,
    DateTime now,
  ) {
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      prefs.hour,
      prefs.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return ScheduledNotification(
      id: NotificationConstants.dailyReminderId,
      scheduledDate: scheduledDate,
      repeating: true,
    );
  }

  ScheduledNotification? _streakDanger(NotificationContext context) {
    if (context.currentStreak <= 0) return null;

    final lastActivity = context.lastActivityDate;
    if (lastActivity == null) return null;

    final today = DateTime(
      context.now.year,
      context.now.month,
      context.now.day,
    );
    final lastActivityDay = DateTime(
      lastActivity.year,
      lastActivity.month,
      lastActivity.day,
    );

    // If the user already had activity today, no danger.
    if (!lastActivityDay.isBefore(today)) return null;

    final dangerTime = DateTime(
      today.year,
      today.month,
      today.day,
      NotificationConstants.streakDangerHour,
    );

    // If it's already past the danger hour, don't schedule.
    if (dangerTime.isBefore(context.now)) return null;

    return ScheduledNotification(
      id: NotificationConstants.streakDangerId,
      scheduledDate: dangerTime,
    );
  }

  ScheduledNotification? _reengagement(
    NotificationContext context, {
    required int days,
    required int id,
  }) {
    final lastActivity = context.lastActivityDate;
    if (lastActivity == null) return null;

    final reengagementDate = DateTime(
      lastActivity.year,
      lastActivity.month,
      lastActivity.day + days,
      NotificationConstants.reengagementHour,
    );

    // If the date is already passed, the user is already back.
    if (reengagementDate.isBefore(context.now)) return null;

    return ScheduledNotification(
      id: id,
      scheduledDate: reengagementDate,
    );
  }
}
