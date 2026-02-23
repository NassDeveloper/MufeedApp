import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/models/badge_model.dart';
import '../../domain/models/progress_stats_model.dart';
import '../../l10n/app_localizations.dart';
import '../extensions/badge_type_ui.dart';
import '../providers/badge_provider.dart';
import '../providers/progress_provider.dart';
import '../widgets/error_content_widget.dart';
import '../widgets/skeleton_loader_widget.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncStats = ref.watch(progressStatsProvider);
    final asyncBadges = ref.watch(allBadgesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabStatistics)),
      body: asyncStats.when(
        loading: () => const SkeletonListLoader(itemCount: 3),
        error: (_, _) => ErrorContent(
          message: l10n.errorLoadingContent,
          onRetry: () {
            ref.invalidate(progressStatsProvider);
            ref.invalidate(allBadgesProvider);
          },
          retryLabel: l10n.retry,
        ),
        data: (stats) {
          final hasActivity = stats.learningCount > 0 ||
              stats.reviewCount > 0 ||
              stats.relearningCount > 0;
          if (stats.totalItems == 0 || !hasActivity) {
            return _EmptyState(l10n: l10n);
          }
          return asyncBadges.when(
            loading: () => _StatsContent(
              stats: stats,
              l10n: l10n,
              badges: const [],
            ),
            error: (_, _) => _StatsContent(
              stats: stats,
              l10n: l10n,
              badges: const [],
            ),
            data: (badges) => _StatsContent(
              stats: stats,
              l10n: l10n,
              badges: badges,
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bar_chart_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.statsEmpty,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Semantics(
              button: true,
              label: l10n.statsEmptyAction,
              child: FilledButton(
                onPressed: () => context.go('/vocabulary'),
                child: Text(l10n.statsEmptyAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsContent extends StatelessWidget {
  const _StatsContent({
    required this.stats,
    required this.l10n,
    required this.badges,
  });

  final ProgressStatsModel stats;
  final AppLocalizations l10n;
  final List<BadgeModel> badges;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final segments = [
      _SegmentData(
        label: l10n.statsNew,
        count: stats.newCount,
        color: colorScheme.outline,
      ),
      _SegmentData(
        label: l10n.statsLearning,
        count: stats.learningCount,
        color: AppColors.ratingHard,
      ),
      _SegmentData(
        label: l10n.statsReview,
        count: stats.reviewCount,
        color: AppColors.ratingEasy,
      ),
      _SegmentData(
        label: l10n.statsRelearning,
        count: stats.relearningCount,
        color: AppColors.ratingAgain,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statsOverview,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.statsWordsTotal(stats.totalItems),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.statsSessionsCompleted(stats.sessionCount),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          _SegmentedProgressBar(
            segments: segments,
            total: stats.totalItems,
          ),
          const SizedBox(height: 24),
          ...segments.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _LegendRow(segment: s),
            ),
          ),
          if (badges.isNotEmpty) ...[
            const SizedBox(height: 32),
            Text(
              l10n.badgeSectionTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _BadgesGrid(badges: badges, l10n: l10n),
          ],
        ],
      ),
    );
  }
}

class _BadgesGrid extends StatelessWidget {
  const _BadgesGrid({required this.badges, required this.l10n});

  final List<BadgeModel> badges;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: badges.map((badge) {
        return _BadgeTile(badge: badge, l10n: l10n);
      }).toList(),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge, required this.l10n});

  final BadgeModel badge;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = badge.badgeType.label(l10n);
    final description = badge.badgeType.description(l10n);
    final isUnlocked = badge.isUnlocked;

    return Semantics(
      label: isUnlocked
          ? l10n.badgeSemanticUnlocked(label)
          : l10n.badgeSemanticLocked(label),
      child: Tooltip(
        message: description,
        child: SizedBox(
          width: 80,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isUnlocked
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHighest,
                ),
                child: Icon(
                  badge.badgeType.icon,
                  size: 28,
                  color: isUnlocked
                      ? colorScheme.primary
                      : colorScheme.outline.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isUnlocked
                          ? colorScheme.onSurface
                          : colorScheme.outline,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentData {
  const _SegmentData({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;
}

class _SegmentedProgressBar extends StatelessWidget {
  const _SegmentedProgressBar({
    required this.segments,
    required this.total,
  });

  final List<_SegmentData> segments;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      label: l10n.statsProgressBar,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 24,
          child: total == 0
              ? Container(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                )
              : Row(
                  children: segments
                      .where((s) => s.count > 0)
                      .map(
                        (s) => Expanded(
                          flex: s.count,
                          child: Container(color: s.color),
                        ),
                      )
                      .toList(),
                ),
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.segment});

  final _SegmentData segment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: segment.color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            segment.label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          '${segment.count}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
