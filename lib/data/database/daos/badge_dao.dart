import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/badges_table.dart';

part 'badge_dao.g.dart';

@DriftAccessor(tables: [Badges])
class BadgeDao extends DatabaseAccessor<AppDatabase> with _$BadgeDaoMixin {
  BadgeDao(super.db);

  Future<List<Badge>> getAllBadges() => select(badges).get();

  Future<Badge?> getBadge(String type) async {
    final query = select(badges)..where((b) => b.badgeType.equals(type));
    final results = await query.get();
    return results.isEmpty ? null : results.first;
  }

  Future<void> unlockBadge(String type, DateTime at) async {
    await (update(badges)..where((b) => b.badgeType.equals(type))).write(
      BadgesCompanion(unlockedAt: Value(at)),
    );
  }

  Future<void> markDisplayed(String type) async {
    await (update(badges)..where((b) => b.badgeType.equals(type))).write(
      const BadgesCompanion(displayed: Value(true)),
    );
  }
}
