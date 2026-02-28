import 'dart:convert';

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/sessions_table.dart';
import '../tables/user_progress_table.dart';
import '../tables/verbs_table.dart';
import '../tables/words_table.dart';

part 'progress_dao.g.dart';

@DriftAccessor(tables: [Words, Verbs, UserProgress, Sessions])
class ProgressDao extends DatabaseAccessor<AppDatabase>
    with _$ProgressDaoMixin {
  ProgressDao(super.db);

  /// Returns all reviewable items for a lesson with their progress state.
  /// Combines words and verbs via UNION, LEFT JOINed with user_progress.
  Future<List<ReviewableItemRow>> getReviewableItemsForLesson(
      int lessonId) async {
    final query = customSelect(
      '''
      SELECT w.id AS item_id, 'vocab' AS content_type, w.arabic AS arabic,
             w.translation_fr AS translation_fr, w.sort_order AS sort_order,
             NULL AS verb_past, NULL AS verb_present, NULL AS verb_imperative,
             up.state AS progress_state, up.stability AS stability,
             up.difficulty AS difficulty, up.next_review AS next_review,
             up.review_count AS review_count, up.last_review AS last_review,
             up.elapsed_days AS elapsed_days, up.scheduled_days AS scheduled_days,
             up.reps AS reps
      FROM words w
      LEFT JOIN user_progress up ON up.item_id = w.id AND up.content_type = 'vocab'
      WHERE w.lesson_id = ?
      UNION ALL
      SELECT v.id AS item_id, 'verb' AS content_type, v.masdar AS arabic,
             v.translation_fr AS translation_fr, v.sort_order AS sort_order,
             v.past AS verb_past, v.present AS verb_present, v.imperative AS verb_imperative,
             up.state AS progress_state, up.stability AS stability,
             up.difficulty AS difficulty, up.next_review AS next_review,
             up.review_count AS review_count, up.last_review AS last_review,
             up.elapsed_days AS elapsed_days, up.scheduled_days AS scheduled_days,
             up.reps AS reps
      FROM verbs v
      LEFT JOIN user_progress up ON up.item_id = v.id AND up.content_type = 'verb'
      WHERE v.lesson_id = ?
      ORDER BY sort_order
      ''',
      variables: [Variable.withInt(lessonId), Variable.withInt(lessonId)],
      readsFrom: {words, verbs, userProgress},
    );
    final rows = await query.get();
    return rows.map(ReviewableItemRow.fromRow).toList();
  }

  /// Returns all reviewable items for multiple lessons with their progress state.
  Future<List<ReviewableItemRow>> getReviewableItemsForLessons(
      List<int> lessonIds) async {
    if (lessonIds.isEmpty) return [];
    final placeholders = List.filled(lessonIds.length, '?').join(', ');
    final query = customSelect(
      '''
      SELECT w.id AS item_id, 'vocab' AS content_type, w.arabic AS arabic,
             w.translation_fr AS translation_fr, w.sort_order AS sort_order,
             NULL AS verb_past, NULL AS verb_present, NULL AS verb_imperative,
             up.state AS progress_state, up.stability AS stability,
             up.difficulty AS difficulty, up.next_review AS next_review,
             up.review_count AS review_count, up.last_review AS last_review,
             up.elapsed_days AS elapsed_days, up.scheduled_days AS scheduled_days,
             up.reps AS reps
      FROM words w
      LEFT JOIN user_progress up ON up.item_id = w.id AND up.content_type = 'vocab'
      WHERE w.lesson_id IN ($placeholders)
      UNION ALL
      SELECT v.id AS item_id, 'verb' AS content_type, v.masdar AS arabic,
             v.translation_fr AS translation_fr, v.sort_order AS sort_order,
             v.past AS verb_past, v.present AS verb_present, v.imperative AS verb_imperative,
             up.state AS progress_state, up.stability AS stability,
             up.difficulty AS difficulty, up.next_review AS next_review,
             up.review_count AS review_count, up.last_review AS last_review,
             up.elapsed_days AS elapsed_days, up.scheduled_days AS scheduled_days,
             up.reps AS reps
      FROM verbs v
      LEFT JOIN user_progress up ON up.item_id = v.id AND up.content_type = 'verb'
      WHERE v.lesson_id IN ($placeholders)
      ORDER BY sort_order
      ''',
      variables: [
        ...lessonIds.map(Variable.withInt),
        ...lessonIds.map(Variable.withInt),
      ],
      readsFrom: {words, verbs, userProgress},
    );
    final rows = await query.get();
    return rows.map(ReviewableItemRow.fromRow).toList();
  }

  /// Returns items due for review (next_review <= now), sorted by most overdue first.
  Future<List<UserProgressData>> getDueItems(DateTime now) {
    return (select(userProgress)
          ..where((t) => t.nextReview.isSmallerOrEqualValue(now))
          ..orderBy([(t) => OrderingTerm.asc(t.nextReview)]))
        .get();
  }

  /// Returns progress for a specific item, or null if never reviewed.
  Future<UserProgressData?> getProgressForItem(
      int itemId, String contentType) {
    return (select(userProgress)
          ..where(
              (t) => t.itemId.equals(itemId) & t.contentType.equals(contentType)))
        .getSingleOrNull();
  }

  /// Inserts or updates a user_progress record.
  Future<void> upsertProgress(UserProgressCompanion data) {
    return into(userProgress).insertOnConflictUpdate(data);
  }

  /// Inserts a new session record and returns the generated id.
  Future<int> insertSession(SessionsCompanion data) {
    return into(sessions).insert(data);
  }

  /// Returns the count of progress records grouped by FSRS state.
  Future<Map<String, int>> getProgressCountsByState() async {
    final query = customSelect(
      'SELECT state, COUNT(*) AS cnt FROM user_progress GROUP BY state',
      readsFrom: {userProgress},
    );
    final rows = await query.get();
    return {
      for (final row in rows)
        row.read<String>('state'): row.read<int>('cnt'),
    };
  }

  /// Returns progress counts grouped by content_type and state.
  Future<Map<String, Map<String, int>>>
      getProgressCountsByStateAndType() async {
    final query = customSelect(
      'SELECT content_type, state, COUNT(*) AS cnt FROM user_progress GROUP BY content_type, state',
      readsFrom: {userProgress},
    );
    final rows = await query.get();
    final result = <String, Map<String, int>>{};
    for (final row in rows) {
      final type = row.read<String>('content_type');
      final state = row.read<String>('state');
      final cnt = row.read<int>('cnt');
      result.putIfAbsent(type, () => {})[state] = cnt;
    }
    return result;
  }

  /// Returns total number of reviewable items (words + verbs).
  Future<int> getTotalItemCount() async {
    final query = customSelect(
      'SELECT (SELECT COUNT(*) FROM words) + (SELECT COUNT(*) FROM verbs) AS total',
      readsFrom: {words, verbs},
    );
    final row = await query.getSingle();
    return row.read<int>('total');
  }

  /// Returns total number of words.
  Future<int> getTotalWordCount() async {
    final query = customSelect(
      'SELECT COUNT(*) AS cnt FROM words',
      readsFrom: {words},
    );
    final row = await query.getSingle();
    return row.read<int>('cnt');
  }

  /// Returns total number of verbs.
  Future<int> getTotalVerbCount() async {
    final query = customSelect(
      'SELECT COUNT(*) AS cnt FROM verbs',
      readsFrom: {verbs},
    );
    final row = await query.getSingle();
    return row.read<int>('cnt');
  }

  /// Returns the number of completed sessions.
  Future<int> getSessionCount() async {
    final query = customSelect(
      'SELECT COUNT(*) AS cnt FROM sessions WHERE completed_at IS NOT NULL',
      readsFrom: {sessions},
    );
    final row = await query.getSingle();
    return row.read<int>('cnt');
  }

  /// Returns all progress records for items belonging to a lesson.
  Future<List<UserProgressData>> getProgressForLesson(int lessonId) async {
    final query = customSelect(
      '''
      SELECT up.* FROM user_progress up
      WHERE (EXISTS (SELECT 1 FROM words w WHERE w.lesson_id = ? AND w.id = up.item_id AND up.content_type = 'vocab')
          OR EXISTS (SELECT 1 FROM verbs v WHERE v.lesson_id = ? AND v.id = up.item_id AND up.content_type = 'verb'))
      ''',
      variables: [Variable.withInt(lessonId), Variable.withInt(lessonId)],
      readsFrom: {userProgress, words, verbs},
    );
    final rows = await query.get();
    return rows.map((row) {
      return UserProgressData(
        id: row.read<int>('id'),
        itemId: row.read<int>('item_id'),
        contentType: row.read<String>('content_type'),
        stability: row.read<double>('stability'),
        difficulty: row.read<double>('difficulty'),
        state: row.read<String>('state'),
        lastReview: row.readNullable<DateTime>('last_review'),
        nextReview: row.readNullable<DateTime>('next_review'),
        reviewCount: row.read<int>('review_count'),
        elapsedDays: row.read<int>('elapsed_days'),
        scheduledDays: row.read<int>('scheduled_days'),
        reps: row.read<int>('reps'),
      );
    }).toList();
  }

  /// Returns a progress summary for each lesson in a level.
  /// Ordered by unit.number then lesson.number.
  Future<List<LessonProgressSummaryRow>> getLessonProgressSummaryForLevel(
      int levelId) async {
    final query = customSelect(
      '''
      SELECT l.id AS lesson_id,
             (SELECT COUNT(*) FROM words w WHERE w.lesson_id = l.id)
             + (SELECT COUNT(*) FROM verbs v WHERE v.lesson_id = l.id) AS total_items,
             (SELECT COUNT(*) FROM user_progress up
              WHERE up.state = 'review'
                AND ((EXISTS (SELECT 1 FROM words w WHERE w.lesson_id = l.id AND w.id = up.item_id AND up.content_type = 'vocab'))
                  OR (EXISTS (SELECT 1 FROM verbs v WHERE v.lesson_id = l.id AND v.id = up.item_id AND up.content_type = 'verb')))
             ) AS mastered_count
      FROM lessons l
      JOIN units u ON l.unit_id = u.id
      WHERE u.level_id = ?
      ORDER BY u.number, l.number
      ''',
      variables: [Variable.withInt(levelId)],
      readsFrom: {words, verbs, userProgress},
    );
    final rows = await query.get();
    return rows.map(LessonProgressSummaryRow.fromRow).toList();
  }

  /// Returns all due reviewable items (next_review <= now) with full content.
  /// Combines words and verbs via UNION, INNER JOINed with user_progress.
  /// Sorted by next_review ASC (most overdue first).
  Future<List<ReviewableItemRow>> getDueReviewableItems(DateTime now) async {
    final query = customSelect(
      '''
      SELECT w.id AS item_id, 'vocab' AS content_type, w.arabic AS arabic,
             w.translation_fr AS translation_fr, w.sort_order AS sort_order,
             NULL AS verb_past, NULL AS verb_present, NULL AS verb_imperative,
             up.state AS progress_state, up.stability AS stability,
             up.difficulty AS difficulty, up.next_review AS next_review,
             up.review_count AS review_count, up.last_review AS last_review,
             up.elapsed_days AS elapsed_days, up.scheduled_days AS scheduled_days,
             up.reps AS reps
      FROM words w
      INNER JOIN user_progress up ON up.item_id = w.id AND up.content_type = 'vocab'
      WHERE up.next_review <= ?
      UNION ALL
      SELECT v.id AS item_id, 'verb' AS content_type, v.masdar AS arabic,
             v.translation_fr AS translation_fr, v.sort_order AS sort_order,
             v.past AS verb_past, v.present AS verb_present, v.imperative AS verb_imperative,
             up.state AS progress_state, up.stability AS stability,
             up.difficulty AS difficulty, up.next_review AS next_review,
             up.review_count AS review_count, up.last_review AS last_review,
             up.elapsed_days AS elapsed_days, up.scheduled_days AS scheduled_days,
             up.reps AS reps
      FROM verbs v
      INNER JOIN user_progress up ON up.item_id = v.id AND up.content_type = 'verb'
      WHERE up.next_review <= ?
      ORDER BY next_review ASC
      ''',
      variables: [Variable.withDateTime(now), Variable.withDateTime(now)],
      readsFrom: {words, verbs, userProgress},
    );
    final rows = await query.get();
    return rows.map(ReviewableItemRow.fromRow).toList();
  }

  /// Returns total number of items reviewed at least once.
  Future<int> getTotalWordsReviewed() async {
    final query = customSelect(
      'SELECT COUNT(*) AS cnt FROM user_progress WHERE review_count > 0',
      readsFrom: {userProgress},
    );
    final row = await query.getSingle();
    return row.read<int>('cnt');
  }

  /// Returns the number of lessons where all items have been reviewed at least once.
  Future<int> getCompletedLessonCount() async {
    final query = customSelect(
      '''
      SELECT COUNT(*) AS cnt FROM lessons l
      WHERE (SELECT COUNT(*) FROM words w WHERE w.lesson_id = l.id)
          + (SELECT COUNT(*) FROM verbs v WHERE v.lesson_id = l.id) > 0
        AND NOT EXISTS (
          SELECT 1 FROM (
            SELECT w2.id AS iid, 'vocab' AS ct FROM words w2 WHERE w2.lesson_id = l.id
            UNION ALL
            SELECT v2.id AS iid, 'verb' AS ct FROM verbs v2 WHERE v2.lesson_id = l.id
          ) items
          LEFT JOIN user_progress up ON up.item_id = items.iid AND up.content_type = items.ct
          WHERE up.id IS NULL OR up.review_count = 0
        )
      ''',
      readsFrom: {words, verbs, userProgress},
    );
    final row = await query.getSingle();
    return row.read<int>('cnt');
  }

  /// Returns true if at least one quiz session has a perfect score.
  Future<bool> hasPerfectQuiz() async {
    final rows = await customSelect(
      "SELECT results_json FROM sessions WHERE session_type = 'quiz' AND completed_at IS NOT NULL AND results_json IS NOT NULL",
      readsFrom: {sessions},
    ).get();

    for (final row in rows) {
      final jsonStr = row.read<String>('results_json');
      if (_isPerfectQuiz(jsonStr)) return true;
    }
    return false;
  }

  bool _isPerfectQuiz(String jsonStr) {
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is! List || decoded.isEmpty) return false;
      return decoded.every(
        (entry) => entry is Map && entry['isCorrect'] == true,
      );
    } catch (_) {
      return false;
    }
  }

  /// Returns total number of items (words + verbs) for a lesson.
  Future<int> getTotalItemCountForLesson(int lessonId) async {
    final query = customSelect(
      '''
      SELECT (SELECT COUNT(*) FROM words WHERE lesson_id = ?)
           + (SELECT COUNT(*) FROM verbs WHERE lesson_id = ?) AS total
      ''',
      variables: [Variable.withInt(lessonId), Variable.withInt(lessonId)],
      readsFrom: {words, verbs},
    );
    final row = await query.getSingle();
    return row.read<int>('total');
  }

  /// Returns the number of items reviewed per day since [since].
  /// Uses last_review (stored as ms since epoch) from user_progress.
  Future<Map<String, int>> getReviewActivityByDay(DateTime since) async {
    final query = customSelect(
      '''
      SELECT strftime('%Y-%m-%d', last_review / 1000, 'unixepoch', 'localtime') AS day,
             COUNT(*) AS cnt
      FROM user_progress
      WHERE last_review IS NOT NULL
        AND last_review >= ?
      GROUP BY day
      ORDER BY day
      ''',
      variables: [Variable.withInt(since.millisecondsSinceEpoch)],
      readsFrom: {userProgress},
    );
    final rows = await query.get();
    return {
      for (final row in rows)
        row.read<String>('day'): row.read<int>('cnt'),
    };
  }

  /// Returns counts of upcoming reviews: due today, due tomorrow, due within 7 days.
  Future<UpcomingCountsRow> getUpcomingReviewCounts(DateTime now) async {
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final endOfTomorrow = endOfToday.add(const Duration(days: 1));
    final endOfWeek = endOfToday.add(const Duration(days: 7));
    final query = customSelect(
      '''
      SELECT
        SUM(CASE WHEN next_review <= ? THEN 1 ELSE 0 END) AS due_today,
        SUM(CASE WHEN next_review > ? AND next_review <= ? THEN 1 ELSE 0 END) AS due_tomorrow,
        SUM(CASE WHEN next_review <= ? THEN 1 ELSE 0 END) AS due_week
      FROM user_progress
      WHERE next_review IS NOT NULL
      ''',
      variables: [
        Variable.withInt(endOfToday.millisecondsSinceEpoch),
        Variable.withInt(endOfToday.millisecondsSinceEpoch),
        Variable.withInt(endOfTomorrow.millisecondsSinceEpoch),
        Variable.withInt(endOfWeek.millisecondsSinceEpoch),
      ],
      readsFrom: {userProgress},
    );
    final row = await query.getSingle();
    return UpcomingCountsRow(
      dueToday: row.read<int?>('due_today') ?? 0,
      dueTomorrow: row.read<int?>('due_tomorrow') ?? 0,
      dueThisWeek: row.read<int?>('due_week') ?? 0,
    );
  }
}

/// Row class for upcoming review counts query.
class UpcomingCountsRow {
  const UpcomingCountsRow({
    required this.dueToday,
    required this.dueTomorrow,
    required this.dueThisWeek,
  });

  final int dueToday;
  final int dueTomorrow;
  final int dueThisWeek;
}

/// Lightweight row class for the reviewable_items union query.
class ReviewableItemRow {
  ReviewableItemRow({
    required this.itemId,
    required this.contentType,
    required this.arabic,
    required this.translationFr,
    required this.sortOrder,
    this.verbPast,
    this.verbPresent,
    this.verbImperative,
    this.progressState,
    this.stability,
    this.difficulty,
    this.nextReview,
    this.reviewCount,
    this.lastReview,
    this.elapsedDays,
    this.scheduledDays,
    this.reps,
  });

  factory ReviewableItemRow.fromRow(QueryRow row) {
    return ReviewableItemRow(
      itemId: row.read<int>('item_id'),
      contentType: row.read<String>('content_type'),
      arabic: row.read<String>('arabic'),
      translationFr: row.read<String>('translation_fr'),
      sortOrder: row.read<int>('sort_order'),
      verbPast: row.readNullable<String>('verb_past'),
      verbPresent: row.readNullable<String>('verb_present'),
      verbImperative: row.readNullable<String>('verb_imperative'),
      progressState: row.readNullable<String>('progress_state'),
      stability: row.readNullable<double>('stability'),
      difficulty: row.readNullable<double>('difficulty'),
      nextReview: row.readNullable<DateTime>('next_review'),
      reviewCount: row.readNullable<int>('review_count'),
      lastReview: row.readNullable<DateTime>('last_review'),
      elapsedDays: row.readNullable<int>('elapsed_days'),
      scheduledDays: row.readNullable<int>('scheduled_days'),
      reps: row.readNullable<int>('reps'),
    );
  }

  final int itemId;
  final String contentType;
  final String arabic;
  final String translationFr;
  final int sortOrder;
  final String? verbPast;
  final String? verbPresent;
  final String? verbImperative;
  final String? progressState;
  final double? stability;
  final double? difficulty;
  final DateTime? nextReview;
  final int? reviewCount;
  final DateTime? lastReview;
  final int? elapsedDays;
  final int? scheduledDays;
  final int? reps;
}

/// Row class for the lesson progress summary query.
class LessonProgressSummaryRow {
  const LessonProgressSummaryRow({
    required this.lessonId,
    required this.totalItems,
    required this.masteredCount,
  });

  factory LessonProgressSummaryRow.fromRow(QueryRow row) {
    return LessonProgressSummaryRow(
      lessonId: row.read<int>('lesson_id'),
      totalItems: row.read<int>('total_items'),
      masteredCount: row.read<int>('mastered_count'),
    );
  }

  final int lessonId;
  final int totalItems;
  final int masteredCount;
}
