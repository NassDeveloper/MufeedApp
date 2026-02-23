abstract final class NotificationConstants {
  static const int dailyReminderId = 1;
  static const int streakDangerId = 2;
  static const int reengagement3DaysId = 3;
  static const int reengagement7DaysId = 4;

  static const String channelId = 'mufeed_reminders';
  static const String channelName = 'Rappels Mufeed';
  static const String channelDescription =
      'Rappels quotidiens et notifications de streak';

  /// Hour at which streak danger notification fires (20:00).
  static const int streakDangerHour = 20;

  /// Hour at which re-engagement notifications fire (10:00).
  static const int reengagementHour = 10;

  /// Days of inactivity before first re-engagement notification.
  static const int reengagement3Days = 3;

  /// Days of inactivity before second re-engagement notification.
  static const int reengagement7Days = 7;
}
