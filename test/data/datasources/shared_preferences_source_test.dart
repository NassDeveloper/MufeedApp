import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mufeed_app/data/datasources/shared_preferences_source.dart';

void main() {
  group('SharedPreferencesSource', () {
    late SharedPreferencesSource source;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      source = SharedPreferencesSource(prefs);
    });

    test('getContentVersion returns 0 by default', () {
      expect(source.getContentVersion(), 0);
    });

    test('setContentVersion and getContentVersion round-trip', () async {
      await source.setContentVersion(1);
      expect(source.getContentVersion(), 1);
    });

    test('setContentVersion overwrites previous value', () async {
      await source.setContentVersion(1);
      await source.setContentVersion(2);
      expect(source.getContentVersion(), 2);
    });

    test('getLastVisitedLessonId returns null by default', () {
      expect(source.getLastVisitedLessonId(), isNull);
    });

    test('getLastVisitedLessonName returns null by default', () {
      expect(source.getLastVisitedLessonName(), isNull);
    });

    test('getLastVisitedLessonRoute returns null by default', () {
      expect(source.getLastVisitedLessonRoute(), isNull);
    });

    test('setLastVisitedLesson persists all three values', () async {
      await source.setLastVisitedLesson(
        lessonId: 42,
        lessonName: 'Les salutations',
        route: '/vocabulary/level/1/unit/1/lesson/42',
      );
      expect(source.getLastVisitedLessonId(), 42);
      expect(source.getLastVisitedLessonName(), 'Les salutations');
      expect(source.getLastVisitedLessonRoute(),
          '/vocabulary/level/1/unit/1/lesson/42');
    });

    test('setLastVisitedLesson overwrites previous values', () async {
      await source.setLastVisitedLesson(
        lessonId: 1,
        lessonName: 'Leçon 1',
        route: '/vocabulary/level/1/unit/1/lesson/1',
      );
      await source.setLastVisitedLesson(
        lessonId: 5,
        lessonName: 'Leçon 5',
        route: '/vocabulary/level/1/unit/2/lesson/5',
      );
      expect(source.getLastVisitedLessonId(), 5);
      expect(source.getLastVisitedLessonName(), 'Leçon 5');
      expect(source.getLastVisitedLessonRoute(),
          '/vocabulary/level/1/unit/2/lesson/5');
    });

    test('isOnboardingCompleted returns false by default', () {
      expect(source.isOnboardingCompleted(), false);
    });

    test('setOnboardingCompleted and isOnboardingCompleted round-trip',
        () async {
      await source.setOnboardingCompleted(true);
      expect(source.isOnboardingCompleted(), true);
    });

    test('getLearningMode returns null by default', () {
      expect(source.getLearningMode(), isNull);
    });

    test('setLearningMode and getLearningMode round-trip', () async {
      await source.setLearningMode('curriculum');
      expect(source.getLearningMode(), 'curriculum');
    });

    test('getActiveLevelId returns null by default', () {
      expect(source.getActiveLevelId(), isNull);
    });

    test('setActiveLevelId and getActiveLevelId round-trip', () async {
      await source.setActiveLevelId(3);
      expect(source.getActiveLevelId(), 3);
    });

    test('getLocale returns null by default', () {
      expect(source.getLocale(), isNull);
    });

    test('setLocale and getLocale round-trip', () async {
      await source.setLocale('en');
      expect(source.getLocale(), 'en');
    });
  });
}
