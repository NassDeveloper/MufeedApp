import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/data/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift database', () {
    test('tables are created successfully', () async {
      // If we can insert and query, tables exist
      final levelId = await db.into(db.levels).insert(
            LevelsCompanion.insert(
              number: 1,
              nameFr: 'Niveau 1',
              nameEn: 'Level 1',
              nameAr: 'المستوى الأول',
              unitCount: 1,
            ),
          );
      expect(levelId, greaterThan(0));

      final levels = await db.contentDao.getAllLevels();
      expect(levels, hasLength(1));
      expect(levels.first.nameFr, 'Niveau 1');
      expect(levels.first.nameAr, 'المستوى الأول');
    });

    test('foreign keys work for units → levels', () async {
      final levelId = await db.into(db.levels).insert(
            LevelsCompanion.insert(
              number: 1,
              nameFr: 'Niveau 1',
              nameEn: 'Level 1',
              nameAr: 'المستوى الأول',
              unitCount: 1,
            ),
          );

      await db.into(db.units).insert(
            UnitsCompanion.insert(
              levelId: levelId,
              number: 1,
              nameFr: 'Unité 1',
              nameEn: 'Unit 1',
            ),
          );

      final units = await db.contentDao.getUnitsByLevelId(levelId);
      expect(units, hasLength(1));
      expect(units.first.levelId, levelId);
    });

    test('full content hierarchy insert and query', () async {
      // Insert level
      final levelId = await db.into(db.levels).insert(
            LevelsCompanion.insert(
              number: 1,
              nameFr: 'Niveau 1',
              nameEn: 'Level 1',
              nameAr: 'المستوى الأول',
              unitCount: 1,
            ),
          );

      // Insert unit
      final unitId = await db.into(db.units).insert(
            UnitsCompanion.insert(
              levelId: levelId,
              number: 1,
              nameFr: 'Unité 1',
              nameEn: 'Unit 1',
            ),
          );

      // Insert lesson
      final lessonId = await db.into(db.lessons).insert(
            LessonsCompanion.insert(
              unitId: unitId,
              number: 1,
              nameFr: 'Leçon 1',
              nameEn: 'Lesson 1',
            ),
          );

      // Insert words
      await db.into(db.words).insert(
            WordsCompanion.insert(
              lessonId: lessonId,
              arabic: 'كِتَابٌ',
              translationFr: 'Livre',
              sortOrder: 1,
            ),
          );
      await db.into(db.words).insert(
            WordsCompanion.insert(
              lessonId: lessonId,
              arabic: 'قَلَمٌ',
              translationFr: 'Stylo',
              sortOrder: 2,
            ),
          );

      // Insert verb
      await db.into(db.verbs).insert(
            VerbsCompanion.insert(
              lessonId: lessonId,
              masdar: 'كِتَابَةٌ',
              past: 'كَتَبَ',
              present: 'يَكْتُبُ',
              imperative: 'اُكْتُبْ',
              translationFr: 'Écrire',
              sortOrder: 1,
            ),
          );

      // Query words
      final words = await db.contentDao.getWordsByLessonId(lessonId);
      expect(words, hasLength(2));
      expect(words.first.arabic, 'كِتَابٌ');
      expect(words.last.arabic, 'قَلَمٌ');

      // Query verbs
      final verbs = await db.contentDao.getVerbsByLessonId(lessonId);
      expect(verbs, hasLength(1));
      expect(verbs.first.masdar, 'كِتَابَةٌ');

      // Count queries
      final wordCount = await db.contentDao.getWordCountByLessonId(lessonId);
      expect(wordCount, 2);

      final verbCount = await db.contentDao.getVerbCountByLessonId(lessonId);
      expect(verbCount, 1);
    });

    test('words ordered by sort_order', () async {
      final levelId = await db.into(db.levels).insert(
            LevelsCompanion.insert(
              number: 1,
              nameFr: 'N1',
              nameEn: 'L1',
              nameAr: 'م1',
              unitCount: 1,
            ),
          );
      final unitId = await db.into(db.units).insert(
            UnitsCompanion.insert(
              levelId: levelId,
              number: 1,
              nameFr: 'U1',
              nameEn: 'U1',
            ),
          );
      final lessonId = await db.into(db.lessons).insert(
            LessonsCompanion.insert(
              unitId: unitId,
              number: 1,
              nameFr: 'L1',
              nameEn: 'L1',
            ),
          );

      // Insert in reverse order
      await db.into(db.words).insert(
            WordsCompanion.insert(
              lessonId: lessonId,
              arabic: 'B',
              translationFr: 'B',
              sortOrder: 3,
            ),
          );
      await db.into(db.words).insert(
            WordsCompanion.insert(
              lessonId: lessonId,
              arabic: 'A',
              translationFr: 'A',
              sortOrder: 1,
            ),
          );
      await db.into(db.words).insert(
            WordsCompanion.insert(
              lessonId: lessonId,
              arabic: 'C',
              translationFr: 'C',
              sortOrder: 2,
            ),
          );

      final words = await db.contentDao.getWordsByLessonId(lessonId);
      expect(words.map((w) => w.sortOrder).toList(), [1, 2, 3]);
    });

    test('nullable columns work correctly', () async {
      final levelId = await db.into(db.levels).insert(
            LevelsCompanion.insert(
              number: 1,
              nameFr: 'N1',
              nameEn: 'L1',
              nameAr: 'م1',
              unitCount: 1,
            ),
          );
      final unitId = await db.into(db.units).insert(
            UnitsCompanion.insert(
              levelId: levelId,
              number: 1,
              nameFr: 'U1',
              nameEn: 'U1',
            ),
          );
      final lessonId = await db.into(db.lessons).insert(
            LessonsCompanion.insert(
              unitId: unitId,
              number: 1,
              nameFr: 'L1',
              nameEn: 'L1',
            ),
          );

      // Insert word with only required fields
      await db.into(db.words).insert(
            WordsCompanion.insert(
              lessonId: lessonId,
              arabic: 'مَاءٌ',
              translationFr: 'Eau',
              sortOrder: 1,
            ),
          );

      final words = await db.contentDao.getWordsByLessonId(lessonId);
      expect(words.first.grammaticalCategory, isNull);
      expect(words.first.singular, isNull);
      expect(words.first.plural, isNull);
      expect(words.first.translationEn, isNull);
      expect(words.first.contentType, 'vocab');
    });

    test('getLevelById returns null for non-existent', () async {
      final level = await db.contentDao.getLevelById(999);
      expect(level, isNull);
    });
  });
}
