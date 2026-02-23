import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/progress_stats_model.dart';

void main() {
  group('ProgressStatsModel', () {
    test('masteredCount returns reviewCount', () {
      const stats = ProgressStatsModel(
        totalItems: 100,
        newCount: 50,
        learningCount: 20,
        reviewCount: 25,
        relearningCount: 5,
        sessionCount: 10,
        vocabStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
        verbStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
      );

      expect(stats.masteredCount, 25);
    });

    test('masteredPercentage calculates correctly', () {
      const stats = ProgressStatsModel(
        totalItems: 100,
        newCount: 50,
        learningCount: 20,
        reviewCount: 25,
        relearningCount: 5,
        sessionCount: 10,
        vocabStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
        verbStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
      );

      expect(stats.masteredPercentage, 0.25);
    });

    test('masteredPercentage returns 0 when totalItems is 0', () {
      const stats = ProgressStatsModel(
        totalItems: 0,
        newCount: 0,
        learningCount: 0,
        reviewCount: 0,
        relearningCount: 0,
        sessionCount: 0,
        vocabStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
        verbStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
      );

      expect(stats.masteredPercentage, 0.0);
    });

    test('equality works correctly', () {
      const stats1 = ProgressStatsModel(
        totalItems: 100,
        newCount: 50,
        learningCount: 20,
        reviewCount: 25,
        relearningCount: 5,
        sessionCount: 10,
        vocabStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
        verbStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
      );

      const stats2 = ProgressStatsModel(
        totalItems: 100,
        newCount: 50,
        learningCount: 20,
        reviewCount: 25,
        relearningCount: 5,
        sessionCount: 10,
        vocabStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
        verbStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
      );

      expect(stats1, equals(stats2));
      expect(stats1.hashCode, stats2.hashCode);
    });

    test('inequality when fields differ', () {
      const stats1 = ProgressStatsModel(
        totalItems: 100,
        newCount: 50,
        learningCount: 20,
        reviewCount: 25,
        relearningCount: 5,
        sessionCount: 10,
        vocabStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
        verbStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
      );

      const stats2 = ProgressStatsModel(
        totalItems: 100,
        newCount: 50,
        learningCount: 20,
        reviewCount: 30,
        relearningCount: 5,
        sessionCount: 10,
        vocabStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
        verbStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
      );

      expect(stats1, isNot(equals(stats2)));
    });
  });
}
