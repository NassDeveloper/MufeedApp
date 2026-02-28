import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/animation_constants.dart';
import '../../l10n/app_localizations.dart';
import '../providers/matching_session_provider.dart';
import '../utils/confirm_quit_session.dart';
import '../widgets/arabic_text_widget.dart';
import '../widgets/skeleton_loader_widget.dart';

class MatchingExerciseScreen extends ConsumerStatefulWidget {
  const MatchingExerciseScreen({required this.lessonId, super.key});

  final int lessonId;

  @override
  ConsumerState<MatchingExerciseScreen> createState() =>
      _MatchingExerciseScreenState();
}

class _MatchingExerciseScreenState
    extends ConsumerState<MatchingExerciseScreen> {
  bool _isLoading = true;
  bool _hasEnoughItems = true;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  Future<void> _startSession() async {
    final notifier = ref.read(matchingSessionProvider.notifier);
    await notifier.startSession(widget.lessonId);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _hasEnoughItems = ref.read(matchingSessionProvider) != null;
    });
  }

  Future<void> _endSession() async {
    if (await confirmQuitSession(context)) {
      ref.read(matchingSessionProvider.notifier).endSession();
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Listen for completion and navigate back after a short delay
    // Listen for completion and navigate back after a short delay.
    // Capture the router before the async gap to satisfy the linter.
    ref.listen<MatchingSessionState?>(matchingSessionProvider, (prev, next) {
      if (next != null && next.isCompleted && !(prev?.isCompleted ?? false)) {
        HapticFeedback.mediumImpact();
        final router = GoRouter.of(context);
        Future.delayed(AnimationConstants.matchingSuccessDelay, () {
          if (!mounted) return;
          ref.read(matchingSessionProvider.notifier).endSession();
          router.pop();
        });
      }
    });

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.matchingTitle),
        ),
        body: const SkeletonListLoader(itemCount: 4),
      );
    }

    if (!_hasEnoughItems) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.matchingTitle),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.link_off,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.matchingEmptyTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.matchingEmptyMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.matchingEmptyAction),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final session = ref.watch(matchingSessionProvider);
    if (session == null) return const SizedBox.shrink();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _endSession();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.matchingEmptyAction,
            onPressed: _endSession,
          ),
          title: Semantics(
            label: l10n.matchingProgress(
              session.matchedCount,
              session.totalPairs,
            ),
            child: Text(
              l10n.matchingProgress(
                session.matchedCount,
                session.totalPairs,
              ),
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: session.totalPairs > 0
                  ? session.matchedCount / session.totalPairs
                  : 0,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // French column (left)
                Expanded(
                  child: _MatchingColumn(
                    items: [
                      for (final idx in session.frenchOrder)
                        _MatchingCardData(
                          pairId: session.pairs[idx].pairId,
                          text: session.pairs[idx].french,
                          isArabic: false,
                          isMatched: session.pairs[idx].isMatched,
                          isSelected:
                              session.selectedFrenchPairId ==
                                  session.pairs[idx].pairId,
                          isFlashing: session.flashingPairIds
                              .contains(session.pairs[idx].pairId),
                        ),
                    ],
                    onTap: (slotIndex) => ref
                        .read(matchingSessionProvider.notifier)
                        .tapFrench(slotIndex),
                  ),
                ),
                const SizedBox(width: 8),
                // Arabic column (right)
                Expanded(
                  child: _MatchingColumn(
                    items: [
                      for (var i = 0; i < session.pairs.length; i++)
                        _MatchingCardData(
                          pairId: session.pairs[i].pairId,
                          text: session.pairs[i].arabic,
                          isArabic: true,
                          isMatched: session.pairs[i].isMatched,
                          isSelected:
                              session.selectedArabicPairId ==
                                  session.pairs[i].pairId,
                          isFlashing: session.flashingPairIds
                              .contains(session.pairs[i].pairId),
                        ),
                    ],
                    onTap: (slotIndex) => ref
                        .read(matchingSessionProvider.notifier)
                        .tapArabic(slotIndex),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MatchingCardData {
  const _MatchingCardData({
    required this.pairId,
    required this.text,
    required this.isArabic,
    required this.isMatched,
    required this.isSelected,
    required this.isFlashing,
  });

  final int pairId;
  final String text;
  final bool isArabic;
  final bool isMatched;
  final bool isSelected;
  final bool isFlashing;
}

class _MatchingColumn extends StatefulWidget {
  const _MatchingColumn({
    required this.items,
    required this.onTap,
  });

  final List<_MatchingCardData> items;
  final void Function(int slotIndex) onTap;

  @override
  State<_MatchingColumn> createState() => _MatchingColumnState();
}

class _MatchingColumnState extends State<_MatchingColumn> {
  @override
  void didUpdateWidget(_MatchingColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger haptic feedback when a new card starts flashing
    for (var i = 0; i < widget.items.length; i++) {
      final wasFlashing = i < oldWidget.items.length &&
          oldWidget.items[i].pairId == widget.items[i].pairId &&
          oldWidget.items[i].isFlashing;
      if (widget.items[i].isFlashing && !wasFlashing) {
        HapticFeedback.heavyImpact();
        break; // one haptic per wrong match
      }
    }
    // Trigger haptic on new match
    for (var i = 0; i < widget.items.length; i++) {
      final wasMatched = i < oldWidget.items.length &&
          oldWidget.items[i].pairId == widget.items[i].pairId &&
          oldWidget.items[i].isMatched;
      if (widget.items[i].isMatched && !wasMatched) {
        HapticFeedback.lightImpact();
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < widget.items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _MatchingTile(
              data: widget.items[i],
              onTap: () => widget.onTap(i),
            ),
          ),
      ],
    );
  }
}

class _MatchingTile extends StatelessWidget {
  const _MatchingTile({required this.data, required this.onTap});

  final _MatchingCardData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color textColor;
    Widget? trailingIcon;

    if (data.isMatched) {
      backgroundColor = const Color(0xFF4CAF50).withValues(alpha: 0.2);
      textColor = const Color(0xFF4CAF50);
      trailingIcon = const Icon(Icons.check_circle_outline,
          size: 16, color: Color(0xFF4CAF50));
    } else if (data.isFlashing) {
      backgroundColor = colorScheme.errorContainer;
      textColor = colorScheme.onErrorContainer;
      trailingIcon = null;
    } else if (data.isSelected) {
      backgroundColor = colorScheme.primaryContainer;
      textColor = colorScheme.onPrimaryContainer;
      trailingIcon = null;
    } else {
      backgroundColor = colorScheme.surfaceContainerHighest;
      textColor = colorScheme.onSurface;
      trailingIcon = null;
    }

    return AnimatedContainer(
      duration: AnimationConstants.quizOptionColorDuration,
      curve: AnimationConstants.quizOptionColorCurve,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: data.isSelected
            ? Border.all(color: colorScheme.primary, width: 2)
            : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: data.isMatched ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            mainAxisAlignment: data.isArabic
                ? MainAxisAlignment.end
                : MainAxisAlignment.spaceBetween,
            children: [
              if (!data.isArabic && trailingIcon != null) trailingIcon,
              Expanded(
                child: data.isArabic
                    ? ArabicText(
                        data.text,
                        style: TextStyle(
                          fontSize: 18,
                          color: textColor,
                        ),
                        textAlign: TextAlign.right,
                      )
                    : Text(
                        data.text,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              if (data.isArabic && trailingIcon != null) ...[
                const SizedBox(width: 4),
                trailingIcon,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
