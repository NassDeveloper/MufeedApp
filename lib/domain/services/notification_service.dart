/// Abstract notification service for scheduling local notifications.
///
/// The domain layer defines the contract; the data layer provides
/// the platform-specific implementation via flutter_local_notifications.
abstract class NotificationService {
  /// Initializes the notification plugin and timezone data.
  Future<void> initialize();

  /// Requests notification permission from the OS.
  ///
  /// Returns `true` if permission was granted, `false` otherwise.
  Future<bool> requestPermission();

  /// Schedules a daily repeating notification at the given [hour] and [minute].
  Future<void> scheduleDailyReminder({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  });

  /// Schedules a one-shot notification at [scheduledDate].
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  });

  /// Cancels the notification with the given [id].
  Future<void> cancelNotification(int id);

  /// Cancels all scheduled notifications.
  Future<void> cancelAll();
}
