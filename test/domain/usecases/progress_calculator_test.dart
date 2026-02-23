import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/core/constants/srs_constants.dart';
import 'package:mufeed_app/domain/usecases/progress_calculator.dart';

void main() {
  late ProgressCalculator calculator;

  setUp(() {
    calculator = ProgressCalculator();
  });

  group('calculateLessonMasteryPercent', () {
    test('returns 1.0 for empty lesson (0 items)', () {
      expect(calculator.calculateLessonMasteryPercent(0, 0), 1.0);
    });

    test('returns 0.0 when no items mastered', () {
      expect(calculator.calculateLessonMasteryPercent(10, 0), 0.0);
    });

    test('returns 1.0 when all items mastered', () {
      expect(calculator.calculateLessonMasteryPercent(10, 10), 1.0);
    });

    test('returns correct percentage', () {
      expect(calculator.calculateLessonMasteryPercent(10, 8), 0.8);
    });

    test('returns correct percentage for partial mastery', () {
      expect(calculator.calculateLessonMasteryPercent(5, 3), 0.6);
    });
  });

  group('isLessonMastered', () {
    test('returns true when percentage equals threshold', () {
      expect(calculator.isLessonMastered(10, 8), isTrue);
    });

    test('returns true when percentage exceeds threshold', () {
      expect(calculator.isLessonMastered(10, 9), isTrue);
    });

    test('returns false when percentage below threshold', () {
      expect(calculator.isLessonMastered(10, 7), isFalse);
    });

    test('returns true for empty lesson', () {
      expect(calculator.isLessonMastered(0, 0), isTrue);
    });

    test('uses SrsConstants.masteryThreshold by default', () {
      // 80% threshold
      expect(SrsConstants.masteryThreshold, 0.8);
      expect(calculator.isLessonMastered(10, 8), isTrue);
      expect(calculator.isLessonMastered(10, 7), isFalse);
    });

    test('respects custom threshold', () {
      expect(
        calculator.isLessonMastered(10, 5, threshold: 0.5),
        isTrue,
      );
      expect(
        calculator.isLessonMastered(10, 4, threshold: 0.5),
        isFalse,
      );
    });
  });

  group('findNextLessonToStudy', () {
    test('returns null when list is empty', () {
      expect(calculator.findNextLessonToStudy([]), isNull);
    });

    test('returns null when all lessons mastered', () {
      final lessons = [
        const LessonWithProgress(lessonId: 1, totalItems: 10, masteredCount: 10),
        const LessonWithProgress(lessonId: 2, totalItems: 5, masteredCount: 5),
      ];
      expect(calculator.findNextLessonToStudy(lessons), isNull);
    });

    test('returns first non-mastered lesson', () {
      final lessons = [
        const LessonWithProgress(lessonId: 1, totalItems: 10, masteredCount: 10),
        const LessonWithProgress(lessonId: 2, totalItems: 10, masteredCount: 5),
        const LessonWithProgress(lessonId: 3, totalItems: 10, masteredCount: 0),
      ];
      expect(calculator.findNextLessonToStudy(lessons), 2);
    });

    test('returns first lesson when none mastered', () {
      final lessons = [
        const LessonWithProgress(lessonId: 1, totalItems: 10, masteredCount: 0),
        const LessonWithProgress(lessonId: 2, totalItems: 10, masteredCount: 0),
      ];
      expect(calculator.findNextLessonToStudy(lessons), 1);
    });

    test('skips empty lessons (considered mastered)', () {
      final lessons = [
        const LessonWithProgress(lessonId: 1, totalItems: 0, masteredCount: 0),
        const LessonWithProgress(lessonId: 2, totalItems: 10, masteredCount: 5),
      ];
      expect(calculator.findNextLessonToStudy(lessons), 2);
    });
  });
}
