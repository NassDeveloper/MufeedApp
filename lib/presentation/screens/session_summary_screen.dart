import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../providers/badge_provider.dart';
import '../providers/flashcard_session_provider.dart';
import '../providers/learning_mode_provider.dart';
import '../providers/streak_provider.dart';
import '../widgets/badge_celebration_overlay.dart';
import '../widgets/rating_distribution_widget.dart';

class SessionSummaryScreen extends ConsumerStatefulWidget {
  const SessionSummaryScreen({required this.lessonId, super.key});

  final int lessonId;

  @override
  ConsumerState<SessionSummaryScreen> createState() =>
      _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends ConsumerState<SessionSummaryScreen> {
  Map<int, int> _ratingCounts = const {1: 0, 2: 0, 3: 0, 4: 0};
  int _totalItems = 0;

  @override
  void initState() {
    super.initState();
    // Capture session data once to avoid reading stale state after endSession
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sessionSummaryTitle),
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
                  label: l10n.sessionSummaryBackToLesson,
                  child: FilledButton(
                    onPressed: () {
                      ref
                          .read(flashcardSessionProvider.notifier)
                          .endSession();
                      ref.invalidate(learningModeProvider);
                      ref.invalidate(lastActivityDateProvider);
                      ref.invalidate(isResumeNeededProvider);
                      context.go('/vocabulary');
                    },
                    child: Text(l10n.sessionSummaryBackToLesson),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: Semantics(
                  button: true,
                  label: l10n.sessionSummaryRestart,
                  child: OutlinedButton(
                    onPressed: () {
                      ref
                          .read(flashcardSessionProvider.notifier)
                          .endSession();
                      ref.invalidate(learningModeProvider);
                      ref.invalidate(lastActivityDateProvider);
                      ref.invalidate(isResumeNeededProvider);
                      context.pushReplacement(
                        '/session/flashcard/${widget.lessonId}',
                      );
                    },
                    child: Text(l10n.sessionSummaryRestart),
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
