import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/badge_type.dart';
import '../../domain/models/streak_model.dart';
import '../../domain/repositories/streak_repository.dart';
import '../../domain/usecases/streak_manager.dart';
import 'badge_provider.dart';
import 'notification_provider.dart';

final streakRepositoryProvider = Provider<StreakRepository>((ref) {
  throw UnimplementedError(
    'streakRepositoryProvider must be overridden in main.dart',
  );
});

final streakManagerProvider = Provider<StreakManager>((ref) {
  return const StreakManager();
});

final clockProvider = Provider<DateTime Function()>((ref) {
  return () => DateTime.now();
});

final lastActivityDateProvider = FutureProvider<DateTime?>((ref) {
  return ref.watch(streakRepositoryProvider).getLastActivityDate();
});

final isResumeNeededProvider = FutureProvider<bool>((ref) async {
  final lastActivity = await ref.watch(lastActivityDateProvider.future);
  if (lastActivity == null) return false;
  final manager = ref.watch(streakManagerProvider);
  final clock = ref.watch(clockProvider);
  return manager.isAbsenceProlonged(
    lastActivityDate: lastActivity,
    now: clock(),
  );
});

/// Loads the full streak model from the repository.
final streakStateProvider = FutureProvider<StreakModel?>((ref) {
  return ref.watch(streakRepositoryProvider).getStreak();
});

/// Result of streak check on app opening.
class StreakCheckResult {
  const StreakCheckResult({
    required this.streak,
    this.wasStreakBroken = false,
    this.wasFreezeUsed = false,
  });

  final StreakModel streak;
  final bool wasStreakBroken;
  final bool wasFreezeUsed;
}

/// Notifier that holds the streak check result.
///
/// Call [performCheck] once when the home screen initializes.
/// The check loads the raw streak, calculates the update, saves if changed,
/// and exposes the result (including broken/freeze flags) to the UI.
class StreakCheckNotifier extends Notifier<StreakCheckResult?> {
  @override
  StreakCheckResult? build() => null;

  /// Performs the streak check on app opening: load, compute, save, report.
  Future<void> performCheck() async {
    final repo = ref.read(streakRepositoryProvider);
    final manager = ref.read(streakManagerProvider);
    final clock = ref.read(clockProvider);

    final rawStreak = await repo.getStreak();
    if (rawStreak == null) return;

    final now = clock();
    final updated = manager.calculateStreakUpdate(
      currentStreak: rawStreak,
      now: now,
    );

    final broken =
        rawStreak.currentStreak > 0 && updated.currentStreak == 0;
    final frozen =
        rawStreak.freezeAvailable && !updated.freezeAvailable;

    if (updated != rawStreak) {
      await repo.updateStreak(updated);
    }

    state = StreakCheckResult(
      streak: updated,
      wasStreakBroken: broken,
      wasFreezeUsed: frozen,
    );

    // Reschedule notifications on app opening (best-effort).
    rescheduleAllNotifications(ref).ignore();
  }

  /// Clears the check result (e.g. after session completes).
  void clear() => state = null;
}

final streakCheckProvider =
    NotifierProvider<StreakCheckNotifier, StreakCheckResult?>(
  StreakCheckNotifier.new,
);

/// Result of post-session processing (streak + badges).
class SessionCompleteResult {
  const SessionCompleteResult({this.newBadges = const []});

  final List<BadgeType> newBadges;
}

/// Processes streak update after a session is completed.
///
/// Loads current streak, calculates the update via StreakManager,
/// saves the result, checks for new badges, and invalidates dependent providers.
Future<SessionCompleteResult> processStreakOnSessionComplete(Ref ref) async {
  final repo = ref.read(streakRepositoryProvider);
  final manager = ref.read(streakManagerProvider);
  final clock = ref.read(clockProvider);
  final now = clock();

  final currentStreak = await repo.getStreak();
  if (currentStreak == null) {
    debugPrint('Streak update skipped: no streak record found');
    return const SessionCompleteResult();
  }

  final updatedStreak = manager.calculateStreakUpdate(
    currentStreak: currentStreak,
    now: now,
  );

  if (updatedStreak != currentStreak) {
    await repo.updateStreak(updatedStreak);
  }

  // Check for newly earned badges
  final newBadges = await checkAndAwardBadges(ref);

  ref.invalidate(streakStateProvider);
  ref.read(streakCheckProvider.notifier).clear();
  ref.invalidate(lastActivityDateProvider);
  ref.invalidate(isResumeNeededProvider);

  // Reschedule notifications after session (cancels streak danger for today).
  rescheduleAllNotifications(ref).ignore();

  return SessionCompleteResult(newBadges: newBadges);
}
