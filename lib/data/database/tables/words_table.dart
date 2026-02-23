import 'package:drift/drift.dart';

import 'lessons_table.dart';

class Words extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(Lessons, #id)();
  TextColumn get contentType => text().withDefault(const Constant('vocab'))();
  TextColumn get arabic => text()();
  TextColumn get translationFr => text()();
  TextColumn get translationEn => text().nullable()();
  TextColumn get grammaticalCategory => text().nullable()();
  TextColumn get singular => text().nullable()();
  TextColumn get plural => text().nullable()();
  TextColumn get synonym => text().nullable()();
  TextColumn get antonym => text().nullable()();
  TextColumn get exampleSentence => text().nullable()();
  TextColumn get audioPath => text().nullable()();
  IntColumn get sortOrder => integer()();
}
