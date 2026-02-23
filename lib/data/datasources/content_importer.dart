import 'package:drift/drift.dart';

import '../../core/errors/app_error.dart';
import '../database/app_database.dart';
import 'json_content_loader.dart';
import 'shared_preferences_source.dart';

class ContentImporter {
  ContentImporter({
    required this.database,
    required this.jsonLoader,
    required this.prefsSource,
  });

  final AppDatabase database;
  final JsonContentLoader jsonLoader;
  final SharedPreferencesSource prefsSource;

  static const currentContentVersion = 5;

  Future<void> importIfNeeded() async {
    final installedVersion = prefsSource.getContentVersion();
    if (installedVersion >= currentContentVersion) return;
    await _importContent();
  }

  Future<void> _importContent() async {
    try {
      final levelNumbers = await jsonLoader.discoverLevels();

      await database.transaction(() async {
        // Clear existing content before re-import (order matters for FK)
        await database.delete(database.verbs).go();
        await database.delete(database.words).go();
        await database.delete(database.lessons).go();
        await database.delete(database.units).go();
        await database.delete(database.levels).go();

        for (final levelNum in levelNumbers) {
          await _importLevel(levelNum);
        }
      });

      await prefsSource.setContentVersion(currentContentVersion);
    } on AppError {
      rethrow;
    } catch (e) {
      throw DatabaseError(
        'Content import failed',
        debugInfo: e.toString(),
      );
    }
  }

  Future<void> _importLevel(int levelNumber) async {
    final metadata = await jsonLoader.loadMetadata(levelNumber);
    final levelData = metadata['level'] as Map<String, dynamic>;
    final unitsData = metadata['units'] as List<dynamic>;

    final levelId = await database.into(database.levels).insert(
          LevelsCompanion.insert(
            number: levelData['number'] as int,
            nameFr: levelData['name_fr'] as String,
            nameEn: levelData['name_en'] as String,
            nameAr: levelData['name_ar'] as String,
            unitCount: levelData['unit_count'] as int,
          ),
        );

    final lessonIdMap = <String, int>{};

    for (final unitData in unitsData) {
      final unit = unitData as Map<String, dynamic>;
      final unitNumber = unit['number'] as int;

      final unitId = await database.into(database.units).insert(
            UnitsCompanion.insert(
              levelId: levelId,
              number: unitNumber,
              nameFr: unit['name_fr'] as String,
              nameEn: unit['name_en'] as String,
            ),
          );

      final lessonsData = unit['lessons'] as List<dynamic>;
      for (final lessonData in lessonsData) {
        final lesson = lessonData as Map<String, dynamic>;
        final lessonNumber = lesson['number'] as int;

        final lessonId = await database.into(database.lessons).insert(
              LessonsCompanion.insert(
                unitId: unitId,
                number: lessonNumber,
                nameFr: lesson['name_fr'] as String,
                nameEn: lesson['name_en'] as String,
                descriptionFr: Value(lesson['description_fr'] as String?),
                descriptionEn: Value(lesson['description_en'] as String?),
              ),
            );

        lessonIdMap['$unitNumber-$lessonNumber'] = lessonId;
      }
    }

    // Import words
    final wordsData = await jsonLoader.loadWords(levelNumber);
    for (final word in wordsData) {
      final unitNum = word['unit'] as int;
      final lessonNum = word['lesson'] as int;
      final lessonId = lessonIdMap['$unitNum-$lessonNum'];
      if (lessonId == null) {
        throw ContentError(
          'Lesson $unitNum-$lessonNum not found for word',
          debugInfo: 'Level $levelNumber, word: ${word['arabic']}',
        );
      }

      await database.into(database.words).insert(
            WordsCompanion.insert(
              lessonId: lessonId,
              arabic: word['arabic'] as String,
              translationFr: word['translation_fr'] as String,
              translationEn: Value(word['translation_en'] as String?),
              grammaticalCategory:
                  Value(word['grammatical_category'] as String?),
              singular: Value(word['singular'] as String?),
              plural: Value(word['plural'] as String?),
              synonym: Value(word['synonym'] as String?),
              antonym: Value(word['antonym'] as String?),
              exampleSentence: Value(word['example_sentence'] as String?),
              sortOrder: word['sort_order'] as int,
            ),
          );
    }

    // Import verbs
    final verbsData = await jsonLoader.loadVerbs(levelNumber);
    for (final verb in verbsData) {
      final unitNum = verb['unit'] as int;
      final lessonNum = verb['lesson'] as int;
      final lessonId = lessonIdMap['$unitNum-$lessonNum'];
      if (lessonId == null) {
        throw ContentError(
          'Lesson $unitNum-$lessonNum not found for verb',
          debugInfo: 'Level $levelNumber, verb: ${verb['masdar']}',
        );
      }

      await database.into(database.verbs).insert(
            VerbsCompanion.insert(
              lessonId: lessonId,
              masdar: verb['masdar'] as String,
              past: verb['past'] as String,
              present: verb['present'] as String,
              imperative: verb['imperative'] as String,
              translationFr: verb['translation_fr'] as String,
              translationEn: Value(verb['translation_en'] as String?),
              exampleSentence: Value(verb['example_sentence'] as String?),
              sortOrder: verb['sort_order'] as int,
            ),
          );
    }
  }
}
