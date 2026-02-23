import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../providers/badge_provider.dart';
import '../providers/daily_session_provider.dart';
import '../providers/flashcard_session_provider.dart';
import '../providers/learning_mode_provider.dart';
import '../providers/srs_provider.dart';
import '../providers/streak_provider.dart';
import '../widgets/badge_celebration_overlay.dart';
import '../widgets/rating_distribution_widget.dart';

class DailySummaryScreen extends ConsumerStatefulWidget {
  const DailySummaryScreen({super.key});

  @override
  ConsumerState<DailySummaryScreen> createState() =>
      _DailySummaryScreenState();
}

class _DailySummaryScreenState extends ConsumerState<DailySummaryScreen> {
  Map<int, int> _ratingCounts = const {1: 0, 2: 0, 3: 0, 4: 0};
  int _totalItems = 0;

  @override
  void initState() {
    super.initState();
    final session = ref.read(flashcardSessionProvider);
    if (session != null) {
      _ratingCounts = Map.unmodifiable(session.ratingCounts);
      _totalItems = session.totalItems;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newBadges = ref.read(newBadgesProvider);
      if (newBadges.isNotEmpty) {
        ref.read(newBadgesProvider.notifier).clear();
        showBadgeCelebrations(
          context,
          newBadges,
          onBadgeDisplayed: (type) {
            ref.read(badgeRepositoryProvider).markDisplayed(type);
          },
        );
      }
    });
  }

  void _cleanupAndNavigate(String route) {
    ref.read(flashcardSessionProvider.notifier).endSession();
    ref.invalidate(learningModeProvider);
    ref.invalidate(dueItemsProvider);
    ref.invalidate(dueItemCountProvider);
    ref.invalidate(dailySessionProvider);
    ref.invalidate(lastActivityDateProvider);
    ref.invalidate(isResumeNeededProvider);
    if (route == '/') {
      context.go(route);
    } else {
      context.pushReplacement(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dailySummaryTitle),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                l10n.sessionSummaryItemsReviewed(_totalItems),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: RatingDistribution(
                  ratingCounts: _ratingCounts,
                  totalItems: _totalItems,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Semantics(
                  button: true,
                  label: l10n.dailySummaryBackHome,
                  child: FilledButton(
                    onPressed: () => _cleanupAndNavigate('/'),
                    child: Text(l10n.dailySummaryBackHome),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: Semantics(
                  button: true,
                  label: l10n.dailySummaryRestart,
                  child: OutlinedButton(
                    onPressed: () => _cleanupAndNavigate('/session/daily'),
                    child: Text(l10n.dailySummaryRestart),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
