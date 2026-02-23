import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/animation_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../providers/badge_provider.dart';
import '../providers/learning_mode_provider.dart';
import '../providers/quiz_session_provider.dart';
import '../widgets/arabic_text_widget.dart';
import '../widgets/badge_celebration_overlay.dart';

class QuizSummaryScreen extends ConsumerStatefulWidget {
  const QuizSummaryScreen({required this.lessonId, super.key});

  final int lessonId;

  @override
  ConsumerState<QuizSummaryScreen> createState() => _QuizSummaryScreenState();
}

class _QuizSummaryScreenState extends ConsumerState<QuizSummaryScreen> {
  int _score = 0;
  int _total = 0;
  List<QuizResultEntry> _incorrectResults = const [];

  @override
  void initState() {
    super.initState();
    final session = ref.read(quizSessionProvider);
    if (session != null) {
      _score = session.score;
      _total = session.totalQuestions;
      _incorrectResults =
          List.unmodifiable(session.incorrectResults);
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
    final incorrect = _total - _score;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quizSummaryTitle),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Semantics(
                label: l10n.quizSummarySemanticScore(_score, _total),
                excludeSemantics: true,
                child: Text(
                  l10n.quizSummaryScore(_score, _total),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 32),
              _ScoreDistribution(
                correctCount: _score,
                incorrectCount: incorrect,
                total: _total,
              ),
              const SizedBox(height: 24),
              if (_incorrectResults.isNotEmpty) ...[
                Expanded(child: _MissedWordsList(results: _incorrectResults)),
                const SizedBox(height: 24),
              ] else
                const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    ref.read(quizSessionProvider.notifier).endSession();
                    ref.invalidate(learningModeProvider);
                    context.pushReplacement(
                      '/session/quiz/${widget.lessonId}',
                    );
                  },
                  child: Text(l10n.quizSummaryRestart),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(quizSessionProvider.notifier).endSession();
                    ref.invalidate(learningModeProvider);
                    context.go('/vocabulary');
                  },
                  child: Text(l10n.quizSummaryBackToVocabulary),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    ref.read(quizSessionProvider.notifier).endSession();
                    ref.invalidate(learningModeProvider);
                    context.pushReplacement(
                      '/session/flashcard/${widget.lessonId}',
                    );
                  },
                  child: Text(l10n.quizSummaryGoToFlashcards),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreDistribution extends StatefulWidget {
  const _ScoreDistribution({
    required this.correctCount,
    required this.incorrectCount,
    required this.total,
  });

  final int correctCount;
  final int incorrectCount;
  final int total;

  @override
  State<_ScoreDistribution> createState() => _ScoreDistributionState();
}

class _ScoreDistributionState extends State<_ScoreDistribution>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static Duration get _totalDuration => Duration(
        milliseconds: AnimationConstants.summaryBarDuration.inMilliseconds +
            AnimationConstants.summaryBarDelay.inMilliseconds,
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

    return Column(
      children: [
        _AnimatedScoreBar(
          label: l10n.quizSummaryCorrectLabel,
          count: widget.correctCount,
          total: widget.total,
          color: AppColors.ratingEasy,
          controller: _controller,
        ),
        const SizedBox(height: 16),
        _AnimatedScoreBar(
          label: l10n.quizSummaryIncorrectLabel,
          count: widget.incorrectCount,
          total: widget.total,
          color: AppColors.ratingAgain,
          controller: _controller,
        ),
      ],
    );
  }
}

class _AnimatedScoreBar extends StatefulWidget {
  const _AnimatedScoreBar({
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
  State<_AnimatedScoreBar> createState() => _AnimatedScoreBarState();
}

class _AnimatedScoreBarState extends State<_AnimatedScoreBar> {
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
    final l10n = AppLocalizations.of(context)!;
    final fraction = widget.total > 0 ? widget.count / widget.total : 0.0;

    return Semantics(
      label: l10n.quizSummarySemanticBar(widget.label, widget.count),
      excludeSemantics: true,
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

class _MissedWordsList extends StatelessWidget {
  const _MissedWordsList({required this.results});

  final List<QuizResultEntry> results;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quizSummaryMissedWords,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: results.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final result = results[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: ArabicText(
                        result.arabic,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        result.correctAnswer,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
