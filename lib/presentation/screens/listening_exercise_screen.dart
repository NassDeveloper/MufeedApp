import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/animation_constants.dart';
import '../../l10n/app_localizations.dart';
import '../providers/listening_session_provider.dart';
import '../providers/tts_provider.dart';
import '../utils/confirm_quit_session.dart';
import '../widgets/quiz_option_widget.dart';
import '../widgets/skeleton_loader_widget.dart';

class ListeningExerciseScreen extends ConsumerStatefulWidget {
  const ListeningExerciseScreen({required this.lessonId, super.key});

  final int lessonId;

  @override
  ConsumerState<ListeningExerciseScreen> createState() =>
      _ListeningExerciseScreenState();
}

class _ListeningExerciseScreenState
    extends ConsumerState<ListeningExerciseScreen> {
  bool _isLoading = true;
  bool _hasEnoughItems = true;
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
    await ref
        .read(listeningSessionProvider.notifier)
        .startSession(widget.lessonId);
    if (!mounted) return;
    final s = ref.read(listeningSessionProvider);
    setState(() {
      _isLoading = false;
      _hasEnoughItems = s != null;
    });
    if (s != null) _playCurrentQuestion();
  }

  void _playCurrentQuestion() {
    final s = ref.read(listeningSessionProvider);
    if (s == null) return;
    ref.read(ttsProvider.notifier).speak(s.currentQuestion.arabic);
  }

  Future<void> _endSession() async {
    if (await confirmQuitSession(context)) {
      ref.read(ttsProvider.notifier).stop();
      ref.read(listeningSessionProvider.notifier).endSession();
      if (mounted) context.pop();
    }
  }

  void _onOptionTapped(int choiceIndex) {
    ref
        .read(listeningSessionProvider.notifier)
        .selectAnswer(choiceIndex);

    final s = ref.read(listeningSessionProvider);
    if (s == null) return;

    if (s.isCorrect == true) {
      HapticFeedback.lightImpact();
      _autoAdvanceTimer?.cancel();
      _autoAdvanceTimer =
          Timer(AnimationConstants.quizCorrectDelay, _advanceOrEnd);
    } else {
      HapticFeedback.heavyImpact();
      Future.delayed(AnimationConstants.quizDoubleHapticDelay, () {
        if (!mounted) return;
        HapticFeedback.heavyImpact();
      });
    }
  }

  void _advanceOrEnd() {
    ref.read(listeningSessionProvider.notifier).nextQuestion();
    final s = ref.read(listeningSessionProvider);
    if (s == null || s.isCompleted) {
      ref.read(ttsProvider.notifier).stop();
      ref.read(listeningSessionProvider.notifier).endSession();
      if (mounted) context.pop();
      return;
    }
    _playCurrentQuestion();
  }

  void _onTapAfterIncorrect() {
    final s = ref.read(listeningSessionProvider);
    if (s == null || s.isCorrect != false) return;
    _advanceOrEnd();
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
          title: Text(l10n.listeningTitle),
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
          title: Text(l10n.listeningTitle),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.hearing_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.listeningEmptyTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.listeningEmptyMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.listeningEmptyAction),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final session = ref.watch(listeningSessionProvider);
    if (session == null) return const SizedBox.shrink();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _endSession();
      },
      child: GestureDetector(
        onTap: session.isCorrect == false ? _onTapAfterIncorrect : null,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              tooltip: l10n.listeningEmptyAction,
              onPressed: _endSession,
            ),
            title: Semantics(
              label: l10n.listeningProgress(
                session.currentIndex + 1,
                session.totalQuestions,
              ),
              child: Text(
                l10n.listeningProgress(
                  session.currentIndex + 1,
                  session.totalQuestions,
                ),
              ),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: LinearProgressIndicator(
                value: (session.currentIndex + 1) / session.totalQuestions,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  const Spacer(),
                  // Play area
                  _PlayArea(
                    session: session,
                    onReplay: _playCurrentQuestion,
                  ),
                  const Spacer(),
                  // MCQ options
                  ...List.generate(session.currentQuestion.choices.length,
                      (index) {
                    final choice = session.currentQuestion.choices[index];
                    final optionState =
                        _getOptionState(session, index, choice);
                    return Padding(
                      key: ValueKey('q${session.currentIndex}_o$index'),
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SizedBox(
                        width: double.infinity,
                        child: QuizOptionWidget(
                          text: choice,
                          optionState: optionState,
                          onTap: session.hasAnswered
                              ? null
                              : () => _onOptionTapped(index),
                          semanticIndex: index + 1,
                        ),
                      ),
                    );
                  }),
                  if (session.isCorrect == false)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        l10n.quizTapToContinue,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    )
                  else
                    const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  QuizOptionState _getOptionState(
      ListeningSessionState session, int index, String choice) {
    if (!session.hasAnswered) return QuizOptionState.idle;

    final isSelected = session.selectedChoiceIndex == index;
    if (isSelected) {
      return session.isCorrect! ? QuizOptionState.correct : QuizOptionState.incorrect;
    }

    if (!session.isCorrect! && choice == session.currentQuestion.correctAnswer) {
      return QuizOptionState.revealed;
    }

    return QuizOptionState.idle;
  }
}

// ---------------------------------------------------------------------------
// Play area widget
// ---------------------------------------------------------------------------

class _PlayArea extends ConsumerWidget {
  const _PlayArea({required this.session, required this.onReplay});

  final ListeningSessionState session;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final ttsState = ref.watch(ttsProvider);
    final isPlaying = ttsState.status == TtsStatus.playing;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Large play button
        Semantics(
          button: true,
          label: l10n.listeningPlayButton,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(56),
              onTap: onReplay,
              child: AnimatedContainer(
                duration: AnimationConstants.quizOptionColorDuration,
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPlaying
                      ? colorScheme.primary
                      : colorScheme.primaryContainer,
                ),
                child: Icon(
                  isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded,
                  size: 48,
                  color: isPlaying
                      ? colorScheme.onPrimary
                      : colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Instruction text
        Text(
          l10n.listeningInstruction,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
        // Show Arabic after answering
        if (session.hasAnswered) ...[
          const SizedBox(height: 12),
          AnimatedOpacity(
            opacity: session.hasAnswered ? 1.0 : 0.0,
            duration: AnimationConstants.quizOptionColorDuration,
            child: Text(
              session.currentQuestion.arabic,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontFamily: 'Scheherazade New',
                  ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ],
    );
  }
}
