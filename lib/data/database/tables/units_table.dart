import 'package:drift/drift.dart';

import 'levels_table.dart';

class Units extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get levelId => integer().references(Levels, #id)();
  IntColumn get number => integer()();
  TextColumn get nameFr => text()();
  TextColumn get nameEn => text()();
}
