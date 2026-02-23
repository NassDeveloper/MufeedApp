/// Abstract analytics service for tracking anonymous usage events.
///
/// The domain layer defines the contract; the data layer provides
/// the implementation (NoOp for now, Firebase when configured).
abstract class AnalyticsService {
  /// Enables or disables analytics collection.
  ///
  /// When disabled, [logEvent] calls are silently ignored.
  Future<void> setEnabled(bool enabled);

  /// Logs an anonymous analytics event.
  ///
  /// Events are only sent if analytics is enabled (GDPR consent granted).
  Future<void> logEvent(String name, {Map<String, Object>? params});
}
