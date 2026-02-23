import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/lesson_progress_model.dart';

void main() {
  group('LessonProgressModel', () {
    test('masteredPercentage calculates correctly', () {
      const progress = LessonProgressModel(totalItems: 20, masteredCount: 12);
      expect(progress.masteredPercentage, 0.6);
    });

    test('masteredPercentage returns 0 when totalItems is 0', () {
      const progress = LessonProgressModel(totalItems: 0, masteredCount: 0);
      expect(progress.masteredPercentage, 0.0);
    });

    test('equality works correctly', () {
      const p1 = LessonProgressModel(totalItems: 20, masteredCount: 12);
      const p2 = LessonProgressModel(totalItems: 20, masteredCount: 12);
      expect(p1, equals(p2));
      expect(p1.hashCode, p2.hashCode);
    });
  });
}
