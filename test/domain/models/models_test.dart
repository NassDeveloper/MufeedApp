import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/level_model.dart';
import 'package:mufeed_app/domain/models/unit_model.dart';
import 'package:mufeed_app/domain/models/lesson_model.dart';
import 'package:mufeed_app/domain/models/word_model.dart';
import 'package:mufeed_app/domain/models/verb_model.dart';

void main() {
  group('LevelModel', () {
    test('creates correctly', () {
      const level = LevelModel(
        id: 1,
        number: 1,
        nameFr: 'Niveau 1',
        nameEn: 'Level 1',
        nameAr: 'المستوى الأول',
        unitCount: 3,
      );
      expect(level.id, 1);
      expect(level.number, 1);
      expect(level.nameFr, 'Niveau 1');
      expect(level.nameAr, 'المستوى الأول');
      expect(level.unitCount, 3);
    });

    test('copyWith works', () {
      const level = LevelModel(
        id: 1,
        number: 1,
        nameFr: 'Niveau 1',
        nameEn: 'Level 1',
        nameAr: 'المستوى الأول',
        unitCount: 3,
      );
      final updated = level.copyWith(nameFr: 'Niveau modifié');
      expect(updated.nameFr, 'Niveau modifié');
      expect(updated.id, 1);
      expect(updated.nameAr, 'المستوى الأول');
    });
  });

  group('UnitModel', () {
    test('creates correctly', () {
      const unit = UnitModel(
        id: 1,
        levelId: 1,
        number: 1,
        nameFr: 'Unité 1',
        nameEn: 'Unit 1',
      );
      expect(unit.levelId, 1);
      expect(unit.nameFr, 'Unité 1');
    });

    test('copyWith works', () {
      const unit = UnitModel(
        id: 1,
        levelId: 1,
        number: 1,
        nameFr: 'Unité 1',
        nameEn: 'Unit 1',
      );
      final updated = unit.copyWith(number: 2);
      expect(updated.number, 2);
      expect(updated.levelId, 1);
    });
  });

  group('LessonModel', () {
    test('creates correctly', () {
      const lesson = LessonModel(
        id: 1,
        unitId: 1,
        number: 1,
        nameFr: 'Leçon 1',
        nameEn: 'Lesson 1',
      );
      expect(lesson.unitId, 1);
      expect(lesson.nameFr, 'Leçon 1');
    });
  });

  group('WordModel', () {
    test('creates with required fields', () {
      const word = WordModel(
        id: 1,
        lessonId: 1,
        contentType: 'vocab',
        arabic: 'كِتَابٌ',
        translationFr: 'Livre',
        sortOrder: 1,
      );
      expect(word.arabic, 'كِتَابٌ');
      expect(word.translationFr, 'Livre');
      expect(word.grammaticalCategory, isNull);
      expect(word.plural, isNull);
    });

    test('creates with optional fields', () {
      const word = WordModel(
        id: 1,
        lessonId: 1,
        contentType: 'vocab',
        arabic: 'كِتَابٌ',
        translationFr: 'Livre',
        sortOrder: 1,
        grammaticalCategory: 'nom',
        singular: 'كِتَابٌ',
        plural: 'كُتُبٌ',
      );
      expect(word.grammaticalCategory, 'nom');
      expect(word.plural, 'كُتُبٌ');
    });

    test('copyWith preserves nullable fields', () {
      const word = WordModel(
        id: 1,
        lessonId: 1,
        contentType: 'vocab',
        arabic: 'كِتَابٌ',
        translationFr: 'Livre',
        sortOrder: 1,
        grammaticalCategory: 'nom',
      );
      final updated = word.copyWith(arabic: 'قَلَمٌ');
      expect(updated.arabic, 'قَلَمٌ');
      expect(updated.grammaticalCategory, 'nom');
    });
  });

  group('VerbModel', () {
    test('creates correctly', () {
      const verb = VerbModel(
        id: 1,
        lessonId: 1,
        contentType: 'verb',
        masdar: 'كِتَابَةٌ',
        past: 'كَتَبَ',
        present: 'يَكْتُبُ',
        imperative: 'اُكْتُبْ',
        translationFr: 'Écrire',
        sortOrder: 1,
      );
      expect(verb.masdar, 'كِتَابَةٌ');
      expect(verb.past, 'كَتَبَ');
      expect(verb.present, 'يَكْتُبُ');
      expect(verb.imperative, 'اُكْتُبْ');
      expect(verb.translationEn, isNull);
    });

    test('copyWith works', () {
      const verb = VerbModel(
        id: 1,
        lessonId: 1,
        contentType: 'verb',
        masdar: 'كِتَابَةٌ',
        past: 'كَتَبَ',
        present: 'يَكْتُبُ',
        imperative: 'اُكْتُبْ',
        translationFr: 'Écrire',
        sortOrder: 1,
      );
      final updated = verb.copyWith(translationFr: 'Rédiger');
      expect(updated.translationFr, 'Rédiger');
      expect(updated.masdar, 'كِتَابَةٌ');
    });
  });
}
