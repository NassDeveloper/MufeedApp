import 'package:flutter/foundation.dart';

@immutable
class NotificationPreferences {
  const NotificationPreferences({
    this.enabled = false,
    this.hour = 9,
    this.minute = 0,
  });

  final bool enabled;
  final int hour;
  final int minute;

  NotificationPreferences copyWith({
    bool? enabled,
    int? hour,
    int? minute,
  }) {
    return NotificationPreferences(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPreferences &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled &&
          hour == other.hour &&
          minute == other.minute;

  @override
  int get hashCode => Object.hash(enabled, hour, minute);

  @override
  String toString() =>
      'NotificationPreferences(enabled: $enabled, hour: $hour, minute: $minute)';
}
