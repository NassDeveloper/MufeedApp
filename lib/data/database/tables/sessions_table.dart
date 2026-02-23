import 'package:drift/drift.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionType => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get itemsReviewed => integer().withDefault(const Constant(0))();
  TextColumn get resultsJson => text().nullable()();
}
