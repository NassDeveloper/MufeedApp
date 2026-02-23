import '../../domain/models/lesson_model.dart';
import '../../domain/models/level_model.dart';
import '../../domain/models/sentence_exercise_model.dart';
import '../../domain/models/unit_model.dart';
import '../../domain/models/verb_model.dart';
import '../../domain/models/word_model.dart';
import '../../domain/repositories/content_repository.dart';
import '../database/daos/content_dao.dart';
import '../datasources/json_content_loader.dart';

class ContentRepositoryImpl implements ContentRepository {
  ContentRepositoryImpl(this._contentDao, this._jsonLoader);

  final ContentDao _contentDao;
  final JsonContentLoader _jsonLoader;

  @override
  Future<List<LevelModel>> getAllLevels() async {
    final rows = await _contentDao.getAllLevels();
    return rows
        .map(
          (r) => LevelModel(
            id: r.id,
            number: r.number,
            nameFr: r.nameFr,
            nameEn: r.nameEn,
            nameAr: r.nameAr,
            unitCount: r.unitCount,
          ),
        )
        .toList();
  }

  @override
  Future<List<UnitModel>> getUnitsByLevelId(int levelId) async {
    final rows = await _contentDao.getUnitsByLevelId(levelId);
    return rows
        .map(
          (r) => UnitModel(
            id: r.id,
            levelId: r.levelId,
            number: r.number,
            nameFr: r.nameFr,
            nameEn: r.nameEn,
          ),
        )
        .toList();
  }

  @override
  Future<List<LessonModel>> getLessonsByUnitId(int unitId) async {
    final rows = await _contentDao.getLessonsByUnitId(unitId);
    return rows
        .map(
          (r) => LessonModel(
            id: r.id,
            unitId: r.unitId,
            number: r.number,
            nameFr: r.nameFr,
            nameEn: r.nameEn,
            descriptionFr: r.descriptionFr,
            descriptionEn: r.descriptionEn,
          ),
        )
        .toList();
  }

  @override
  Future<LessonModel?> getLessonById(int lessonId) async {
    final r = await _contentDao.getLessonById(lessonId);
    if (r == null) return null;
    return LessonModel(
      id: r.id,
      unitId: r.unitId,
      number: r.number,
      nameFr: r.nameFr,
      nameEn: r.nameEn,
      descriptionFr: r.descriptionFr,
      descriptionEn: r.descriptionEn,
    );
  }

  @override
  Future<List<WordModel>> getWordsByLessonId(int lessonId) async {
    final rows = await _contentDao.getWordsByLessonId(lessonId);
    return rows
        .map(
          (r) => WordModel(
            id: r.id,
            lessonId: r.lessonId,
            contentType: r.contentType,
            arabic: r.arabic,
            translationFr: r.translationFr,
            translationEn: r.translationEn,
            grammaticalCategory: r.grammaticalCategory,
            singular: r.singular,
            plural: r.plural,
            synonym: r.synonym,
            antonym: r.antonym,
            exampleSentence: r.exampleSentence,
            audioPath: r.audioPath,
            sortOrder: r.sortOrder,
          ),
        )
        .toList();
  }

  @override
  Future<List<VerbModel>> getVerbsByLessonId(int lessonId) async {
    final rows = await _contentDao.getVerbsByLessonId(lessonId);
    return rows
        .map(
          (r) => VerbModel(
            id: r.id,
            lessonId: r.lessonId,
            contentType: r.contentType,
            masdar: r.masdar,
            past: r.past,
            present: r.present,
            imperative: r.imperative,
            translationFr: r.translationFr,
            translationEn: r.translationEn,
            exampleSentence: r.exampleSentence,
            audioPathMasdar: r.audioPathMasdar,
            audioPathPast: r.audioPathPast,
            audioPathPresent: r.audioPathPresent,
            audioPathImperative: r.audioPathImperative,
            sortOrder: r.sortOrder,
          ),
        )
        .toList();
  }

  @override
  Future<List<LessonModel>> getLessonsByLevelId(int levelId) async {
    final rows = await _contentDao.getLessonsByLevelId(levelId);
    return rows
        .map(
          (r) => LessonModel(
            id: r.id,
            unitId: r.unitId,
            number: r.number,
            nameFr: r.nameFr,
            nameEn: r.nameEn,
            descriptionFr: r.descriptionFr,
            descriptionEn: r.descriptionEn,
          ),
        )
        .toList();
  }

  @override
  Future<List<SentenceExerciseModel>> getExercisesForLesson(
      int lessonId) async {
    final coords = await _contentDao.getLessonCoordinates(lessonId);
    if (coords == null) return [];

    final jsonList = await _jsonLoader.loadExercises(coords.levelNumber);
    if (jsonList.isEmpty) return [];

    return jsonList
        .where((j) =>
            j['unit'] == coords.unitNumber &&
            j['lesson'] == coords.lessonNumber)
        .map((j) => SentenceExerciseModel.fromJson({
              ...j,
              'lesson_id': lessonId,
            }))
        .toList();
  }
}
