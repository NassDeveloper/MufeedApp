import 'package:drift/drift.dart';

class Levels extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get number => integer()();
  TextColumn get nameFr => text()();
  TextColumn get nameEn => text()();
  TextColumn get nameAr => text()();
  IntColumn get unitCount => integer()();
}
