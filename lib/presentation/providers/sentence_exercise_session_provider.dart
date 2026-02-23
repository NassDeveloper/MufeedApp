import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/sentence_exercise_model.dart';
import 'content_provider.dart';

@immutable
class SentenceExerciseState {
  const SentenceExerciseState({
    required this.exercises,
    required this.currentIndex,
    required this.lessonId,
    this.selectedIndex,
    this.isCorrect,
    this.score = 0,
    this.isCompleted = false,
  });

  final List<SentenceExerciseModel> exercises;
  final int currentIndex;
  final int lessonId;
  final int? selectedIndex;
  final bool? isCorrect;
  final int score;
  final bool isCompleted;

  int get totalExercises => exercises.length;
  SentenceExerciseModel get currentExercise => exercises[currentIndex];
  bool get hasAnswered => selectedIndex != null;

  String get currentExplanation =>
      hasAnswered ? currentExercise.explanations[selectedIndex!] : '';

  SentenceExerciseState copyWith({
    List<SentenceExerciseModel>? exercises,
    int? currentIndex,
    int? lessonId,
    int? selectedIndex,
    bool? isCorrect,
    int? score,
    bool? isCompleted,
    bool clearAnswer = false,
  }) {
    return SentenceExerciseState(
      exercises: exercises ?? this.exercises,
      currentIndex: currentIndex ?? this.currentIndex,
      lessonId: lessonId ?? this.lessonId,
      selectedIndex:
          clearAnswer ? null : (selectedIndex ?? this.selectedIndex),
      isCorrect: clearAnswer ? null : (isCorrect ?? this.isCorrect),
      score: score ?? this.score,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class SentenceExerciseNotifier extends Notifier<SentenceExerciseState?> {
  @override
  SentenceExerciseState? build() => null;

  Future<void> startSession(int lessonId) async {
    final repo = ref.read(contentRepositoryProvider);
    final exercises = await repo.getExercisesForLesson(lessonId);

    if (exercises.isEmpty) {
      state = null;
      return;
    }

    state = SentenceExerciseState(
      exercises: List.unmodifiable(exercises),
      currentIndex: 0,
      lessonId: lessonId,
    );
  }

  void submitAnswer(int choiceIndex) {
    if (state == null || state!.hasAnswered || state!.isCompleted) return;

    final isCorrect = choiceIndex == state!.currentExercise.correctIndex;

    state = state!.copyWith(
      selectedIndex: choiceIndex,
      isCorrect: isCorrect,
      score: isCorrect ? state!.score + 1 : state!.score,
    );
  }

  void nextExercise() {
    if (state == null || !state!.hasAnswered) return;

    final nextIndex = state!.currentIndex + 1;
    if (nextIndex >= state!.totalExercises) {
      state = state!.copyWith(isCompleted: true);
      return;
    }

    state = state!.copyWith(
      currentIndex: nextIndex,
      clearAnswer: true,
    );
  }

  void endSession() {
    state = null;
  }
}

final sentenceExerciseProvider =
    NotifierProvider<SentenceExerciseNotifier, SentenceExerciseState?>(() {
  return SentenceExerciseNotifier();
});
