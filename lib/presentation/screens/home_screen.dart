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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final prefsSource = ref.watch(sharedPreferencesSourceProvider);
    final lastLessonName = prefsSource.getLastVisitedLessonName();
    final lastLessonRoute = prefsSource.getLastVisitedLessonRoute();
    final learningModeAsync = ref.watch(learningModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          Semantics(
            button: true,
            label: l10n.settingsSemanticButton,
            excludeSemantics: true,
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
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
            _StaggeredItem(
              index: 0,
              controller: _staggerController,
              child: const _WelcomeBanner(),
            ),
            const SizedBox(height: 16),
            _StaggeredItem(
              index: 1,
              controller: _staggerController,
              child: const _StreakSection(),
            ),
            const SizedBox(height: 16),
            _StaggeredItem(
              index: 2,
              controller: _staggerController,
              child: const _ProgressOverview(),
            ),
            const SizedBox(height: 16),
            _StaggeredItem(
              index: 3,
              controller: _staggerController,
              child: const _DailySessionSection(),
            ),
            const SizedBox(height: 16),
            _StaggeredItem(
              index: 4,
              controller: _staggerController,
              child: learningModeAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (modeState) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
            ),
            const SizedBox(height: 16),
            _StaggeredItem(
              index: 5,
              controller: _staggerController,
              child: _QuickActions(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaggeredItem extends StatelessWidget {
  const _StaggeredItem({
    required this.index,
    required this.controller,
    required this.child,
  });

  final int index;
  final AnimationController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.1).clamp(0.0, 0.6);
    final end = (start + 0.5).clamp(0.0, 1.0);
    final curve = Interval(start, end, curve: Curves.easeOut);

    final opacity = CurvedAnimation(parent: controller, curve: curve);
    final offset = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: curve));

    return SlideTransition(
      position: offset,
      child: FadeTransition(
        opacity: opacity,
        child: child,
      ),
    );
  }
}

class _WelcomeBanner extends ConsumerWidget {
  const _WelcomeBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final modeAsync = ref.watch(learningModeProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [colorScheme.primaryContainer, colorScheme.surface]
              : [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.85)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u0628\u0650\u0633\u0652\u0645\u0650 \u0627\u0644\u0644\u0651\u064e\u0647\u0650 \u0627\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0646\u0650 \u0627\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark
                      ? colorScheme.onSurface.withValues(alpha: 0.7)
                      : colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.welcomeBack,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: isDark
                      ? colorScheme.onSurface
                      : colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          modeAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (modeState) {
              final modeName = modeState.isCurriculum
                  ? l10n.homeModeCurriculum
                  : l10n.homeModeAutodidact;
              return Text(
                l10n.homeCurrentMode(modeName),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? colorScheme.onSurface.withValues(alpha: 0.7)
                          : colorScheme.onPrimary.withValues(alpha: 0.8),
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProgressOverview extends ConsumerWidget {
  const _ProgressOverview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final asyncStats = ref.watch(progressStatsProvider);

    return asyncStats.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (stats) {
        if (stats.totalItems == 0) return const SizedBox.shrink();

        final mastered = stats.reviewCount;
        final total = stats.totalItems;
        final progress = total > 0 ? mastered / total : 0.0;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_graph,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.statsOverview,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      '$mastered / $total',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor:
                        colorScheme.outline.withValues(alpha: 0.15),
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.statsWordsTotal(total),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    Text(
                      l10n.statsSessionsCompleted(stats.sessionCount),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.menu_book_outlined,
            label: l10n.tabVocabulary,
            color: colorScheme.primary,
            onTap: () => context.go('/vocabulary'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.quiz_outlined,
            label: l10n.tabExercises,
            color: colorScheme.secondary,
            onTap: () => context.go('/exercises'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.bar_chart_outlined,
            label: l10n.tabStatistics,
            color: colorScheme.tertiary,
            onTap: () => context.go('/statistics'),
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
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
          child: hasNextLevel
              ? Row(
                  children: [
                    Icon(Icons.emoji_events,
                        color: colorScheme.primary, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        l10n.homeNextLevelSuggestion,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        final nextLevel = levels[currentIndex + 1];
                        ref
                            .read(learningModeProvider.notifier)
                            .setActiveLevelId(nextLevel.id);
                      },
                      child: Text(l10n.homeGoToNextLevel),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Icon(Icons.emoji_events,
                        color: colorScheme.primary, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      l10n.homeAllLevelsMastered,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
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
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.today,
                    color: colorScheme.onPrimary,
                    size: 26,
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
                                  fontWeight: FontWeight.bold,
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
                  child: Icon(Icons.wb_sunny, color: colorScheme.onTertiary),
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
                TextButton(
                  onPressed: onDismiss,
                  child: Text(l10n.resumeDismissButton),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => context.push('/session/daily'),
                  child: Text(l10n.resumeCtaButton),
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
            Text(l10n.allReviewedTitle,
                style: Theme.of(context).textTheme.titleMedium),
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
                OutlinedButton.icon(
                  onPressed: () => context.go('/vocabulary'),
                  icon: const Icon(Icons.menu_book, size: 18),
                  label: Text(l10n.allReviewedExplore),
                ),
                if (activeLessonId != null)
                  OutlinedButton.icon(
                    onPressed: () =>
                        context.push('/session/flashcard/$activeLessonId'),
                    icon: const Icon(Icons.replay, size: 18),
                    label: Text(l10n.allReviewedReviewEarly),
                  ),
                OutlinedButton.icon(
                  onPressed: () => context.go('/exercises'),
                  icon: const Icon(Icons.quiz, size: 18),
                  label: Text(l10n.allReviewedQuiz),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_checkPerformed) {
        _checkPerformed = true;
        ref.read(streakCheckProvider.notifier).performCheck();
      }
    });

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

    if (result.wasStreakBroken && !_streakBrokenDismissed) {
      return _StreakBrokenCard(
        onDismiss: () => setState(() => _streakBrokenDismissed = true),
      );
    }

    final streak = result.streak;
    final colorScheme = Theme.of(context).colorScheme;
    final freezeLabel = streak.freezeAvailable
        ? l10n.streakFreezeAvailable
        : l10n.streakFreezeUsed;
    final isMilestone = const {7, 30, 100}.contains(streak.currentStreak);

    return Semantics(
      label: l10n.streakSemanticLabel(
        streak.currentStreak,
        streak.longestStreak,
        freezeLabel,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              if (isMilestone)
                _MilestoneFireIcon()
              else
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: streak.currentStreak > 0
                        ? colorScheme.primary.withValues(alpha: 0.15)
                        : colorScheme.outline.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.local_fire_department,
                    size: 24,
                    color: streak.currentStreak > 0
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
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
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (streak.longestStreak > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          l10n.streakRecord(streak.longestStreak),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
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
      message: available ? l10n.streakFreezeAvailable : l10n.streakFreezeUsed,
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

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.favorite, size: 36, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.streakBrokenTitle,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        l10n.streakBrokenMessage,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
              child: FilledButton(
                onPressed: onDismiss,
                child: Text(l10n.streakBrokenCta),
              ),
            ),
          ],
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
                  child: Icon(Icons.play_arrow,
                      color: colorScheme.onPrimaryContainer),
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
                      Text(lessonName,
                          style: Theme.of(context).textTheme.titleMedium),
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

class _MilestoneFireIcon extends StatefulWidget {
  @override
  State<_MilestoneFireIcon> createState() => _MilestoneFireIconState();
}

class _MilestoneFireIconState extends State<_MilestoneFireIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.local_fire_department,
          size: 24,
          color: Colors.orange,
        ),
      ),
    );
  }
}
