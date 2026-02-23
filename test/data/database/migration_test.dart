import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/data/database/app_database.dart';

void main() {
  group('Database migration v3', () {
    test('creates user_progress and sessions tables on fresh database', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());

      // Verify tables exist by inserting and querying
      await db.into(db.userProgress).insert(UserProgressCompanion.insert(
            itemId: 1,
            contentType: 'vocab',
          ));

      final progress = await db.select(db.userProgress).get();
      expect(progress, hasLength(1));
      expect(progress.first.itemId, 1);
      expect(progress.first.contentType, 'vocab');
      expect(progress.first.state, 'new');
      expect(progress.first.stability, 0);
      expect(progress.first.difficulty, 0);
      expect(progress.first.reviewCount, 0);

      await db.into(db.sessions).insert(SessionsCompanion.insert(
            sessionType: 'flashcard',
            startedAt: DateTime.utc(2026, 2, 21),
          ));

      final sessions = await db.select(db.sessions).get();
      expect(sessions, hasLength(1));
      expect(sessions.first.sessionType, 'flashcard');
      expect(sessions.first.itemsReviewed, 0);

      await db.close();
    });

    test('user_progress defaults are correct', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());

      await db.into(db.userProgress).insert(UserProgressCompanion.insert(
            itemId: 5,
            contentType: 'verb',
          ));

      final row = await (db.select(db.userProgress)
            ..where((t) => t.itemId.equals(5)))
          .getSingle();

      expect(row.stability, 0.0);
      expect(row.difficulty, 0.0);
      expect(row.state, 'new');
      expect(row.lastReview, isNull);
      expect(row.nextReview, isNull);
      expect(row.reviewCount, 0);
      expect(row.elapsedDays, 0);
      expect(row.scheduledDays, 0);
      expect(row.reps, 0);

      await db.close();
    });

    test('schema version is 6', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      expect(db.schemaVersion, 6);
      await db.close();
    });
  });

  group('Database migration v4', () {
    test('streaks table is created on fresh database', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());

      await db.into(db.streaks).insert(StreaksCompanion.insert(
            lastActivityDate: DateTime.utc(2026, 2, 22),
          ));

      final streaks = await db.select(db.streaks).get();
      // 2 records: 1 from onCreate seed + 1 from manual insert
      expect(streaks, hasLength(2));
      expect(streaks.first.currentStreak, 0);
      expect(streaks.first.longestStreak, 0);
      expect(streaks.first.freezeAvailable, true);
      expect(streaks.first.freezeUsedDate, isNull);

      await db.close();
    });

    test('onCreate seeds initial streak record', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());

      final streaks = await db.select(db.streaks).get();
      expect(streaks, hasLength(1));
      expect(streaks.first.currentStreak, 0);
      expect(streaks.first.longestStreak, 0);
      expect(streaks.first.lastActivityDate, isNotNull);
      expect(streaks.first.freezeAvailable, true);
      expect(streaks.first.freezeUsedDate, isNull);

      await db.close();
    });
  });

  group('Database migration v5', () {
    test('badges table is created and seeded on fresh database', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());

      final badges = await db.select(db.badges).get();
      expect(badges, hasLength(10));
      expect(badges.first.unlockedAt, isNull);
      expect(badges.first.displayed, false);

      await db.close();
    });

    test('all 10 badge types are seeded', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());

      final badges = await db.select(db.badges).get();
      final types = badges.map((b) => b.badgeType).toSet();
      expect(types, containsAll([
        'firstWordReviewed',
        'words10',
        'words50',
        'words100',
        'words500',
        'firstLessonCompleted',
        'streak7',
        'streak30',
        'streak100',
        'perfectQuiz',
      ]));

      await db.close();
    });
  });
}
