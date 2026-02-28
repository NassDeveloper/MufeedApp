import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/animation_constants.dart';
import '../../domain/models/dialogue_model.dart';
import '../../l10n/app_localizations.dart';
import '../providers/dialogue_session_provider.dart';
import '../utils/confirm_quit_session.dart';
import '../widgets/arabic_text_widget.dart';
import '../widgets/skeleton_loader_widget.dart';

class DialogueExerciseScreen extends ConsumerStatefulWidget {
  const DialogueExerciseScreen({required this.lessonId, super.key});

  final int lessonId;

  @override
  ConsumerState<DialogueExerciseScreen> createState() =>
      _DialogueExerciseScreenState();
}

class _DialogueExerciseScreenState
    extends ConsumerState<DialogueExerciseScreen> {
  bool _isLoading = true;
  bool _hasDialogues = true;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  Future<void> _startSession() async {
    await ref
        .read(dialogueSessionProvider.notifier)
        .startSession(widget.lessonId);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _hasDialogues = ref.read(dialogueSessionProvider) != null;
    });
  }

  Future<void> _endSession() async {
    if (await confirmQuitSession(context)) {
      ref.read(dialogueSessionProvider.notifier).endSession();
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    ref.listen<DialogueSessionState?>(
      dialogueSessionProvider,
      (prev, next) {
        if (next != null && next.isCompleted && !(prev?.isCompleted ?? false)) {
          HapticFeedback.mediumImpact();
          final router = GoRouter.of(context);
          Future.delayed(AnimationConstants.matchingSuccessDelay, () {
            if (!mounted) return;
            ref.read(dialogueSessionProvider.notifier).endSession();
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
          title: Text(l10n.dialogueTitle),
        ),
        body: const SkeletonListLoader(itemCount: 3),
      );
    }

    if (!_hasDialogues) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.dialogueTitle),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.dialogueEmptyTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.dialogueEmptyMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.dialogueEmptyAction),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final session = ref.watch(dialogueSessionProvider);
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
            tooltip: l10n.dialogueEmptyAction,
            onPressed: _endSession,
          ),
          title: Semantics(
            label: l10n.dialogueProgress(
              session.currentIndex + 1,
              session.totalDialogues,
            ),
            child: Text(
              l10n.dialogueProgress(
                session.currentIndex + 1,
                session.totalDialogues,
              ),
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: session.totalDialogues > 0
                  ? (session.currentIndex + 1) / session.totalDialogues
                  : 0,
            ),
          ),
        ),
        body: SafeArea(
          child: _DialogueBody(
            session: session,
            onSelectAnswer: (turnIndex, choiceIndex) => ref
                .read(dialogueSessionProvider.notifier)
                .selectAnswer(turnIndex, choiceIndex),
            onNext: () =>
                ref.read(dialogueSessionProvider.notifier).nextDialogue(),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dialogue body
// ---------------------------------------------------------------------------

class _DialogueBody extends StatelessWidget {
  const _DialogueBody({
    required this.session,
    required this.onSelectAnswer,
    required this.onNext,
  });

  final DialogueSessionState session;
  final void Function(int turnIndex, int choiceIndex) onSelectAnswer;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dialogue = session.currentDialogue;

    return Column(
      children: [
        // Dialogue title
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            dialogue.titleFr,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        // Dialogue turns
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: dialogue.turns.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final turn = dialogue.turns[index];
              return _TurnWidget(
                turn: turn,
                turnIndex: index,
                answeredChoiceIndex: session.answers[index],
                isCorrect: session.isTurnCorrect(index),
                onSelectAnswer: (choiceIndex) =>
                    onSelectAnswer(index, choiceIndex),
              );
            },
          ),
        ),
        // "Next" button when all blanks are answered
        if (session.allBlanksAnswered)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onNext,
                child: Text(l10n.dialogueNext),
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Single turn widget (chat bubble + optional MCQ)
// ---------------------------------------------------------------------------

class _TurnWidget extends StatelessWidget {
  const _TurnWidget({
    required this.turn,
    required this.turnIndex,
    required this.answeredChoiceIndex,
    required this.isCorrect,
    required this.onSelectAnswer,
  });

  final DialogueTurn turn;
  final int turnIndex;
  final int? answeredChoiceIndex;
  final bool? isCorrect;
  final void Function(int choiceIndex) onSelectAnswer;

  bool get _isSpeakerA => turn.speaker == 'A';
  bool get _isAnswered => answeredChoiceIndex != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          _isSpeakerA ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        // Speaker label
        Padding(
          padding: EdgeInsets.only(
            left: _isSpeakerA ? 4 : 0,
            right: _isSpeakerA ? 0 : 4,
            bottom: 2,
          ),
          child: Text(
            turn.speaker,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        // Chat bubble
        _ChatBubble(
          turn: turn,
          answeredChoiceIndex: answeredChoiceIndex,
          isCorrect: isCorrect,
          isSpeakerA: _isSpeakerA,
        ),
        // MCQ choices (only for unanswered blanks)
        if (turn.isBlank && !_isAnswered) ...[
          const SizedBox(height: 8),
          _ChoicesWidget(
            choices: turn.choices!,
            onSelect: onSelectAnswer,
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Chat bubble
// ---------------------------------------------------------------------------

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.turn,
    required this.answeredChoiceIndex,
    required this.isCorrect,
    required this.isSpeakerA,
  });

  final DialogueTurn turn;
  final int? answeredChoiceIndex;
  final bool? isCorrect;
  final bool isSpeakerA;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAnswered = answeredChoiceIndex != null;

    Color backgroundColor;
    Color textColor;

    if (turn.isBlank) {
      if (!isAnswered) {
        backgroundColor = colorScheme.secondaryContainer;
        textColor = colorScheme.onSecondaryContainer;
      } else if (isCorrect == true) {
        backgroundColor = const Color(0xFF4CAF50).withValues(alpha: 0.2);
        textColor = const Color(0xFF4CAF50);
      } else {
        backgroundColor = colorScheme.errorContainer;
        textColor = colorScheme.onErrorContainer;
      }
    } else {
      backgroundColor = isSpeakerA
          ? colorScheme.surfaceContainerHighest
          : colorScheme.primaryContainer;
      textColor = isSpeakerA ? colorScheme.onSurface : colorScheme.onPrimaryContainer;
    }

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: isSpeakerA ? Radius.zero : const Radius.circular(16),
      bottomRight: isSpeakerA ? const Radius.circular(16) : Radius.zero,
    );

    // Determine Arabic text to show
    String arabicText;
    if (turn.isBlank) {
      if (!isAnswered) {
        arabicText = '؟  ؟  ؟';
      } else {
        arabicText = turn.choices![answeredChoiceIndex!];
      }
    } else {
      arabicText = turn.arabic;
    }

    return AnimatedContainer(
      duration: AnimationConstants.quizOptionColorDuration,
      curve: AnimationConstants.quizOptionColorCurve,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Arabic text
          ArabicText(
            arabicText,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              fontStyle: (turn.isBlank && !isAnswered)
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 2),
          // French translation
          Text(
            turn.translationFr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor.withValues(alpha: 0.75),
                ),
          ),
          // Correct answer hint when wrong
          if (turn.isBlank && isAnswered && isCorrect == false) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 12,
                    color: Color(0xFF4CAF50)),
                const SizedBox(width: 4),
                Flexible(
                  child: ArabicText(
                    turn.correctChoice!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MCQ choices widget
// ---------------------------------------------------------------------------

class _ChoicesWidget extends StatelessWidget {
  const _ChoicesWidget({required this.choices, required this.onSelect});

  final List<String> choices;
  final void Function(int index) onSelect;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < choices.length; i++)
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: AnimationConstants.quizOptionColorDuration,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline),
              ),
              child: ArabicText(
                choices[i],
                style: TextStyle(
                  fontSize: 15,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
