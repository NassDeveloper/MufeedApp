import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/quiz_generator.dart';
import 'content_provider.dart';

const int _kMaxQuestions = 8;

@immutable
class ListeningSessionState {
  const ListeningSessionState({
    required this.questions,
    required this.currentIndex,
    this.selectedChoiceIndex,
    this.isCorrect,
    this.isCompleted = false,
  });

  final List<QuizQuestion> questions;
  final int currentIndex;

  /// Null until the user selects an answer.
  final int? selectedChoiceIndex;

  /// Null until answered.
  final bool? isCorrect;

  final bool isCompleted;

  QuizQuestion get currentQuestion => questions[currentIndex];
  int get totalQuestions => questions.length;
  bool get hasAnswered => selectedChoiceIndex != null;

  ListeningSessionState copyWith({
    int? currentIndex,
    int? selectedChoiceIndex,
    bool? isCorrect,
    bool? isCompleted,
    bool clearAnswer = false,
  }) {
    return ListeningSessionState(
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedChoiceIndex:
          clearAnswer ? null : (selectedChoiceIndex ?? this.selectedChoiceIndex),
      isCorrect: clearAnswer ? null : (isCorrect ?? this.isCorrect),
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class ListeningSessionNotifier extends Notifier<ListeningSessionState?> {
  @override
  ListeningSessionState? build() => null;

  /// Loads words + verbs for [lessonId], generates MCQ questions (max [_kMaxQuestions]).
  /// Sets state to null if not enough items.
  Future<void> startSession(int lessonId) async {
    final words =
        await ref.read(contentRepositoryProvider).getWordsByLessonId(lessonId);
    final verbs =
        await ref.read(contentRepositoryProvider).getVerbsByLessonId(lessonId);

    final generator = QuizGenerator(random: Random());
    final all = generator.generateQuestions(words: words, verbs: verbs);

    if (all.isEmpty) {
      state = null;
      return;
    }

    final selected = List<QuizQuestion>.unmodifiable(
        all.take(_kMaxQuestions).toList());

    state = ListeningSessionState(
      questions: selected,
      currentIndex: 0,
    );
  }

  /// Records the user's choice and marks whether it is correct.
  /// Ignored if the current question is already answered.
  void selectAnswer(int choiceIndex) {
    final s = state;
    if (s == null || s.hasAnswered) return;

    final correct =
        s.currentQuestion.choices[choiceIndex] == s.currentQuestion.correctAnswer;

    state = s.copyWith(
      selectedChoiceIndex: choiceIndex,
      isCorrect: correct,
    );
  }

  /// Advances to the next question, or marks the session as completed.
  void nextQuestion() {
    final s = state;
    if (s == null) return;

    final next = s.currentIndex + 1;
    if (next >= s.questions.length) {
      state = s.copyWith(isCompleted: true);
      return;
    }

    state = s.copyWith(
      currentIndex: next,
      clearAnswer: true,
    );
  }

  void endSession() {
    state = null;
  }
}

final listeningSessionProvider =
    NotifierProvider<ListeningSessionNotifier, ListeningSessionState?>(
  () => ListeningSessionNotifier(),
);
