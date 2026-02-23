// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_dao.dart';

// ignore_for_file: type=lint
mixin _$ContentDaoMixin on DatabaseAccessor<AppDatabase> {
  $LevelsTable get levels => attachedDatabase.levels;
  $UnitsTable get units => attachedDatabase.units;
  $LessonsTable get lessons => attachedDatabase.lessons;
  $WordsTable get words => attachedDatabase.words;
  $VerbsTable get verbs => attachedDatabase.verbs;
  ContentDaoManager get managers => ContentDaoManager(this);
}

class ContentDaoManager {
  final _$ContentDaoMixin _db;
  ContentDaoManager(this._db);
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
}
