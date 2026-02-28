import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/dialogue_model.dart';
import '../providers/dialogue_provider.dart';

const int _kMaxDialogues = 3;

// Sentinel object for nullable copyWith fields
const _sentinel = Object();

@immutable
class DialogueSessionState {
  const DialogueSessionState({
    required this.dialogues,
    required this.currentIndex,
    required this.answers,
    this.isCompleted = false,
  });

  final List<DialogueModel> dialogues;
  final int currentIndex;

  /// Maps turn index → selected choice index for the current dialogue.
  final Map<int, int> answers;

  final bool isCompleted;

  DialogueModel get currentDialogue => dialogues[currentIndex];
  int get totalDialogues => dialogues.length;

  bool isTurnAnswered(int turnIndex) => answers.containsKey(turnIndex);

  /// Returns true if the user's answer for [turnIndex] is correct.
  bool? isTurnCorrect(int turnIndex) {
    final turn = currentDialogue.turns[turnIndex];
    if (!turn.isBlank) return null;
    if (!answers.containsKey(turnIndex)) return null;
    return answers[turnIndex] == turn.correctIndex;
  }

  /// Whether all blank turns in the current dialogue have been answered.
  bool get allBlanksAnswered {
    return currentDialogue.blankTurnIndices.every(answers.containsKey);
  }

  DialogueSessionState copyWith({
    int? currentIndex,
    Map<int, int>? answers,
    Object? isCompleted = _sentinel,
  }) {
    return DialogueSessionState(
      dialogues: dialogues,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      isCompleted: isCompleted == _sentinel
          ? this.isCompleted
          : isCompleted as bool,
    );
  }
}

class DialogueSessionNotifier extends Notifier<DialogueSessionState?> {
  @override
  DialogueSessionState? build() => null;

  /// Loads dialogues for [lessonId], shuffles, caps at [_kMaxDialogues].
  /// Sets state to null if no dialogues exist for the lesson.
  Future<void> startSession(int lessonId) async {
    final dialogues = await ref
        .read(dialogueRepositoryProvider)
        .getDialoguesByLessonId(lessonId);

    if (dialogues.isEmpty) {
      state = null;
      return;
    }

    final rng = Random();
    final shuffled = List<DialogueModel>.from(dialogues)..shuffle(rng);
    final selected = List<DialogueModel>.unmodifiable(
        shuffled.take(_kMaxDialogues).toList());

    state = DialogueSessionState(
      dialogues: selected,
      currentIndex: 0,
      answers: const {},
    );
  }

  /// Records the user's answer [choiceIndex] for [turnIndex] in the current dialogue.
  /// Ignored if the turn is already answered.
  void selectAnswer(int turnIndex, int choiceIndex) {
    final s = state;
    if (s == null) return;
    if (s.answers.containsKey(turnIndex)) return; // already answered

    state = s.copyWith(
      answers: {...s.answers, turnIndex: choiceIndex},
    );
  }

  /// Advances to the next dialogue, or completes the session if on the last.
  void nextDialogue() {
    final s = state;
    if (s == null) return;

    final nextIndex = s.currentIndex + 1;
    if (nextIndex >= s.dialogues.length) {
      state = s.copyWith(isCompleted: true);
      return;
    }

    state = s.copyWith(
      currentIndex: nextIndex,
      answers: const {},
    );
  }

  void endSession() {
    state = null;
  }
}

final dialogueSessionProvider =
    NotifierProvider<DialogueSessionNotifier, DialogueSessionState?>(
  () => DialogueSessionNotifier(),
);
