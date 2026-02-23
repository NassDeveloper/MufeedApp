import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/data/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());

    // Insert test content: 1 level, 1 unit, 1 lesson, 2 words, 1 verb
    await db.into(db.levels).insert(LevelsCompanion.insert(
          number: 1,
          nameFr: 'Niveau 1',
          nameEn: 'Level 1',
          nameAr: 'المستوى 1',
          unitCount: 1,
        ));
    await db.into(db.units).insert(UnitsCompanion.insert(
          levelId: 1,
          number: 1,
          nameFr: 'Unite 1',
          nameEn: 'Unit 1',
        ));
    await db.into(db.lessons).insert(LessonsCompanion.insert(
          unitId: 1,
          number: 1,
          nameFr: 'Lecon 1',
          nameEn: 'Lesson 1',
        ));
    await db.into(db.words).insert(WordsCompanion.insert(
          lessonId: 1,
          arabic: 'كتاب',
          translationFr: 'livre',
          sortOrder: 1,
        ));
    await db.into(db.words).insert(WordsCompanion.insert(
          lessonId: 1,
          arabic: 'قلم',
          translationFr: 'stylo',
          sortOrder: 2,
        ));
    await db.into(db.verbs).insert(VerbsCompanion.insert(
          lessonId: 1,
          masdar: 'كِتَابَة',
          past: 'كَتَبَ',
          present: 'يَكْتُبُ',
          imperative: 'اُكْتُبْ',
          translationFr: 'ecrire',
          sortOrder: 3,
        ));
  });

  tearDown(() async {
    await db.close();
  });

  group('ProgressDao', () {
    test('getReviewableItemsForLesson returns words and verbs', () async {
      final items = await db.progressDao.getReviewableItemsForLesson(1);

      expect(items, hasLength(3));
      expect(items[0].contentType, 'vocab');
      expect(items[0].arabic, 'كتاب');
      expect(items[1].contentType, 'vocab');
      expect(items[1].arabic, 'قلم');
      expect(items[2].contentType, 'verb');
      expect(items[2].arabic, 'كِتَابَة');
      expect(items[2].verbPast, 'كَتَبَ');
      expect(items[2].verbPresent, 'يَكْتُبُ');
      expect(items[2].verbImperative, 'اُكْتُبْ');
      expect(items[0].verbPast, isNull);
    });

    test('getReviewableItemsForLesson shows null progress for new items',
        () async {
      final items = await db.progressDao.getReviewableItemsForLesson(1);

      for (final item in items) {
        expect(item.progressState, isNull);
      }
    });

    test('getReviewableItemsForLesson joins with user_progress', () async {
      // Insert progress for first word
      await db.into(db.userProgress).insert(UserProgressCompanion.insert(
            itemId: 1,
            contentType: 'vocab',
            state: const Value('review'),
            stability: const Value(5.0),
            difficulty: const Value(3.0),
          ));

      final items = await db.progressDao.getReviewableItemsForLesson(1);

      expect(items[0].progressState, 'review');
      expect(items[0].stability, 5.0);
      expect(items[0].difficulty, 3.0);
      expect(items[1].progressState, isNull);
    });

    test('getDueItems returns items with past next_review', () async {
      final pastDate = DateTime.now().subtract(const Duration(days: 1));
      final futureDate = DateTime.now().add(const Duration(days: 5));

      // Due item
      await db.into(db.userProgress).insert(UserProgressCompanion.insert(
            itemId: 1,
            contentType: 'vocab',
            nextReview: Value(pastDate),
            state: const Value('review'),
          ));

      // Not due item
      await db.into(db.userProgress).insert(UserProgressCompanion.insert(
            itemId: 2,
            contentType: 'vocab',
            nextReview: Value(futureDate),
            state: const Value('review'),
          ));

      final dueItems = await db.progressDao.getDueItems(DateTime.now());

      expect(dueItems, hasLength(1));
      expect(dueItems.first.itemId, 1);
    });

    test('getDueItems sorts by most overdue first', () async {
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
      final oneDayAgo = DateTime.now().subtract(const Duration(days: 1));

      await db.into(db.userProgress).insert(UserProgressCompanion.insert(
            itemId: 2,
            contentType: 'vocab',
            nextReview: Value(oneDayAgo),
            state: const Value('review'),
          ));
      await db.into(db.userProgress).insert(UserProgressCompanion.insert(
            itemId: 1,
            contentType: 'vocab',
            nextReview: Value(twoDaysAgo),
            state: const Value('review'),
          ));

      final dueItems = await db.progressDao.getDueItems(DateTime.now());

      expect(dueItems, hasLength(2));
      expect(dueItems[0].itemId, 1); // most overdue first
      expect(dueItems[1].itemId, 2);
    });

    test('getProgressForItem returns null for new item', () async {
      final result = await db.progressDao.getProgressForItem(99, 'vocab');
      expect(result, isNull);
    });

    test('getProgressForItem returns existing progress', () async {
      await db.into(db.userProgress).insert(UserProgressCompanion.insert(
            itemId: 1,
            contentType: 'vocab',
            state: const Value('review'),
            stability: const Value(5.0),
          ));

      final result = await db.progressDao.getProgressForItem(1, 'vocab');

      expect(result, isNotNull);
      expect(result!.itemId, 1);
      expect(result.state, 'review');
      expect(result.stability, 5.0);
    });

    test('upsertProgress inserts new record', () async {
      await db.progressDao.upsertProgress(UserProgressCompanion.insert(
        itemId: 1,
        contentType: 'vocab',
        state: const Value('learning'),
        stability: const Value(2.5),
      ));

      final result = await db.progressDao.getProgressForItem(1, 'vocab');
      expect(result, isNotNull);
      expect(result!.state, 'learning');
      expect(result.stability, 2.5);
    });

    test('insertSession creates session record', () async {
      final id = await db.progressDao.insertSession(SessionsCompanion.insert(
        sessionType: 'flashcard',
        startedAt: DateTime.utc(2026, 2, 21),
        itemsReviewed: const Value(10),
      ));

      expect(id, greaterThan(0));

      final sessions = await db.select(db.sessions).get();
      expect(sessions, hasLength(1));
      expect(sessions.first.sessionType, 'flashcard');
      expect(sessions.first.itemsReviewed, 10);
    });
  });
}
