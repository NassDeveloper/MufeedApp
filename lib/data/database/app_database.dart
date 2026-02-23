import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/badge_dao.dart';
import 'daos/content_dao.dart';
import 'daos/progress_dao.dart';
import 'daos/streak_dao.dart';
import 'tables/badges_table.dart';
import 'tables/error_reports_table.dart';
import 'tables/lessons_table.dart';
import 'tables/levels_table.dart';
import 'tables/sessions_table.dart';
import 'tables/streaks_table.dart';
import 'tables/units_table.dart';
import 'tables/user_progress_table.dart';
import 'tables/verbs_table.dart';
import 'tables/words_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Levels, Units, Lessons, Words, Verbs, ErrorReports, UserProgress, Sessions, Streaks, Badges],
  daos: [BadgeDao, ContentDao, ProgressDao, StreakDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement(
            'INSERT INTO streaks (current_streak, longest_streak, last_activity_date, freeze_available, freeze_used_date) '
            "VALUES (0, 0, strftime('%s', 'now'), 1, NULL)",
          );
          await _seedBadges();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(errorReports);
          }
          if (from < 3) {
            await m.createTable(userProgress);
            await m.createTable(sessions);
            await customStatement(
              'CREATE UNIQUE INDEX IF NOT EXISTS idx_user_progress_item '
              'ON user_progress (item_id, content_type)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_user_progress_next_review '
              'ON user_progress (next_review)',
            );
          }
          if (from < 4) {
            await m.createTable(streaks);
            await customStatement(
              'INSERT INTO streaks (current_streak, longest_streak, last_activity_date, freeze_available, freeze_used_date) '
              "VALUES (0, 0, strftime('%s', 'now'), 1, NULL)",
            );
          }
          if (from < 5) {
            await m.createTable(badges);
            await _seedBadges();
          }
          if (from < 6) {
            await customStatement(
              'ALTER TABLE lessons ADD COLUMN description_fr TEXT',
            );
            await customStatement(
              'ALTER TABLE lessons ADD COLUMN description_en TEXT',
            );
          }
        },
      );

  Future<void> _seedBadges() async {
    const badgeTypes = [
      'firstWordReviewed',
      'words10',
      'words50',
      'words100',
      'words500',
      'firstLessonCompleted',
      'streak7',
      'streak30',
      'streak100',
      'perfectQuiz',
    ];
    for (final type in badgeTypes) {
      await customStatement(
        'INSERT OR IGNORE INTO badges (badge_type, unlocked_at, displayed) '
        'VALUES (?, NULL, 0)',
        [type],
      );
    }
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'mufeed_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }
}
