import 'package:drift/drift.dart';

class Badges extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get badgeType => text().unique()();
  DateTimeColumn get unlockedAt => dateTime().nullable()();
  BoolColumn get displayed =>
      boolean().withDefault(const Constant(false))();
}
