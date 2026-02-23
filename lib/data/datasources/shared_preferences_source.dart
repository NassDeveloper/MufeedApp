import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSource {
  SharedPreferencesSource(this._prefs);

  final SharedPreferences _prefs;

  static const _contentVersionKey = 'content_version';
  static const _lastVisitedLessonIdKey = 'last_visited_lesson_id';
  static const _lastVisitedLessonNameKey = 'last_visited_lesson_name';
  static const _lastVisitedLessonRouteKey = 'last_visited_lesson_route';
  static const _flashcardSessionLessonIdKey = 'flashcard_session_lesson_id';
  static const _flashcardSessionIndexKey = 'flashcard_session_index';
  static const _onboardingCompletedKey = 'onboarding_completed';
  static const _learningModeKey = 'learning_mode';
  static const _activeLevelIdKey = 'active_level_id';
  static const _activeLessonIdKey = 'active_lesson_id';
  static const _localeKey = 'locale';
  static const _themeModeKey = 'theme_mode';
  static const _gdprConsentKey = 'gdpr_consent';
  static const _notificationEnabledKey = 'notification_enabled';
  static const _notificationHourKey = 'notification_hour';
  static const _notificationMinuteKey = 'notification_minute';

  int getContentVersion() => _prefs.getInt(_contentVersionKey) ?? 0;

  Future<void> setContentVersion(int version) =>
      _prefs.setInt(_contentVersionKey, version);

  int? getLastVisitedLessonId() => _prefs.getInt(_lastVisitedLessonIdKey);

  String? getLastVisitedLessonName() =>
      _prefs.getString(_lastVisitedLessonNameKey);

  String? getLastVisitedLessonRoute() =>
      _prefs.getString(_lastVisitedLessonRouteKey);

  Future<void> setLastVisitedLesson({
    required int lessonId,
    required String lessonName,
    required String route,
  }) async {
    await Future.wait([
      _prefs.setInt(_lastVisitedLessonIdKey, lessonId),
      _prefs.setString(_lastVisitedLessonNameKey, lessonName),
      _prefs.setString(_lastVisitedLessonRouteKey, route),
    ]);
  }

  int? getFlashcardSessionLessonId() =>
      _prefs.getInt(_flashcardSessionLessonIdKey);

  int? getFlashcardSessionIndex() =>
      _prefs.getInt(_flashcardSessionIndexKey);

  Future<void> saveFlashcardSession({
    required int lessonId,
    required int index,
  }) async {
    await Future.wait([
      _prefs.setInt(_flashcardSessionLessonIdKey, lessonId),
      _prefs.setInt(_flashcardSessionIndexKey, index),
    ]);
  }

  Future<void> clearFlashcardSession() async {
    await Future.wait([
      _prefs.remove(_flashcardSessionLessonIdKey),
      _prefs.remove(_flashcardSessionIndexKey),
    ]);
  }

  // Onboarding preferences

  bool isOnboardingCompleted() =>
      _prefs.getBool(_onboardingCompletedKey) ?? false;

  Future<void> setOnboardingCompleted(bool completed) =>
      _prefs.setBool(_onboardingCompletedKey, completed);

  String? getLearningMode() => _prefs.getString(_learningModeKey);

  Future<void> setLearningMode(String mode) =>
      _prefs.setString(_learningModeKey, mode);

  int? getActiveLevelId() => _prefs.getInt(_activeLevelIdKey);

  Future<void> setActiveLevelId(int levelId) =>
      _prefs.setInt(_activeLevelIdKey, levelId);

  int? getActiveLessonId() => _prefs.getInt(_activeLessonIdKey);

  Future<void> setActiveLessonId(int lessonId) =>
      _prefs.setInt(_activeLessonIdKey, lessonId);

  // Locale preference

  String? getLocale() => _prefs.getString(_localeKey);

  Future<void> setLocale(String locale) =>
      _prefs.setString(_localeKey, locale);

  // Theme preferences

  String? getThemeMode() => _prefs.getString(_themeModeKey);

  Future<void> setThemeMode(String mode) =>
      _prefs.setString(_themeModeKey, mode);

  // GDPR consent

  bool? getGdprConsent() => _prefs.getBool(_gdprConsentKey);

  Future<void> setGdprConsent(bool consent) =>
      _prefs.setBool(_gdprConsentKey, consent);

  // Notification preferences

  bool isNotificationEnabled() =>
      _prefs.getBool(_notificationEnabledKey) ?? false;

  Future<void> setNotificationEnabled(bool enabled) =>
      _prefs.setBool(_notificationEnabledKey, enabled);

  int getNotificationHour() => _prefs.getInt(_notificationHourKey) ?? 9;

  Future<void> setNotificationHour(int hour) =>
      _prefs.setInt(_notificationHourKey, hour);

  int getNotificationMinute() => _prefs.getInt(_notificationMinuteKey) ?? 0;

  Future<void> setNotificationMinute(int minute) =>
      _prefs.setInt(_notificationMinuteKey, minute);
}
