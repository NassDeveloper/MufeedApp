import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/data/datasources/shared_preferences_source.dart';
import 'package:mufeed_app/domain/models/reviewable_item_model.dart';
import 'package:mufeed_app/domain/models/session_model.dart';
import 'package:mufeed_app/domain/models/user_progress_model.dart';
import 'package:mufeed_app/domain/repositories/progress_repository.dart';
import 'package:mufeed_app/presentation/providers/learning_mode_provider.dart';
import 'package:mufeed_app/presentation/providers/preferences_provider.dart';
import 'package:mufeed_app/presentation/providers/srs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeProgressRepository implements ProgressRepository {
  List<({int lessonId, int totalItems, int masteredCount})>
      lessonProgressSummary = [];

  @override
  Future<List<({int lessonId, int totalItems, int masteredCount})>>
      getLessonProgressSummaryForLevel(int levelId) async =>
          lessonProgressSummary;

  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLesson(
          int lessonId) async =>
      [];
  @override
  Future<List<UserProgressModel>> getDueItems() async => [];
  @override
  Future<List<ReviewableItemModel>> getDueReviewableItems() async => [];
  @override
  Future<UserProgressModel?> getProgressForItem(
          int itemId, String contentType) async =>
      null;
  @override
  Future<void> saveProgress(UserProgressModel progress) async {}
  @override
  Future<int> createSession(SessionModel session) async => 1;
  @override
  Future<Map<String, int>> getProgressCountsByState() async => {};
  @override
  Future<int> getTotalItemCount() async => 0;
  @override
  Future<int> getSessionCount() async => 0;
  @override
  Future<List<UserProgressModel>> getProgressForLesson(int lessonId) async =>
      [];
  @override
  Future<int> getTotalItemCountForLesson(int lessonId) async => 0;

  @override
  Future<int> getTotalWordsReviewed() async => 0;
  @override
  Future<int> getCompletedLessonCount() async => 0;
  @override
  Future<bool> hasPerfectQuiz() async => false;
}

void main() {
  group('LearningModeNotifier', () {
    late ProviderContainer container;
    late FakeProgressRepository fakeProgressRepo;

    Future<ProviderContainer> createContainer({
      Map<String, Object>? prefsValues,
    }) async {
      SharedPreferences.setMockInitialValues(prefsValues ?? {});
      final prefs = await SharedPreferences.getInstance();
      final prefsSource = SharedPreferencesSource(prefs);

      return ProviderContainer(
        overrides: [
          sharedPreferencesSourceProvider.overrideWithValue(prefsSource),
          progressRepositoryProvider.overrideWithValue(fakeProgressRepo),
        ],
      );
    }

    setUp(() {
      fakeProgressRepo = FakeProgressRepository();
    });

    tearDown(() => container.dispose());

    test('initial state defaults to curriculum mode with level 1', () async {
      container = await createContainer();
      final state = await container.read(learningModeProvider.future);

      expect(state.mode, 'curriculum');
      expect(state.activeLevelId, 1);
      expect(state.activeLessonId, isNull);
      expect(state.suggestedLessonId, isNull);
    });

    test('loads saved mode and level from SharedPreferences', () async {
      container = await createContainer(prefsValues: {
        'learning_mode': 'autodidact',
        'active_level_id': 3,
        'active_lesson_id': 42,
      });
      final state = await container.read(learningModeProvider.future);

      expect(state.mode, 'autodidact');
      expect(state.activeLevelId, 3);
      expect(state.activeLessonId, 42);
    });

    test('calculates suggested lesson in autodidact mode', () async {
      fakeProgressRepo.lessonProgressSummary = [
        (lessonId: 1, totalItems: 10, masteredCount: 10),
        (lessonId: 2, totalItems: 10, masteredCount: 5),
        (lessonId: 3, totalItems: 10, masteredCount: 0),
      ];

      container = await createContainer(prefsValues: {
        'learning_mode': 'autodidact',
        'active_level_id': 1,
      });
      final state = await container.read(learningModeProvider.future);

      expect(state.suggestedLessonId, 2);
    });

    test('suggested lesson is null when all mastered in autodidact', () async {
      fakeProgressRepo.lessonProgressSummary = [
        (lessonId: 1, totalItems: 10, masteredCount: 10),
        (lessonId: 2, totalItems: 5, masteredCount: 5),
      ];

      container = await createContainer(prefsValues: {
        'learning_mode': 'autodidact',
        'active_level_id': 1,
      });
      final state = await container.read(learningModeProvider.future);

      expect(state.suggestedLessonId, isNull);
    });

    test('does not calculate suggested lesson in curriculum mode', () async {
      fakeProgressRepo.lessonProgressSummary = [
        (lessonId: 1, totalItems: 10, masteredCount: 5),
      ];

      container = await createContainer(prefsValues: {
        'learning_mode': 'curriculum',
        'active_level_id': 1,
      });
      final state = await container.read(learningModeProvider.future);

      expect(state.suggestedLessonId, isNull);
    });

    test('setMode saves to SharedPreferences and rebuilds', () async {
      container = await createContainer();
      final notifier = container.read(learningModeProvider.notifier);

      await notifier.setMode('autodidact');
      final state = await container.read(learningModeProvider.future);

      expect(state.mode, 'autodidact');
    });

    test('setActiveLevelId saves to SharedPreferences and rebuilds', () async {
      container = await createContainer();
      final notifier = container.read(learningModeProvider.notifier);

      await notifier.setActiveLevelId(2);
      final state = await container.read(learningModeProvider.future);

      expect(state.activeLevelId, 2);
    });

    test('setActiveLessonId saves and updates state directly', () async {
      container = await createContainer();
      await container.read(learningModeProvider.future);

      final notifier = container.read(learningModeProvider.notifier);
      await notifier.setActiveLessonId(42);

      final state = container.read(learningModeProvider).value;
      expect(state?.activeLessonId, 42);
    });

    test('isCurriculum and isAutodidact getters', () async {
      container = await createContainer(prefsValues: {
        'learning_mode': 'curriculum',
      });
      var state = await container.read(learningModeProvider.future);
      expect(state.isCurriculum, isTrue);
      expect(state.isAutodidact, isFalse);

      final notifier = container.read(learningModeProvider.notifier);
      await notifier.setMode('autodidact');
      state = await container.read(learningModeProvider.future);
      expect(state.isCurriculum, isFalse);
      expect(state.isAutodidact, isTrue);
    });
  });
}
