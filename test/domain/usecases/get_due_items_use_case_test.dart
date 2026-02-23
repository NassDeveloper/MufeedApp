import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/reviewable_item_model.dart';
import 'package:mufeed_app/domain/models/session_model.dart';
import 'package:mufeed_app/domain/models/user_progress_model.dart';
import 'package:mufeed_app/domain/repositories/progress_repository.dart';
import 'package:mufeed_app/domain/usecases/get_due_items_use_case.dart';

class FakeProgressRepository implements ProgressRepository {
  List<UserProgressModel> dueItems = [];

  @override
  Future<List<UserProgressModel>> getDueItems() async => dueItems;
  @override
  Future<List<ReviewableItemModel>> getDueReviewableItems() async => [];

  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLesson(int lessonId) =>
      throw UnimplementedError();

  @override
  Future<UserProgressModel?> getProgressForItem(
          int itemId, String contentType) =>
      throw UnimplementedError();

  @override
  Future<void> saveProgress(UserProgressModel progress) =>
      throw UnimplementedError();

  @override
  Future<int> createSession(SessionModel session) =>
      throw UnimplementedError();

  @override
  Future<Map<String, int>> getProgressCountsByState() =>
      throw UnimplementedError();

  @override
  Future<Map<String, Map<String, int>>> getProgressCountsByStateAndType() =>
      throw UnimplementedError();

  @override
  Future<int> getTotalWordCount() => throw UnimplementedError();

  @override
  Future<int> getTotalVerbCount() => throw UnimplementedError();

  @override
  Future<int> getTotalItemCount() => throw UnimplementedError();

  @override
  Future<int> getSessionCount() => throw UnimplementedError();

  @override
  Future<List<UserProgressModel>> getProgressForLesson(int lessonId) =>
      throw UnimplementedError();

  @override
  Future<int> getTotalItemCountForLesson(int lessonId) =>
      throw UnimplementedError();

  @override
  Future<List<({int lessonId, int totalItems, int masteredCount})>>
      getLessonProgressSummaryForLevel(int levelId) =>
      throw UnimplementedError();

  @override
  Future<int> getTotalWordsReviewed() async => 0;
  @override
  Future<int> getCompletedLessonCount() async => 0;
  @override
  Future<bool> hasPerfectQuiz() async => false;
}

void main() {
  late GetDueItemsUseCase useCase;
  late FakeProgressRepository repository;

  setUp(() {
    repository = FakeProgressRepository();
    useCase = GetDueItemsUseCase(repository);
  });

  group('GetDueItemsUseCase', () {
    test('returns due items from repository', () async {
      repository.dueItems = [
        UserProgressModel(
          itemId: 1,
          contentType: 'vocab',
          state: 'review',
          nextReview: DateTime.utc(2026, 2, 20),
        ),
      ];

      final result = await useCase.call();

      expect(result, hasLength(1));
      expect(result.first.itemId, 1);
    });

    test('returns empty list when no items are due', () async {
      repository.dueItems = [];

      final result = await useCase.call();

      expect(result, isEmpty);
    });

    test('returns items in repository order (most overdue first)', () async {
      repository.dueItems = [
        UserProgressModel(
          itemId: 3,
          contentType: 'vocab',
          state: 'review',
          nextReview: DateTime.utc(2026, 2, 18),
        ),
        UserProgressModel(
          itemId: 1,
          contentType: 'vocab',
          state: 'review',
          nextReview: DateTime.utc(2026, 2, 19),
        ),
        UserProgressModel(
          itemId: 2,
          contentType: 'verb',
          state: 'review',
          nextReview: DateTime.utc(2026, 2, 20),
        ),
      ];

      final result = await useCase.call();

      expect(result, hasLength(3));
      expect(result[0].itemId, 3);
      expect(result[1].itemId, 1);
      expect(result[2].itemId, 2);
    });
  });
}
