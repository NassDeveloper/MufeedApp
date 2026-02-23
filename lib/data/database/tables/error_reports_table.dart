import 'package:drift/drift.dart';

class ErrorReports extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer()();
  TextColumn get contentType => text()(); // 'vocab' or 'verb'
  TextColumn get category => text()(); // 'harakat_error', 'translation_error', 'other'
  TextColumn get comment => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
