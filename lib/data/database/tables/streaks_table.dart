import 'package:drift/drift.dart';

class Streaks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActivityDate => dateTime()();
  BoolColumn get freezeAvailable =>
      boolean().withDefault(const Constant(true))();
  DateTimeColumn get freezeUsedDate => dateTime().nullable()();
}
