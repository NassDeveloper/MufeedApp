// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_dao.dart';

// ignore_for_file: type=lint
mixin _$ProgressDaoMixin on DatabaseAccessor<AppDatabase> {
  $LevelsTable get levels => attachedDatabase.levels;
  $UnitsTable get units => attachedDatabase.units;
  $LessonsTable get lessons => attachedDatabase.lessons;
  $WordsTable get words => attachedDatabase.words;
  $VerbsTable get verbs => attachedDatabase.verbs;
  $UserProgressTable get userProgress => attachedDatabase.userProgress;
  $SessionsTable get sessions => attachedDatabase.sessions;
  ProgressDaoManager get managers => ProgressDaoManager(this);
}

class ProgressDaoManager {
  final _$ProgressDaoMixin _db;
  ProgressDaoManager(this._db);
  $$LevelsTableTableManager get levels =>
      $$LevelsTableTableManager(_db.attachedDatabase, _db.levels);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db.attachedDatabase, _db.units);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db.attachedDatabase, _db.lessons);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db.attachedDatabase, _db.words);
  $$VerbsTableTableManager get verbs =>
      $$VerbsTableTableManager(_db.attachedDatabase, _db.verbs);
  $$UserProgressTableTableManager get userProgress =>
      $$UserProgressTableTableManager(_db.attachedDatabase, _db.userProgress);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db.attachedDatabase, _db.sessions);
}
