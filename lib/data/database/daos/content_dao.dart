import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/lessons_table.dart';
import '../tables/levels_table.dart';
import '../tables/units_table.dart';
import '../tables/verbs_table.dart';
import '../tables/words_table.dart';

part 'content_dao.g.dart';

@DriftAccessor(tables: [Levels, Units, Lessons, Words, Verbs])
class ContentDao extends DatabaseAccessor<AppDatabase>
    with _$ContentDaoMixin {
  ContentDao(super.db);

  Future<List<Level>> getAllLevels() =>
      (select(levels)..orderBy([(t) => OrderingTerm.asc(t.number)])).get();

  Future<Level?> getLevelById(int id) =>
      (select(levels)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Unit>> getUnitsByLevelId(int levelId) =>
      (select(units)
            ..where((t) => t.levelId.equals(levelId))
            ..orderBy([(t) => OrderingTerm.asc(t.number)]))
          .get();

  Future<Unit?> getUnitById(int id) =>
      (select(units)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Lesson>> getLessonsByUnitId(int unitId) =>
      (select(lessons)
            ..where((t) => t.unitId.equals(unitId))
            ..orderBy([(t) => OrderingTerm.asc(t.number)]))
          .get();

  Future<Lesson?> getLessonById(int id) =>
      (select(lessons)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Word>> getWordsByLessonId(int lessonId) =>
      (select(words)
            ..where((t) => t.lessonId.equals(lessonId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<List<Verb>> getVerbsByLessonId(int lessonId) =>
      (select(verbs)
            ..where((t) => t.lessonId.equals(lessonId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<int> getWordCountByLessonId(int lessonId) async {
    final count = countAll();
    final query = selectOnly(words)
      ..addColumns([count])
      ..where(words.lessonId.equals(lessonId));
    final result = await query.getSingle();
    return result.read(count)!;
  }

  Future<int> getVerbCountByLessonId(int lessonId) async {
    final count = countAll();
    final query = selectOnly(verbs)
      ..addColumns([count])
      ..where(verbs.lessonId.equals(lessonId));
    final result = await query.getSingle();
    return result.read(count)!;
  }

  /// Returns all lessons for a given level (across all units), ordered by unit.number then lesson.number.
  Future<List<Lesson>> getLessonsByLevelId(int levelId) async {
    final query = select(lessons).join([
      innerJoin(units, units.id.equalsExp(lessons.unitId)),
    ])
      ..where(units.levelId.equals(levelId))
      ..orderBy([
        OrderingTerm.asc(units.number),
        OrderingTerm.asc(lessons.number),
      ]);
    final rows = await query.get();
    return rows.map((row) => row.readTable(lessons)).toList();
  }
}
