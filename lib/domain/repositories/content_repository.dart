import '../models/lesson_model.dart';
import '../models/level_model.dart';
import '../models/unit_model.dart';
import '../models/verb_model.dart';
import '../models/word_model.dart';

abstract class ContentRepository {
  Future<List<LevelModel>> getAllLevels();
  Future<List<UnitModel>> getUnitsByLevelId(int levelId);
  Future<List<LessonModel>> getLessonsByUnitId(int unitId);
  Future<List<WordModel>> getWordsByLessonId(int lessonId);
  Future<List<VerbModel>> getVerbsByLessonId(int lessonId);
  Future<List<LessonModel>> getLessonsByLevelId(int levelId);
}
