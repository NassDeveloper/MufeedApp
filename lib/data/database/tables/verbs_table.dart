import 'package:drift/drift.dart';

import 'lessons_table.dart';

class Verbs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(Lessons, #id)();
  TextColumn get contentType => text().withDefault(const Constant('verb'))();
  TextColumn get masdar => text()();
  TextColumn get past => text()();
  TextColumn get present => text()();
  TextColumn get imperative => text()();
  TextColumn get translationFr => text()();
  TextColumn get translationEn => text().nullable()();
  TextColumn get exampleSentence => text().nullable()();
  TextColumn get audioPathMasdar => text().nullable()();
  TextColumn get audioPathPast => text().nullable()();
  TextColumn get audioPathPresent => text().nullable()();
  TextColumn get audioPathImperative => text().nullable()();
  IntColumn get sortOrder => integer()();
}
