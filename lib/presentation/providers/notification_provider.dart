import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/notification_constants.dart';
import '../../domain/models/notification_preferences_model.dart';
import '../../domain/services/notification_service.dart';
import '../../domain/usecases/notification_scheduler.dart';
import 'preferences_provider.dart';
import 'streak_provider.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError(
    'notificationServiceProvider must be overridden in main.dart',
  );
});

final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  return const NotificationScheduler();
});

/// Notifier for notification preferences.
///
/// Loads from SharedPreferences on build, persists changes immediately,
/// and triggers notification rescheduling on every change.
class NotificationPreferencesNotifier
    extends Notifier<NotificationPreferences> {
  @override
  NotificationPreferences build() {
    final prefs = ref.read(sharedPreferencesSourceProvider);
    return NotificationPreferences(
      enabled: prefs.isNotificationEnabled(),
      hour: prefs.getNotificationHour(),
      minute: prefs.getNotificationMinute(),
    );
  }

  Future<bool> setEnabled(bool enabled) async {
    if (enabled) {
      final service = ref.read(notificationServiceProvider);
      final granted = await service.requestPermission();
      if (!granted) return false;
    }

    final prefs = ref.read(sharedPreferencesSourceProvider);
    await prefs.setNotificationEnabled(enabled);
    state = state.copyWith(enabled: enabled);
    await rescheduleAllNotifications(ref);
    return true;
  }

  Future<void> setTime({required int hour, required int minute}) async {
    final prefs = ref.read(sharedPreferencesSourceProvider);
    await Future.wait([
      prefs.setNotificationHour(hour),
      prefs.setNotificationMinute(minute),
    ]);
    state = state.copyWith(hour: hour, minute: minute);
    await rescheduleAllNotifications(ref);
  }
}

final notificationPreferencesProvider =
    NotifierProvider<NotificationPreferencesNotifier, NotificationPreferences>(
  NotificationPreferencesNotifier.new,
);

/// Notification content resolved by locale.
///
/// Notifications fire in the background without a [BuildContext], so we
/// resolve the locale from SharedPreferences and use a simple lookup
/// instead of AppLocalizations.
({String title, String body}) _notificationContent(
  int id,
  String locale,
) {
  final isFr = locale == 'fr';
  return switch (id) {
    NotificationConstants.dailyReminderId => (
        title: isFr ? 'Mufeed' : 'Mufeed',
        body: isFr
            ? 'C\'est l\'heure de réviser tes mots arabes !'
            : 'Time to review your Arabic words!',
      ),
    NotificationConstants.streakDangerId => (
        title: isFr ? 'Streak en danger !' : 'Streak at risk!',
        body: isFr
            ? 'Tes mots t\'attendent ! Révise pour continuer ta série.'
            : 'Your words are waiting! Review to keep your streak.',
      ),
    NotificationConstants.reengagement3DaysId => (
        title: isFr ? 'Tu nous manques !' : 'We miss you!',
        body: isFr
            ? 'Ça fait 3 jours. Prêt à reprendre l\'arabe ?'
            : 'It\'s been 3 days. Ready to get back to Arabic?',
      ),
    NotificationConstants.reengagement7DaysId => (
        title: isFr ? 'Reprends en douceur' : 'Ease back in',
        body: isFr
            ? 'Une petite session pour se remettre dans le bain ?'
            : 'A quick session to get back on track?',
      ),
    _ => (title: '', body: ''),
  };
}

/// Reschedules all notifications based on current preferences and streak state.
///
/// Cancels all existing notifications, then schedules new ones as computed
/// by [NotificationScheduler].
Future<void> rescheduleAllNotifications(Ref ref) async {
  try {
    final service = ref.read(notificationServiceProvider);
    final scheduler = ref.read(notificationSchedulerProvider);
    final notifPrefs = ref.read(notificationPreferencesProvider);
    final prefsSource = ref.read(sharedPreferencesSourceProvider);
    final clock = ref.read(clockProvider);
    final now = clock();

    final locale = prefsSource.getLocale() ?? 'fr';

    final streakRepo = ref.read(streakRepositoryProvider);
    final streak = await streakRepo.getStreak();
    final lastActivity = await streakRepo.getLastActivityDate();

    final context = NotificationContext(
      now: now,
      lastActivityDate: lastActivity,
      currentStreak: streak?.currentStreak ?? 0,
    );

    final schedule = scheduler.computeSchedule(
      prefs: notifPrefs,
      context: context,
    );

    await service.cancelAll();

    for (final notification in schedule) {
      final content = _notificationContent(notification.id, locale);

      if (notification.repeating) {
        await service.scheduleDailyReminder(
          id: notification.id,
          hour: notifPrefs.hour,
          minute: notifPrefs.minute,
          title: content.title,
          body: content.body,
        );
      } else {
        await service.scheduleNotification(
          id: notification.id,
          title: content.title,
          body: content.body,
          scheduledDate: notification.scheduledDate,
        );
      }
    }
  } catch (e) {
    debugPrint('Notification scheduling failed: $e');
  }
}
