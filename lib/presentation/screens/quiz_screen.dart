import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/animation_constants.dart';
import '../../l10n/app_localizations.dart';
import '../providers/quiz_session_provider.dart';
import '../widgets/arabic_text_widget.dart';
import '../widgets/quiz_option_widget.dart';
import '../widgets/skeleton_loader_widget.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({required this.lessonId, super.key});

  final int lessonId;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasEnoughItems = true;
  bool _hasError = false;
  final List<_ConfettiParticle> _confettiParticles = [];
  AnimationController? _confettiController;
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: AnimationConstants.quizConfettiDuration,
    );
    _startSession();
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _confettiController?.dispose();
    super.dispose();
  }

  Future<void> _startSession() async {
    try {
      final notifier = ref.read(quizSessionProvider.notifier);
      await notifier.startSession(widget.lessonId);
      if (!mounted) return;

      final state = ref.read(quizSessionProvider);
      setState(() {
        _isLoading = false;
        _hasEnoughItems = state != null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _onOptionTapped(String answer) {
    final notifier = ref.read(quizSessionProvider.notifier);
    notifier.submitAnswer(answer);

    final state = ref.read(quizSessionProvider);
    if (state == null) return;

    if (state.isCorrect == true) {
      HapticFeedback.lightImpact();
      _triggerConfetti();
      _autoAdvanceTimer?.cancel();
      _autoAdvanceTimer = Timer(AnimationConstants.quizCorrectDelay, () {
        if (!mounted) return;
        _advanceOrEnd();
      });
    } else {
      HapticFeedback.heavyImpact();
      Future.delayed(AnimationConstants.quizDoubleHapticDelay, () {
        if (!mounted) return;
        HapticFeedback.heavyImpact();
      });
    }
  }

  void _onTapAfterIncorrect() {
    final state = ref.read(quizSessionProvider);
    if (state == null || state.isCorrect != false) return;
    _advanceOrEnd();
  }

  Future<void> _advanceOrEnd() async {
    final notifier = ref.read(quizSessionProvider.notifier);
    notifier.nextQuestion();

    final state = ref.read(quizSessionProvider);
    if (state != null && state.isCompleted) {
      try {
        await notifier.completeSession();
      } catch (_) {
        // DB save failure is non-blocking — the user still sees the summary
      }
      if (mounted) {
        context.pushReplacement(
          '/session/quiz-summary/${widget.lessonId}',
        );
      }
    }
  }

  void _triggerConfetti() {
    final random = Random();
    setState(() {
      _confettiParticles.clear();
      for (var i = 0; i < 6; i++) {
        _confettiParticles.add(_ConfettiParticle(
          x: 0.2 + random.nextDouble() * 0.6,
          delay: random.nextDouble() * 0.3,
          color: [
            const Color(0xFFFFD700),
            const Color(0xFFFFA500),
            const Color(0xFF4CAF50),
          ][i % 3],
        ));
      }
    });
    _confettiController!.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.quizEmptyAction,
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.quizTitle),
        ),
        body: const SkeletonListLoader(itemCount: 4),
      );
    }

    if (_hasError) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.quizEmptyAction,
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.quizTitle),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(l10n.errorLoadingContent),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _hasError = false;
                  });
                  _startSession();
                },
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (!_hasEnoughItems) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.quizEmptyAction,
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.quizTitle),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.quiz_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.quizEmptyTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.quizEmptyMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
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

    final state = ref.watch(quizSessionProvider);
    if (state == null) {
      return const SizedBox.shrink();
    }

    final question = state.currentQuestion;

    return GestureDetector(
      onTap: state.isCorrect == false ? _onTapAfterIncorrect : null,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.quizEmptyAction,
            onPressed: () {
              ref.read(quizSessionProvider.notifier).endSession();
              context.pop();
            },
          ),
          title: Semantics(
            label: l10n.quizSemanticQuestion(
              state.currentIndex + 1,
              state.totalQuestions,
            ),
            child: Text(
              l10n.quizProgress(
                state.currentIndex + 1,
                state.totalQuestions,
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: (state.currentIndex + 1) / state.totalQuestions,
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  ArabicText(
                    question.arabic,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const Spacer(),
                  ...List.generate(question.choices.length, (index) {
                    final choice = question.choices[index];
                    final optionState = _getOptionState(state, choice);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SizedBox(
                        width: double.infinity,
                        child: QuizOptionWidget(
                          text: choice,
                          optionState: optionState,
                          onTap: state.hasAnswered
                              ? null
                              : () => _onOptionTapped(choice),
                          semanticIndex: index + 1,
                        ),
                      ),
                    );
                  }),
                  if (state.isCorrect == false)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        l10n.quizTapToContinue,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            // Confetti overlay
            if (_confettiParticles.isNotEmpty)
              AnimatedBuilder(
                animation: _confettiController!,
                builder: (context, _) {
                  return CustomPaint(
                    size: MediaQuery.sizeOf(context),
                    painter: _ConfettiPainter(
                      particles: _confettiParticles,
                      progress: _confettiController!.value,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  QuizOptionState _getOptionState(QuizSessionState state, String choice) {
    if (!state.hasAnswered) return QuizOptionState.idle;

    if (choice == state.selectedAnswer) {
      return state.isCorrect! ? QuizOptionState.correct : QuizOptionState.incorrect;
    }

    if (!state.isCorrect! && choice == state.currentQuestion.correctAnswer) {
      return QuizOptionState.revealed;
    }

    return QuizOptionState.idle;
  }
}

class _ConfettiParticle {
  const _ConfettiParticle({
    required this.x,
    required this.delay,
    required this.color,
  });

  final double x;
  final double delay;
  final Color color;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.particles, required this.progress});

  final List<_ConfettiParticle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final adjustedProgress = ((progress - particle.delay) / (1 - particle.delay))
          .clamp(0.0, 1.0);
      if (adjustedProgress <= 0) continue;

      final paint = Paint()
        ..color = particle.color.withValues(alpha: 1.0 - adjustedProgress)
        ..style = PaintingStyle.fill;

      final x = particle.x * size.width;
      final y = size.height * 0.3 + (adjustedProgress * size.height * 0.4);

      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
