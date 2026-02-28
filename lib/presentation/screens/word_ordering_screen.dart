import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/animation_constants.dart';
import '../../l10n/app_localizations.dart';
import '../providers/word_ordering_session_provider.dart';
import '../utils/confirm_quit_session.dart';
import '../widgets/arabic_text_widget.dart';
import '../widgets/skeleton_loader_widget.dart';

class WordOrderingScreen extends ConsumerStatefulWidget {
  const WordOrderingScreen({required this.lessonId, super.key});

  final int lessonId;

  @override
  ConsumerState<WordOrderingScreen> createState() => _WordOrderingScreenState();
}

class _WordOrderingScreenState extends ConsumerState<WordOrderingScreen> {
  bool _isLoading = true;
  bool _hasEligibleSentences = true;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  Future<void> _startSession() async {
    await ref
        .read(wordOrderingSessionProvider.notifier)
        .startSession(widget.lessonId);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _hasEligibleSentences = ref.read(wordOrderingSessionProvider) != null;
    });
  }

  Future<void> _endSession() async {
    if (await confirmQuitSession(context)) {
      ref.read(wordOrderingSessionProvider.notifier).endSession();
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Watch for session completion and navigate back.
    ref.listen<WordOrderingSessionState?>(
      wordOrderingSessionProvider,
      (prev, next) {
        if (next != null && next.isCompleted && !(prev?.isCompleted ?? false)) {
          HapticFeedback.mediumImpact();
          final router = GoRouter.of(context);
          Future.delayed(AnimationConstants.matchingSuccessDelay, () {
            if (!mounted) return;
            ref.read(wordOrderingSessionProvider.notifier).endSession();
            router.pop();
          });
        }
      },
    );

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.wordOrderingTitle),
        ),
        body: const SkeletonListLoader(itemCount: 4),
      );
    }

    if (!_hasEligibleSentences) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.wordOrderingTitle),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sort_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.wordOrderingEmptyTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.wordOrderingEmptyMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.wordOrderingEmptyAction),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final session = ref.watch(wordOrderingSessionProvider);
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
            tooltip: l10n.wordOrderingEmptyAction,
            onPressed: _endSession,
          ),
          title: Semantics(
            label: l10n.wordOrderingProgress(
              session.currentIndex + 1,
              session.totalSentences,
            ),
            child: Text(
              l10n.wordOrderingProgress(
                session.currentIndex + 1,
                session.totalSentences,
              ),
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: session.totalSentences > 0
                  ? (session.currentIndex + 1) / session.totalSentences
                  : 0,
            ),
          ),
        ),
        body: SafeArea(
          child: _WordOrderingBody(
            session: session,
            onTapToken: (id) =>
                ref.read(wordOrderingSessionProvider.notifier).tapToken(id),
            onRemoveToken: (id) =>
                ref.read(wordOrderingSessionProvider.notifier).removeToken(id),
            onNext: () =>
                ref.read(wordOrderingSessionProvider.notifier).nextSentence(),
            onReset: () {
              final s = ref.read(wordOrderingSessionProvider);
              if (s == null) return;
              for (final t in s.placedTokens) {
                ref.read(wordOrderingSessionProvider.notifier).removeToken(t.id);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _WordOrderingBody extends StatelessWidget {
  const _WordOrderingBody({
    required this.session,
    required this.onTapToken,
    required this.onRemoveToken,
    required this.onNext,
    required this.onReset,
  });

  final WordOrderingSessionState session;
  final void Function(int tokenId) onTapToken;
  final void Function(int tokenId) onRemoveToken;
  final VoidCallback onNext;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isCorrect = session.isAnswerCorrect == true;
    final isWrong = session.isAnswerCorrect == false;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // French prompt card
          Card(
            color: colorScheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                session.currentSentence.frenchPrompt,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Instruction
          Text(
            l10n.wordOrderingInstruction,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Answer area (placed tokens)
          _PlacedTokensArea(
            placedTokens: session.placedTokens,
            isCorrect: isCorrect,
            isWrong: isWrong,
            onRemove: onRemoveToken,
          ),

          const SizedBox(height: 12),

          // Feedback row
          AnimatedSwitcher(
            duration: AnimationConstants.quizOptionColorDuration,
            child: (session.isAnswerCorrect != null)
                ? _FeedbackRow(isCorrect: isCorrect)
                : const SizedBox(height: 24),
          ),

          const SizedBox(height: 16),

          // Available tokens
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final token in session.availableTokens)
                _WordChip(
                  key: ValueKey('avail_${token.id}'),
                  text: token.text,
                  state: _ChipState.available,
                  onTap: () => onTapToken(token.id),
                ),
            ],
          ),

          const Spacer(),

          // Action buttons
          if (isCorrect)
            FilledButton(
              onPressed: onNext,
              child: Text(l10n.wordOrderingNext),
            )
          else if (isWrong)
            OutlinedButton(
              onPressed: onReset,
              child: Text(l10n.wordOrderingReset),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Placed tokens area
// ---------------------------------------------------------------------------

class _PlacedTokensArea extends StatelessWidget {
  const _PlacedTokensArea({
    required this.placedTokens,
    required this.isCorrect,
    required this.isWrong,
    required this.onRemove,
  });

  final List<WordToken> placedTokens;
  final bool isCorrect;
  final bool isWrong;
  final void Function(int tokenId) onRemove;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color borderColor;
    if (isCorrect) {
      borderColor = const Color(0xFF4CAF50);
    } else if (isWrong) {
      borderColor = colorScheme.error;
    } else {
      borderColor = colorScheme.outline;
    }

    return AnimatedContainer(
      duration: AnimationConstants.quizOptionColorDuration,
      curve: AnimationConstants.quizOptionColorCurve,
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor, width: 2),
        ),
        color: isCorrect
            ? const Color(0xFF4CAF50).withValues(alpha: 0.08)
            : isWrong
                ? colorScheme.errorContainer.withValues(alpha: 0.3)
                : colorScheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: placedTokens.isEmpty
          ? Center(
              child: Text(
                '…',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                for (final token in placedTokens)
                  _WordChip(
                    key: ValueKey('placed_${token.id}'),
                    text: token.text,
                    state: isCorrect
                        ? _ChipState.correct
                        : isWrong
                            ? _ChipState.wrong
                            : _ChipState.placed,
                    onTap: () => onRemove(token.id),
                  ),
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Feedback row
// ---------------------------------------------------------------------------

class _FeedbackRow extends StatelessWidget {
  const _FeedbackRow({required this.isCorrect});

  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final color =
        isCorrect ? const Color(0xFF4CAF50) : colorScheme.error;
    final icon = isCorrect ? Icons.check_circle_outline : Icons.cancel_outlined;
    final text =
        isCorrect ? l10n.wordOrderingCorrect : l10n.wordOrderingWrong;

    return SizedBox(
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Word chip
// ---------------------------------------------------------------------------

enum _ChipState { available, placed, correct, wrong }

class _WordChip extends StatelessWidget {
  const _WordChip({
    super.key,
    required this.text,
    required this.state,
    required this.onTap,
  });

  final String text;
  final _ChipState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color textColor;
    late Color borderColor;

    switch (state) {
      case _ChipState.available:
        backgroundColor = colorScheme.surfaceContainerHighest;
        textColor = colorScheme.onSurface;
        borderColor = colorScheme.outlineVariant;
      case _ChipState.placed:
        backgroundColor = colorScheme.primaryContainer;
        textColor = colorScheme.onPrimaryContainer;
        borderColor = colorScheme.primary;
      case _ChipState.correct:
        backgroundColor = const Color(0xFF4CAF50).withValues(alpha: 0.2);
        textColor = const Color(0xFF4CAF50);
        borderColor = const Color(0xFF4CAF50);
      case _ChipState.wrong:
        backgroundColor = colorScheme.errorContainer;
        textColor = colorScheme.onErrorContainer;
        borderColor = colorScheme.error;
    }

    return AnimatedContainer(
      duration: AnimationConstants.quizOptionColorDuration,
      curve: AnimationConstants.quizOptionColorCurve,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: (state == _ChipState.correct) ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ArabicText(
            text,
            style: TextStyle(fontSize: 16, color: textColor),
          ),
        ),
      ),
    );
  }
}
