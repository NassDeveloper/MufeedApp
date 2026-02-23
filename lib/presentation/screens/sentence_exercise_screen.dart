import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../providers/sentence_exercise_session_provider.dart';
import '../utils/confirm_quit_session.dart';
import '../widgets/fade_in_widget.dart';
import '../widgets/skeleton_loader_widget.dart';

class SentenceExerciseScreen extends ConsumerStatefulWidget {
  const SentenceExerciseScreen({required this.lessonId, super.key});

  final int lessonId;

  @override
  ConsumerState<SentenceExerciseScreen> createState() =>
      _SentenceExerciseScreenState();
}

class _SentenceExerciseScreenState
    extends ConsumerState<SentenceExerciseScreen> {
  bool _isLoading = true;
  bool _hasExercises = true;
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  Future<void> _startSession() async {
    final notifier = ref.read(sentenceExerciseProvider.notifier);
    await notifier.startSession(widget.lessonId);
    if (!mounted) return;

    final state = ref.read(sentenceExerciseProvider);
    setState(() {
      _isLoading = false;
      _hasExercises = state != null;
    });
  }

  void _onChoiceTapped(int index) {
    final notifier = ref.read(sentenceExerciseProvider.notifier);
    notifier.submitAnswer(index);

    final state = ref.read(sentenceExerciseProvider);
    if (state == null) return;

    if (state.isCorrect == true) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  void _onNext() {
    final notifier = ref.read(sentenceExerciseProvider.notifier);
    notifier.nextExercise();

    final state = ref.read(sentenceExerciseProvider);
    if (state != null && state.isCompleted) {
      // Show summary inline — no separate screen needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.sentenceExerciseTitle),
        ),
        body: const FadeIn(child: SkeletonListLoader(itemCount: 4)),
      );
    }

    if (!_hasExercises) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.sentenceExerciseTitle),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit_note,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.sentenceExerciseEmpty,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.quizEmptyAction),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final state = ref.watch(sentenceExerciseProvider);
    if (state == null) return const SizedBox.shrink();

    if (state.isCompleted) {
      return _CompletedView(
        score: state.score,
        total: state.totalExercises,
        l10n: l10n,
        onRestart: () {
          setState(() => _isLoading = true);
          _startSession();
        },
        onClose: () {
          ref.read(sentenceExerciseProvider.notifier).endSession();
          context.pop();
        },
      );
    }

    final exercise = state.currentExercise;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await confirmQuitSession(context)) {
          ref.read(sentenceExerciseProvider.notifier).endSession();
          if (context.mounted) context.pop();
        }
      },
      child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            if (await confirmQuitSession(context)) {
              ref.read(sentenceExerciseProvider.notifier).endSession();
              if (context.mounted) context.pop();
            }
          },
        ),
        title: Text(
          l10n.quizProgress(
            state.currentIndex + 1,
            state.totalExercises,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (state.currentIndex + 1) / state.totalExercises,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // French sentence with blank highlighted
            Text(
              l10n.completeTheSentence,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 12),
            _SentenceCard(
              sentence: exercise.sentenceFr,
              isArabic: false,
            ),
            const SizedBox(height: 12),
            _SentenceCard(
              sentence: exercise.sentenceAr,
              isArabic: true,
            ),
            const SizedBox(height: 32),

            // Choices
            ...List.generate(exercise.choices.length, (index) {
              final choice = exercise.choices[index];
              final isSelected = state.selectedIndex == index;
              final isCorrectChoice = index == exercise.correctIndex;

              Color? backgroundColor;
              Color? borderColor;
              if (state.hasAnswered) {
                if (isSelected && state.isCorrect!) {
                  backgroundColor = AppColors.ratingEasy.withValues(alpha: 0.15);
                  borderColor = AppColors.ratingEasy;
                } else if (isSelected && !state.isCorrect!) {
                  backgroundColor = AppColors.ratingAgain.withValues(alpha: 0.15);
                  borderColor = AppColors.ratingAgain;
                } else if (isCorrectChoice && !state.isCorrect!) {
                  backgroundColor = AppColors.ratingEasy.withValues(alpha: 0.1);
                  borderColor = AppColors.ratingEasy;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: backgroundColor ??
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: borderColor ??
                          Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.3),
                      width: borderColor != null ? 2 : 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: state.hasAnswered ? null : () => _onChoiceTapped(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          choice,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),

            // Explanation
            if (state.hasAnswered) ...[
              const SizedBox(height: 16),
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 300),
                child: Card(
                  color: state.isCorrect!
                      ? AppColors.ratingEasy.withValues(alpha: 0.08)
                      : AppColors.ratingAgain.withValues(alpha: 0.08),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          state.isCorrect!
                              ? Icons.check_circle_outline
                              : Icons.info_outline,
                          color: state.isCorrect!
                              ? AppColors.ratingEasy
                              : AppColors.ratingAgain,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.currentExplanation,
                            style:
                                Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _onNext,
                child: Text(l10n.sentenceExerciseNext),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }
}

class _SentenceCard extends StatelessWidget {
  const _SentenceCard({
    required this.sentence,
    required this.isArabic,
  });

  final String sentence;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    // Replace ___ with a highlighted blank
    final parts = sentence.split('___');
    final textDirection = isArabic ? TextDirection.rtl : TextDirection.ltr;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Directionality(
          textDirection: textDirection,
          child: Text.rich(
            TextSpan(
              children: [
                for (var i = 0; i < parts.length; i++) ...[
                  TextSpan(
                    text: parts[i],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          height: 1.8,
                        ),
                  ),
                  if (i < parts.length - 1)
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: Container(
                        width: 60,
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _CompletedView extends StatelessWidget {
  const _CompletedView({
    required this.score,
    required this.total,
    required this.l10n,
    required this.onRestart,
    required this.onClose,
  });

  final int score;
  final int total;
  final AppLocalizations l10n;
  final VoidCallback onRestart;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final percent = total > 0 ? (score / total * 100).round() : 0;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose,
        ),
        title: Text(l10n.sentenceExerciseTitle),
      ),
      body: FadeIn(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  percent >= 80 ? Icons.emoji_events : Icons.school,
                  size: 64,
                  color: percent >= 80
                      ? AppColors.ratingEasy
                      : colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  '$score / $total',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$percent%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: onRestart,
                  child: Text(l10n.quizSummaryRestart),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: onClose,
                  child: Text(l10n.quizEmptyAction),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
