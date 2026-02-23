import '../models/reviewable_item_model.dart';
import '../models/session_model.dart';
import '../models/user_progress_model.dart';

abstract class ProgressRepository {
  Future<List<ReviewableItemModel>> getReviewableItemsForLesson(int lessonId);
  Future<List<UserProgressModel>> getDueItems();
  Future<List<ReviewableItemModel>> getDueReviewableItems();
  Future<UserProgressModel?> getProgressForItem(int itemId, String contentType);
  Future<void> saveProgress(UserProgressModel progress);
  Future<int> createSession(SessionModel session);
  Future<Map<String, int>> getProgressCountsByState();
  Future<Map<String, Map<String, int>>> getProgressCountsByStateAndType();
  Future<int> getTotalItemCount();
  Future<int> getTotalWordCount();
  Future<int> getTotalVerbCount();
  Future<int> getSessionCount();
  Future<List<UserProgressModel>> getProgressForLesson(int lessonId);
  Future<int> getTotalItemCountForLesson(int lessonId);
  Future<List<({int lessonId, int totalItems, int masteredCount})>>
      getLessonProgressSummaryForLevel(int levelId);
  Future<int> getTotalWordsReviewed();
  Future<int> getCompletedLessonCount();
  Future<bool> hasPerfectQuiz();
}
