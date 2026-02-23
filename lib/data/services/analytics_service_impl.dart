import 'package:flutter/foundation.dart';

import '../../domain/services/analytics_service.dart';

/// NoOp analytics implementation.
///
/// Logs events to debug console only. Replace with a Firebase implementation
/// when `firebase_analytics` is configured in the project.
class AnalyticsServiceImpl implements AnalyticsService {
  bool _enabled = false;

  @override
  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    debugPrint('Analytics ${enabled ? 'enabled' : 'disabled'}');
  }

  @override
  Future<void> logEvent(String name, {Map<String, Object>? params}) async {
    if (!_enabled) return;
    debugPrint('Analytics event: $name${params != null ? ' $params' : ''}');
  }
}
