import 'package:drift/drift.dart';

import 'units_table.dart';

class Lessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get unitId => integer().references(Units, #id)();
  IntColumn get number => integer()();
  TextColumn get nameFr => text()();
  TextColumn get nameEn => text()();
  TextColumn get descriptionFr => text().nullable()();
  TextColumn get descriptionEn => text().nullable()();
}
