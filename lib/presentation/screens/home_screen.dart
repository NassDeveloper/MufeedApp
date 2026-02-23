import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/lesson_model.dart';
import '../../domain/models/streak_model.dart';
import '../../l10n/app_localizations.dart';
import '../providers/content_provider.dart';
import '../providers/daily_session_provider.dart';
import '../providers/learning_mode_provider.dart';
import '../providers/preferences_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/streak_provider.dart';
import '../utils/localized_name.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final prefsSource = ref.watch(sharedPreferencesSourceProvider);
    final lastLessonName = prefsSource.getLastVisitedLessonName();
    final lastLessonRoute = prefsSource.getLastVisitedLessonRoute();
    final learningModeAsync = ref.watch(learningModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabHome),
        actions: [
          Semantics(
            button: true,
            label: l10n.settingsSemanticButton,
            excludeSemantics: true,
            child: IconButton(
              icon: const Icon(Icons.settings),
              tooltip: l10n.settingsSemanticButton,
              onPressed: () => context.push('/settings'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.welcomeBack,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const _StreakSection(),
            const SizedBox(height: 16),
            const _DailySessionSection(),
            const SizedBox(height: 16),
            learningModeAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (modeState) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ModeInfoSection(modeState: modeState),
                  const SizedBox(height: 16),
                  if (modeState.isAutodidact &&
                      modeState.suggestedLessonId != null)
                    _SuggestedLessonCard(
                      activeLevelId: modeState.activeLevelId,
                      suggestedLessonId: modeState.suggestedLessonId!,
                    )
                  else if (modeState.isAutodidact &&
                      modeState.suggestedLessonId == null)
                    _NextLevelCard(activeLevelId: modeState.activeLevelId)
                  else if (lastLessonName != null && lastLessonRoute != null)
                    _ResumeCard(
                      lessonName: lastLessonName,
                      onTap: () => context.push(
                        lastLessonRoute,
                        extra: lastLessonName,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeInfoSection extends StatelessWidget {
  const _ModeInfoSection({required this.modeState});

  final LearningModeState modeState;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final modeName = modeState.isCurriculum
        ? l10n.homeModeCurriculum
        : l10n.homeModeAutodidact;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeCurrentMode(modeName),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.homeActiveLevel(modeState.activeLevelId.toString()),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _SuggestedLessonCard extends ConsumerWidget {
  const _SuggestedLessonCard({
    required this.activeLevelId,
    required this.suggestedLessonId,
  });

  final int activeLevelId;
  final int suggestedLessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context);
    final lessonsAsync = ref.watch(lessonsByLevelProvider(activeLevelId));

    final LessonModel? lesson = lessonsAsync.value
        ?.cast<LessonModel?>()
        .firstWhere((l) => l!.id == suggestedLessonId, orElse: () => null);
    final lessonName =
        lesson?.localizedName(locale) ?? l10n.lessonTitle(suggestedLessonId);

    void navigateToLesson() {
      if (lesson != null) {
        context.go(
          '/vocabulary/level/$activeLevelId/unit/${lesson.unitId}/lesson/$suggestedLessonId',
          extra: lessonName,
        );
      } else {
        context.go('/vocabulary');
      }
    }

    return Semantics(
      button: true,
      label: '${l10n.homeSuggestedLesson} $lessonName',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: navigateToLesson,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.lightbulb_outline,
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeSuggestedLesson,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lessonName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: navigateToLesson,
                  child: Text(l10n.homeContinueLesson),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NextLevelCard extends ConsumerWidget {
  const _NextLevelCard({required this.activeLevelId});

  final int activeLevelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final levelsAsync = ref.watch(levelsProvider);

    final levels = levelsAsync.value;
    final currentIndex =
        levels?.indexWhere((l) => l.id == activeLevelId) ?? -1;
    final hasNextLevel =
        levels != null && currentIndex >= 0 && currentIndex < levels.length - 1;

    return Semantics(
      button: true,
      label: l10n.homeNextLevelSemanticLabel,
      excludeSemantics: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.emoji_events, color: colorScheme.primary, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  l10n.homeNextLevelSuggestion,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (hasNextLevel)
                FilledButton(
                  onPressed: () {
                    final nextLevel = levels[currentIndex + 1];
                    ref
                        .read(learningModeProvider.notifier)
                        .setActiveLevelId(nextLevel.id);
                  },
                  child: Text(l10n.homeGoToNextLevel),
                )
              else
                Text(
                  l10n.homeAllLevelsMastered,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailySessionSection extends ConsumerStatefulWidget {
  const _DailySessionSection();

  @override
  ConsumerState<_DailySessionSection> createState() =>
      _DailySessionSectionState();
}

class _DailySessionSectionState extends ConsumerState<_DailySessionSection> {
  bool _resumeDismissed = false;

  @override
  Widget build(BuildContext context) {
    final resumeAsync = ref.watch(isResumeNeededProvider);
    final dueCountAsync = ref.watch(dueItemCountProvider);
    final statsAsync = ref.watch(progressStatsProvider);

    return resumeAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (isResume) {
        if (isResume && !_resumeDismissed) {
          return _ResumeSessionCard(
            onDismiss: () => setState(() => _resumeDismissed = true),
          );
        }

        return dueCountAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (dueCount) {
            if (dueCount > 0) {
              return _DailySessionCard(dueCount: dueCount);
            }
            return statsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (stats) {
                if (stats.sessionCount > 0) {
                  return const _AllReviewedCard();
                }
                return const SizedBox.shrink();
              },
            );
          },
        );
      },
    );
  }
}

class _DailySessionCard extends StatelessWidget {
  const _DailySessionCard({required this.dueCount});

  final int dueCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: l10n.dailySessionSemanticCta(dueCount),
      excludeSemantics: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: colorScheme.primaryContainer,
        child: InkWell(
          onTap: () => context.push('/session/daily'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.today,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dailySessionTitle,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.dailySessionDueCount(dueCount),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: () => context.push('/session/daily'),
                  child: Text(l10n.dailySessionCta),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResumeSessionCard extends StatelessWidget {
  const _ResumeSessionCard({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.wb_sunny,
                    color: colorScheme.onTertiary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.resumeWelcomeTitle,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: colorScheme.onTertiaryContainer,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.resumeWelcomeSubtitle,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: colorScheme.onTertiaryContainer,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Semantics(
                  button: true,
                  label: l10n.resumeDismissButton,
                  child: TextButton(
                    onPressed: onDismiss,
                    child: Text(l10n.resumeDismissButton),
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  button: true,
                  label: l10n.resumeSemanticLabel,
                  child: FilledButton(
                    onPressed: () => context.push('/session/daily'),
                    child: Text(l10n.resumeCtaButton),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AllReviewedCard extends ConsumerWidget {
  const _AllReviewedCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final modeAsync = ref.watch(learningModeProvider);
    final activeLessonId = modeAsync.value?.activeLessonId ??
        modeAsync.value?.suggestedLessonId;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.allReviewedTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.allReviewedSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                Semantics(
                  button: true,
                  label: l10n.allReviewedExplore,
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/vocabulary'),
                    icon: const Icon(Icons.menu_book, size: 18),
                    label: Text(l10n.allReviewedExplore),
                  ),
                ),
                if (activeLessonId != null)
                  Semantics(
                    button: true,
                    label: l10n.allReviewedReviewEarly,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(
                        '/session/flashcard/$activeLessonId',
                      ),
                      icon: const Icon(Icons.replay, size: 18),
                      label: Text(l10n.allReviewedReviewEarly),
                    ),
                  ),
                Semantics(
                  button: true,
                  label: l10n.allReviewedQuiz,
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/exercises'),
                    icon: const Icon(Icons.quiz, size: 18),
                    label: Text(l10n.allReviewedQuiz),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakSection extends ConsumerStatefulWidget {
  const _StreakSection();

  @override
  ConsumerState<_StreakSection> createState() => _StreakSectionState();
}

class _StreakSectionState extends ConsumerState<_StreakSection> {
  bool _streakBrokenDismissed = false;
  bool _checkPerformed = false;

  @override
  void initState() {
    super.initState();
    // Perform streak check once on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_checkPerformed) {
        _checkPerformed = true;
        ref.read(streakCheckProvider.notifier).performCheck();
      }
    });

    // Show freeze-used snackbar via listener (not in build)
    ref.listenManual(streakCheckProvider, (previous, next) {
      if (next != null && next.wasFreezeUsed && previous == null) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.streakFreezeUsedMessage),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(streakCheckProvider);
    final l10n = AppLocalizations.of(context)!;

    if (result == null) return const SizedBox.shrink();

    // Show streak broken card
    if (result.wasStreakBroken && !_streakBrokenDismissed) {
      return _StreakBrokenCard(
        onDismiss: () => setState(() => _streakBrokenDismissed = true),
      );
    }

    final streak = result.streak;

    final freezeLabel = streak.freezeAvailable
        ? l10n.streakFreezeAvailable
        : l10n.streakFreezeUsed;

    return Semantics(
      label: l10n.streakSemanticLabel(
        streak.currentStreak,
        streak.longestStreak,
        freezeLabel,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.local_fire_department,
                size: 36,
                color: streak.currentStreak > 0
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      streak.currentStreak > 0
                          ? l10n.streakDaysCount(streak.currentStreak)
                          : l10n.streakEncouragement,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (streak.longestStreak > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          l10n.streakRecord(streak.longestStreak),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
              _FreezeIndicator(streak: streak),
            ],
          ),
        ),
      ),
    );
  }
}

class _FreezeIndicator extends StatelessWidget {
  const _FreezeIndicator({required this.streak});

  final StreakModel streak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final available = streak.freezeAvailable;

    return Tooltip(
      message:
          available ? l10n.streakFreezeAvailable : l10n.streakFreezeUsed,
      child: ExcludeSemantics(
        child: Icon(
          Icons.ac_unit,
          size: 24,
          color: available ? colorScheme.primary : colorScheme.outlineVariant,
        ),
      ),
    );
  }
}

class _StreakBrokenCard extends StatelessWidget {
  const _StreakBrokenCard({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: '${l10n.streakBrokenTitle}. ${l10n.streakBrokenMessage}',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.favorite,
                    size: 36,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.streakBrokenTitle,
                          style:
                              Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.streakBrokenMessage,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Semantics(
                  button: true,
                  label: l10n.streakBrokenCta,
                  child: FilledButton(
                    onPressed: onDismiss,
                    child: Text(l10n.streakBrokenCta),
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

class _ResumeCard extends StatelessWidget {
  const _ResumeCard({required this.lessonName, required this.onTap});

  final String lessonName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: '${l10n.resumeLastLesson} $lessonName',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.play_arrow,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.lastLessonVisited,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lessonName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: Text(l10n.resumeLastLesson),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
