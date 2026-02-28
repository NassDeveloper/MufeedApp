import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/models/badge_model.dart';
import '../../domain/models/daily_activity_model.dart';
import '../../domain/models/progress_stats_model.dart';
import '../../domain/models/upcoming_reviews_model.dart';
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
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.statisticsScreenTitle),
            Text(
              l10n.statisticsScreenSubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
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

class _StatsContent extends ConsumerWidget {
  const _StatsContent({
    required this.stats,
    required this.l10n,
    required this.badges,
  });

  final ProgressStatsModel stats;
  final AppLocalizations l10n;
  final List<BadgeModel> badges;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular progress + summary
          _CircularProgressSection(
            stats: stats,
            segments: segments,
            l10n: l10n,
          ),
          const SizedBox(height: 20),

          // Stats grid
          _StatsGrid(stats: stats, segments: segments, l10n: l10n),
          const SizedBox(height: 20),

          // Segmented bar
          _SegmentedProgressBar(segments: segments, total: stats.totalItems),
          const SizedBox(height: 20),

          // Legend
          ...segments.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _LegendRow(segment: s),
            ),
          ),
          const SizedBox(height: 20),

          // Vocab vs Verb breakdown
          _ContentTypeProgressCard(
            icon: Icons.abc,
            title: l10n.statsVocabulary,
            typeStats: stats.vocabStats,
            l10n: l10n,
          ),
          const SizedBox(height: 12),
          _ContentTypeProgressCard(
            icon: Icons.edit_note,
            title: l10n.statsVerbs,
            typeStats: stats.verbStats,
            l10n: l10n,
          ),
          const SizedBox(height: 20),

          // Activity chart
          _ActivityChart(l10n: l10n),
          const SizedBox(height: 20),

          // Upcoming reviews
          _UpcomingReviews(l10n: l10n),

          // Badges
          if (badges.isNotEmpty) ...[
            const SizedBox(height: 24),
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

class _CircularProgressSection extends StatelessWidget {
  const _CircularProgressSection({
    required this.stats,
    required this.segments,
    required this.l10n,
  });

  final ProgressStatsModel stats;
  final List<_SegmentData> segments;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mastered = stats.reviewCount;
    final total = stats.totalItems;
    final percent = total > 0 ? (mastered / total * 100).round() : 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CustomPaint(
                painter: _DonutChartPainter(
                  segments: segments,
                  total: total,
                  backgroundColor:
                      colorScheme.outline.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$percent%',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        l10n.statsReview,
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.statsOverview,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.statsWordsTotal(total),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.statsSessionsCompleted(stats.sessionCount),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
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

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.stats,
    required this.segments,
    required this.l10n,
  });

  final ProgressStatsModel stats;
  final List<_SegmentData> segments;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: l10n.statsLearning,
            count: stats.learningCount,
            color: AppColors.ratingHard,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            label: l10n.statsReview,
            count: stats.reviewCount,
            color: AppColors.ratingEasy,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            label: l10n.statsRelearning,
            count: stats.relearningCount,
            color: AppColors.ratingAgain,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Column(
          children: [
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
      spacing: 12,
      runSpacing: 12,
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
                  border: isUnlocked
                      ? Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          width: 2,
                        )
                      : null,
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

class _ContentTypeProgressCard extends StatelessWidget {
  const _ContentTypeProgressCard({
    required this.icon,
    required this.title,
    required this.typeStats,
    required this.l10n,
  });

  final IconData icon;
  final String title;
  final ContentTypeStats typeStats;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final total = typeStats.totalItems;
    final mastered = typeStats.reviewCount;
    final progress = total > 0 ? mastered / total : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                Text(
                  l10n.statsItemsTotal(total),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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
                backgroundColor: colorScheme.outline.withValues(alpha: 0.15),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.ratingEasy),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.statsMastered(mastered),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.ratingEasy,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (typeStats.learningCount > 0)
                  Text(
                    '${typeStats.learningCount} ${l10n.statsLearning.toLowerCase()}',
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

class _DonutChartPainter extends CustomPainter {
  _DonutChartPainter({
    required this.segments,
    required this.total,
    required this.backgroundColor,
  });

  final List<_SegmentData> segments;
  final int total;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    const strokeWidth = 10.0;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    // Background ring
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    if (total == 0) return;

    // Segment arcs
    var startAngle = -math.pi / 2; // Start from top
    for (final segment in segments) {
      if (segment.count == 0) continue;
      final sweepAngle = (segment.count / total) * 2 * math.pi;
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) =>
      total != oldDelegate.total;
}

// ──────────────────────────────────────────────────────────
// Activity chart — 14 derniers jours
// ──────────────────────────────────────────────────────────

class _ActivityChart extends ConsumerWidget {
  const _ActivityChart({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncActivity = ref.watch(recentActivityProvider);

    return asyncActivity.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLoader(width: 180, height: 18),
              SizedBox(height: 12),
              SkeletonLoader(height: 64),
            ],
          ),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (days) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.statsActivityTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _ActivityBarChart(days: days, l10n: l10n),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityBarChart extends StatelessWidget {
  const _ActivityBarChart({required this.days, required this.l10n});

  final List<DailyActivityModel> days;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final maxCount = days.fold(0, (max, d) => d.count > max ? d.count : max);
    final today = DateTime.now();

    return SizedBox(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: days.map((day) {
          final ratio = maxCount == 0 ? 0.0 : day.count / maxCount;
          final barHeight = math.max(4.0, ratio * 56);
          final isToday = day.date.year == today.year &&
              day.date.month == today.month &&
              day.date.day == today.day;

          return Expanded(
            child: Semantics(
              label: '${day.count} ${l10n.statsUpcomingItems(day.count)}',
              excludeSemantics: true,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                height: barHeight,
                decoration: BoxDecoration(
                  color: isToday
                      ? colorScheme.primary
                      : colorScheme.primary.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// Upcoming reviews
// ──────────────────────────────────────────────────────────

class _UpcomingReviews extends ConsumerWidget {
  const _UpcomingReviews({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUpcoming = ref.watch(upcomingReviewsProvider);

    return asyncUpcoming.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLoader(width: 160, height: 18),
              SizedBox(height: 12),
              SkeletonLoader(height: 48),
            ],
          ),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (upcoming) => _UpcomingReviewsCard(upcoming: upcoming, l10n: l10n),
    );
  }
}

class _UpcomingReviewsCard extends StatelessWidget {
  const _UpcomingReviewsCard({
    required this.upcoming,
    required this.l10n,
  });

  final UpcomingReviewsModel upcoming;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final hasAny = upcoming.dueToday > 0 ||
        upcoming.dueTomorrow > 0 ||
        upcoming.dueThisWeek > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.statsUpcomingTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            if (!hasAny)
              Text(
                l10n.statsUpcomingNone,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              )
            else ...[
              _UpcomingRow(
                label: l10n.statsUpcomingToday,
                count: upcoming.dueToday,
                l10n: l10n,
                isPrimary: upcoming.dueToday > 0,
              ),
              const SizedBox(height: 8),
              _UpcomingRow(
                label: l10n.statsUpcomingTomorrow,
                count: upcoming.dueTomorrow,
                l10n: l10n,
              ),
              const SizedBox(height: 8),
              _UpcomingRow(
                label: l10n.statsUpcomingWeek,
                count: upcoming.dueThisWeek,
                l10n: l10n,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UpcomingRow extends StatelessWidget {
  const _UpcomingRow({
    required this.label,
    required this.count,
    required this.l10n,
    this.isPrimary = false,
  });

  final String label;
  final int count;
  final AppLocalizations l10n;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          l10n.statsUpcomingItems(count),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isPrimary ? colorScheme.primary : null,
                fontWeight: isPrimary ? FontWeight.bold : null,
              ),
        ),
      ],
    );
  }
}
