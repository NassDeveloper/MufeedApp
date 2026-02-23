import 'package:flutter/material.dart';

import '../../core/constants/animation_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/srs_constants.dart';
import '../../l10n/app_localizations.dart';

class RatingDistribution extends StatefulWidget {
  const RatingDistribution({
    required this.ratingCounts,
    required this.totalItems,
    super.key,
  });

  final Map<int, int> ratingCounts;
  final int totalItems;

  @override
  State<RatingDistribution> createState() => _RatingDistributionState();
}

class _RatingDistributionState extends State<RatingDistribution>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static Duration get _totalDuration => Duration(
        milliseconds: AnimationConstants.summaryBarDuration.inMilliseconds +
            3 * AnimationConstants.summaryBarDelay.inMilliseconds,
      );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _totalDuration,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bars = [
      _BarData(
        label: l10n.ratingAgain,
        count: widget.ratingCounts[SrsConstants.ratingAgain] ?? 0,
        color: AppColors.ratingAgain,
      ),
      _BarData(
        label: l10n.ratingHard,
        count: widget.ratingCounts[SrsConstants.ratingHard] ?? 0,
        color: AppColors.ratingHard,
      ),
      _BarData(
        label: l10n.ratingGood,
        count: widget.ratingCounts[SrsConstants.ratingGood] ?? 0,
        color: AppColors.ratingGood,
      ),
      _BarData(
        label: l10n.ratingEasy,
        count: widget.ratingCounts[SrsConstants.ratingEasy] ?? 0,
        color: AppColors.ratingEasy,
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final bar in bars) ...[
          _AnimatedBar(
            label: bar.label,
            count: bar.count,
            total: widget.totalItems,
            color: bar.color,
            controller: _controller,
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _BarData {
  const _BarData({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;
}

class _AnimatedBar extends StatefulWidget {
  const _AnimatedBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
    required this.controller,
  });

  final String label;
  final int count;
  final int total;
  final Color color;
  final AnimationController controller;

  @override
  State<_AnimatedBar> createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<_AnimatedBar> {
  late CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();
    _animation = CurvedAnimation(
      parent: widget.controller,
      curve: AnimationConstants.summaryBarCurve,
    );
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fraction = widget.total > 0 ? widget.count / widget.total : 0.0;

    return Semantics(
      label: '${widget.label}: ${widget.count}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.label,
                  style: Theme.of(context).textTheme.bodyLarge),
              Text('${widget.count}',
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: 4),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 12,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: widget.color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: fraction * _animation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
