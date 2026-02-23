import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/badge_model.dart';
import '../../domain/models/badge_type.dart';
import '../../domain/repositories/badge_repository.dart';
import '../../domain/usecases/badge_manager.dart';
import 'srs_provider.dart';
import 'streak_provider.dart';

final badgeRepositoryProvider = Provider<BadgeRepository>((ref) {
  throw UnimplementedError(
    'badgeRepositoryProvider must be overridden in main.dart',
  );
});

final badgeManagerProvider = Provider<BadgeManager>((ref) {
  return const BadgeManager();
});

final allBadgesProvider = FutureProvider<List<BadgeModel>>((ref) {
  return ref.watch(badgeRepositoryProvider).getAllBadges();
});

/// Checks for newly earned badges and unlocks them.
///
/// Returns the list of badge types that were just unlocked (for celebration).
/// Catches and logs errors internally — badge checking should never break
/// the session completion flow.
Future<List<BadgeType>> checkAndAwardBadges(Ref ref) async {
  try {
    final badgeRepo = ref.read(badgeRepositoryProvider);
    final progressRepo = ref.read(progressRepositoryProvider);
    final streakRepo = ref.read(streakRepositoryProvider);
    final manager = ref.read(badgeManagerProvider);

    final currentBadges = await badgeRepo.getAllBadges();

    final totalWordsReviewed = await progressRepo.getTotalWordsReviewed();
    final stateCounts = await progressRepo.getProgressCountsByState();
    final wordsMastered = stateCounts['review'] ?? 0;
    final lessonsCompleted = await progressRepo.getCompletedLessonCount();
    final hasPerfect = await progressRepo.hasPerfectQuiz();
    final streak = await streakRepo.getStreak();

    final context = BadgeCheckContext(
      totalWordsReviewed: totalWordsReviewed,
      wordsMastered: wordsMastered,
      lessonsCompleted: lessonsCompleted,
      currentStreak: streak?.currentStreak ?? 0,
      longestStreak: streak?.longestStreak ?? 0,
      hasPerfectQuiz: hasPerfect,
    );

    final newlyUnlocked = manager.checkBadges(
      currentBadges: currentBadges,
      context: context,
    );

    final now = DateTime.now();
    for (final type in newlyUnlocked) {
      await badgeRepo.unlockBadge(type, now);
      debugPrint('Badge unlocked: ${type.key}');
    }

    if (newlyUnlocked.isNotEmpty) {
      ref.invalidate(allBadgesProvider);
    }

    return newlyUnlocked;
  } catch (e) {
    debugPrint('Badge check failed: $e');
    return const [];
  }
}

/// Holds the list of badges newly unlocked in the current session.
///
/// The UI reads this to trigger celebration overlays, then clears it.
class NewBadgeNotifier extends Notifier<List<BadgeType>> {
  @override
  List<BadgeType> build() => const [];

  void set(List<BadgeType> badges) => state = badges;

  void clear() => state = const [];
}

final newBadgesProvider =
    NotifierProvider<NewBadgeNotifier, List<BadgeType>>(NewBadgeNotifier.new);
