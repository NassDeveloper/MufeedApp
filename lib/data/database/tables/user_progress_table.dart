import 'package:drift/drift.dart';

@TableIndex(name: 'idx_user_progress_next_review', columns: {#nextReview})
class UserProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer()();
  TextColumn get contentType => text()();
  RealColumn get stability => real().withDefault(const Constant(0))();
  RealColumn get difficulty => real().withDefault(const Constant(0))();
  TextColumn get state => text().withDefault(const Constant('new'))();
  DateTimeColumn get lastReview => dateTime().nullable()();
  DateTimeColumn get nextReview => dateTime().nullable()();
  IntColumn get reviewCount => integer().withDefault(const Constant(0))();
  IntColumn get elapsedDays => integer().withDefault(const Constant(0))();
  IntColumn get scheduledDays => integer().withDefault(const Constant(0))();
  IntColumn get reps => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [{itemId, contentType}];
}
