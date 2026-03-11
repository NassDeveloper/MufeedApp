import 'package:drift/drift.dart';

import '../../core/errors/app_error.dart';
import '../../domain/models/daily_activity_model.dart';
import '../../domain/models/reviewable_item_model.dart';
import '../../domain/models/session_model.dart';
import '../../domain/models/upcoming_reviews_model.dart';
import '../../domain/models/user_progress_model.dart';
import '../../domain/repositories/progress_repository.dart';
import '../database/app_database.dart';
import '../database/daos/progress_dao.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl(this._dao);

  final ProgressDao _dao;

  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLesson(
      int lessonId) async {
    final rows = await _dao.getReviewableItemsForLesson(lessonId);
    return rows.map(_rowToReviewableItem).toList();
  }

  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLessons(
      List<int> lessonIds) async {
    final rows = await _dao.getReviewableItemsForLessons(lessonIds);
    return rows.map(_rowToReviewableItem).toList();
  }

  @override
  Future<List<UserProgressModel>> getDueItems() async {
    final rows = await _dao.getDueItems(DateTime.now());
    return rows.map(_dataToProgressModel).toList();
  }

  @override
  Future<List<ReviewableItemModel>> getDueReviewableItems() async {
    final rows = await _dao.getDueReviewableItems(DateTime.now());
    return rows.map(_rowToReviewableItem).toList();
  }

  @override
  Future<UserProgressModel?> getProgressForItem(
      int itemId, String contentType) async {
    final data = await _dao.getProgressForItem(itemId, contentType);
    return data == null ? null : _dataToProgressModel(data);
  }

  @override
  Future<void> saveProgress(UserProgressModel progress) async {
    final companion = UserProgressCompanion(
      id: progress.id != null ? Value(progress.id!) : const Value.absent(),
      itemId: Value(progress.itemId),
      contentType: Value(progress.contentType),
      stability: Value(progress.stability),
      difficulty: Value(progress.difficulty),
      state: Value(progress.state),
      lastReview: Value(progress.lastReview),
      nextReview: Value(progress.nextReview),
      reviewCount: Value(progress.reviewCount),
      elapsedDays: Value(progress.elapsedDays),
      scheduledDays: Value(progress.scheduledDays),
      reps: Value(progress.reps),
    );
    await _dao.upsertProgress(companion);
  }

  @override
  Future<int> createSession(SessionModel session) async {
    final companion = SessionsCompanion.insert(
      sessionType: session.sessionType,
      startedAt: session.startedAt,
      completedAt: Value(session.completedAt),
      itemsReviewed: Value(session.itemsReviewed),
      resultsJson: Value(session.resultsJson),
    );
    return _dao.insertSession(companion);
  }

  @override
  Future<Map<String, int>> getProgressCountsByState() {
    return _dao.getProgressCountsByState();
  }

  @override
  Future<Map<String, Map<String, int>>> getProgressCountsByStateAndType() {
    return _dao.getProgressCountsByStateAndType();
  }

  @override
  Future<int> getTotalItemCount() {
    return _dao.getTotalItemCount();
  }

  @override
  Future<int> getTotalWordCount() {
    return _dao.getTotalWordCount();
  }

  @override
  Future<int> getTotalVerbCount() {
    return _dao.getTotalVerbCount();
  }

  @override
  Future<int> getSessionCount() {
    return _dao.getSessionCount();
  }

  @override
  Future<List<UserProgressModel>> getProgressForLesson(int lessonId) async {
    final rows = await _dao.getProgressForLesson(lessonId);
    return rows.map(_dataToProgressModel).toList();
  }

  @override
  Future<int> getTotalItemCountForLesson(int lessonId) {
    return _dao.getTotalItemCountForLesson(lessonId);
  }

  @override
  Future<List<({int lessonId, int totalItems, int masteredCount})>>
      getLessonProgressSummaryForLevel(int levelId) async {
    final rows = await _dao.getLessonProgressSummaryForLevel(levelId);
    return rows
        .map(
          (r) => (
            lessonId: r.lessonId,
            totalItems: r.totalItems,
            masteredCount: r.masteredCount,
          ),
        )
        .toList();
  }

  @override
  Future<int> getTotalWordsReviewed() async {
    try {
      return await _dao.getTotalWordsReviewed();
    } catch (e) {
      throw DatabaseError('Failed to get total words reviewed',
          debugInfo: '$e');
    }
  }

  @override
  Future<int> getCompletedLessonCount() async {
    try {
      return await _dao.getCompletedLessonCount();
    } catch (e) {
      throw DatabaseError('Failed to get completed lesson count',
          debugInfo: '$e');
    }
  }

  @override
  Future<bool> hasPerfectQuiz() async {
    try {
      return await _dao.hasPerfectQuiz();
    } catch (e) {
      throw DatabaseError('Failed to check for perfect quiz',
          debugInfo: '$e');
    }
  }

  @override
  Future<List<DailyActivityModel>> getReviewActivity({int days = 14}) async {
    final since = DateTime.now().subtract(Duration(days: days));
    final map = await _dao.getReviewActivityByDay(since);
    final result = <DailyActivityModel>[];
    final now = DateTime.now();
    for (var i = days - 1; i >= 0; i--) {
      final date =
          DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final key =
          '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';
      result.add(DailyActivityModel(date: date, count: map[key] ?? 0));
    }
    return result;
  }

  @override
  Future<UpcomingReviewsModel> getUpcomingReviews() async {
    final row = await _dao.getUpcomingReviewCounts(DateTime.now());
    return UpcomingReviewsModel(
      dueToday: row.dueToday,
      dueTomorrow: row.dueTomorrow,
      dueThisWeek: row.dueThisWeek,
    );
  }

  @override
  Future<List<ReviewableItemModel>> getNewWordsForLevel(
      int levelId, int limit) async {
    final rows = await _dao.getNewWordsForLevel(levelId, limit);
    return rows.map(_rowToReviewableItem).toList();
  }

  @override
  Future<int> getNewWordsIntroducedTodayCount() =>
      _dao.getNewWordsIntroducedTodayCount();

  @override
  Future<({int lessonId, int totalItems, int masteredCount})>
      getLessonProgressSummary(int lessonId) async {
    final row = await _dao.getLessonProgressSummary(lessonId);
    return (
      lessonId: row.lessonId,
      totalItems: row.totalItems,
      masteredCount: row.masteredCount,
    );
  }

  ReviewableItemModel _rowToReviewableItem(ReviewableItemRow row) {
    final hasProgress = row.progressState != null;
    return ReviewableItemModel(
      itemId: row.itemId,
      contentType: row.contentType,
      arabic: row.arabic,
      translationFr: row.translationFr,
      sortOrder: row.sortOrder,
      verbPast: row.verbPast,
      verbPresent: row.verbPresent,
      verbImperative: row.verbImperative,
      progress: hasProgress
          ? UserProgressModel(
              itemId: row.itemId,
              contentType: row.contentType,
              stability: row.stability ?? 0,
              difficulty: row.difficulty ?? 0,
              state: row.progressState!,
              nextReview: row.nextReview,
              reviewCount: row.reviewCount ?? 0,
              lastReview: row.lastReview,
              elapsedDays: row.elapsedDays ?? 0,
              scheduledDays: row.scheduledDays ?? 0,
              reps: row.reps ?? 0,
            )
          : null,
    );
  }

  static UserProgressModel _dataToProgressModel(UserProgressData data) {
    return UserProgressModel(
      id: data.id,
      itemId: data.itemId,
      contentType: data.contentType,
      stability: data.stability,
      difficulty: data.difficulty,
      state: data.state,
      lastReview: data.lastReview,
      nextReview: data.nextReview,
      reviewCount: data.reviewCount,
      elapsedDays: data.elapsedDays,
      scheduledDays: data.scheduledDays,
      reps: data.reps,
    );
  }
}
