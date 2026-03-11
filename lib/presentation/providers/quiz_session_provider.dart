import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/session_model.dart';
import '../../domain/models/verb_model.dart';
import '../../domain/models/word_model.dart';
import '../../domain/usecases/quiz_generator.dart';
import 'badge_provider.dart';
import 'content_provider.dart';
import 'srs_provider.dart';
import 'streak_provider.dart';

@immutable
class QuizResultEntry {
  const QuizResultEntry({
    required this.arabic,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.itemId,
    required this.contentType,
  });

  final String arabic;
  final String correctAnswer;
  final String selectedAnswer;
  final bool isCorrect;
  final int itemId;
  final String contentType;

  Map<String, dynamic> toJson() => {
        'arabic': arabic,
        'correctAnswer': correctAnswer,
        'selectedAnswer': selectedAnswer,
        'isCorrect': isCorrect,
        'itemId': itemId,
        'contentType': contentType,
      };
}

@immutable
class QuizSessionState {
  const QuizSessionState({
    required this.questions,
    required this.currentIndex,
    required this.lessonId,
    required this.startedAt,
    this.selectedAnswer,
    this.isCorrect,
    this.score = 0,
    this.isCompleted = false,
    this.results = const [],
  });

  final List<QuizQuestion> questions;
  final int currentIndex;
  final int lessonId;
  final DateTime startedAt;
  final String? selectedAnswer;
  final bool? isCorrect;
  final int score;
  final bool isCompleted;
  final List<QuizResultEntry> results;

  int get totalQuestions => questions.length;

  QuizQuestion get currentQuestion => questions[currentIndex];

  bool get hasAnswered => selectedAnswer != null;

  List<QuizResultEntry> get incorrectResults =>
      results.where((r) => !r.isCorrect).toList();

  QuizSessionState copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? lessonId,
    DateTime? startedAt,
    String? selectedAnswer,
    bool? isCorrect,
    int? score,
    bool? isCompleted,
    List<QuizResultEntry>? results,
    bool clearAnswer = false,
  }) {
    return QuizSessionState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      lessonId: lessonId ?? this.lessonId,
      startedAt: startedAt ?? this.startedAt,
      selectedAnswer:
          clearAnswer ? null : (selectedAnswer ?? this.selectedAnswer),
      isCorrect: clearAnswer ? null : (isCorrect ?? this.isCorrect),
      score: score ?? this.score,
      isCompleted: isCompleted ?? this.isCompleted,
      results: results ?? this.results,
    );
  }
}

class QuizSessionNotifier extends Notifier<QuizSessionState?> {
  @override
  QuizSessionState? build() => null;

  /// Loads words/verbs and generates quiz questions.
  ///
  /// Throws if the content cannot be loaded (caller must handle).
  Future<void> startSession(int lessonId) async {
    final repo = ref.read(contentRepositoryProvider);
    final results = await Future.wait([
      repo.getWordsByLessonId(lessonId),
      repo.getVerbsByLessonId(lessonId),
    ]);
    final words = results[0] as List<WordModel>;
    final verbs = results[1] as List<VerbModel>;

    final generator = QuizGenerator();
    final questions =
        generator.generateQuestions(words: words, verbs: verbs);

    if (questions.isEmpty) {
      state = null;
      return;
    }

    state = QuizSessionState(
      questions: List.unmodifiable(questions),
      currentIndex: 0,
      lessonId: lessonId,
      startedAt: DateTime.now(),
    );
  }

  void submitAnswer(String answer) {
    if (state == null || state!.hasAnswered || state!.isCompleted) return;

    final question = state!.currentQuestion;
    final isCorrect = answer == question.correctAnswer;

    final entry = QuizResultEntry(
      arabic: question.arabic,
      correctAnswer: question.correctAnswer,
      selectedAnswer: answer,
      isCorrect: isCorrect,
      itemId: question.itemId,
      contentType: question.contentType,
    );

    state = state!.copyWith(
      selectedAnswer: answer,
      isCorrect: isCorrect,
      score: isCorrect ? state!.score + 1 : state!.score,
      results: List.unmodifiable([...state!.results, entry]),
    );
  }

  void nextQuestion() {
    if (state == null || !state!.hasAnswered) return;

    final nextIndex = state!.currentIndex + 1;
    if (nextIndex >= state!.totalQuestions) {
      state = state!.copyWith(isCompleted: true);
      return;
    }

    state = state!.copyWith(
      currentIndex: nextIndex,
      clearAnswer: true,
    );
  }

  /// Saves the completed session to DB.
  /// Call this when isCompleted is true, before navigating to summary.
  Future<void> completeSession() async {
    if (state == null || !state!.isCompleted) return;

    final resultsJson = jsonEncode(
      state!.results.map((r) => r.toJson()).toList(),
    );

    final session = SessionModel(
      sessionType: 'quiz',
      startedAt: state!.startedAt,
      completedAt: DateTime.now(),
      itemsReviewed: state!.totalQuestions,
      resultsJson: resultsJson,
    );

    try {
      await ref.read(progressRepositoryProvider).createSession(session);
    } catch (e) {
      debugPrint('Session record creation failed: $e');
    }

    // Update streak + check badges — non-fatal if it fails.
    try {
      final result = await processStreakOnSessionComplete(ref);
      if (result.newBadges.isNotEmpty) {
        ref.read(newBadgesProvider.notifier).set(result.newBadges);
      }
    } catch (e) {
      debugPrint('Streak update failed: $e');
    }
  }

  void endSession() {
    state = null;
  }
}

final quizSessionProvider =
    NotifierProvider<QuizSessionNotifier, QuizSessionState?>(() {
  return QuizSessionNotifier();
});
