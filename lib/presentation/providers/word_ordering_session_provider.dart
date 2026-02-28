import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/sentence_exercise_model.dart';
import '../providers/content_provider.dart';

const int _kMaxSentences = 5;
const int _kMinTokens = 3;

// Sentinel object for nullable copyWith fields
const _sentinel = Object();

@immutable
class WordToken {
  const WordToken({required this.id, required this.text});

  final int id;
  final String text;
}

@immutable
class WordOrderingSentence {
  const WordOrderingSentence({
    required this.frenchPrompt,
    required this.fullArabic,
    required this.correctTokens,
  });

  /// Clean French translation shown as prompt to the user.
  final String frenchPrompt;

  /// Reconstructed full Arabic sentence (sentenceAr with ___ replaced).
  final String fullArabic;

  /// Correct token order (split on spaces from fullArabic).
  final List<String> correctTokens;
}

@immutable
class WordOrderingSessionState {
  const WordOrderingSessionState({
    required this.sentences,
    required this.currentIndex,
    required this.tokens,
    required this.placedIds,
    this.isAnswerCorrect,
    this.isCompleted = false,
  });

  final List<WordOrderingSentence> sentences;
  final int currentIndex;

  /// All tokens for the current sentence (shuffled for display).
  final List<WordToken> tokens;

  /// Token IDs placed by the user in the order they tapped them.
  final List<int> placedIds;

  /// null = not yet submitted, true = correct, false = wrong.
  final bool? isAnswerCorrect;

  final bool isCompleted;

  WordOrderingSentence get currentSentence => sentences[currentIndex];
  int get totalSentences => sentences.length;

  List<WordToken> get availableTokens =>
      tokens.where((t) => !placedIds.contains(t.id)).toList();

  List<WordToken> get placedTokens =>
      placedIds.map((id) => tokens.firstWhere((t) => t.id == id)).toList();

  WordOrderingSessionState copyWith({
    int? currentIndex,
    List<WordToken>? tokens,
    List<int>? placedIds,
    Object? isAnswerCorrect = _sentinel,
    bool? isCompleted,
  }) {
    return WordOrderingSessionState(
      sentences: sentences,
      currentIndex: currentIndex ?? this.currentIndex,
      tokens: tokens ?? this.tokens,
      placedIds: placedIds ?? this.placedIds,
      isAnswerCorrect: isAnswerCorrect == _sentinel
          ? this.isAnswerCorrect
          : isAnswerCorrect as bool?,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class WordOrderingSessionNotifier
    extends Notifier<WordOrderingSessionState?> {
  @override
  WordOrderingSessionState? build() => null;

  /// Loads exercises for [lessonId], keeps only those whose reconstructed
  /// Arabic sentence has ≥ [_kMinTokens] tokens, shuffles, caps at
  /// [_kMaxSentences], and sets the initial state.
  /// Sets state to null if no eligible sentences exist.
  Future<void> startSession(int lessonId) async {
    final exercises =
        await ref.read(contentRepositoryProvider).getExercisesForLesson(lessonId);

    final eligible = <WordOrderingSentence>[];
    for (final ex in exercises) {
      final fullAr = ex.sentenceAr.replaceFirst('___', ex.correctAnswer);
      final tokens = fullAr.split(' ');
      if (tokens.length >= _kMinTokens) {
        eligible.add(WordOrderingSentence(
          frenchPrompt: _extractFrenchPrompt(ex),
          fullArabic: fullAr,
          correctTokens: List.unmodifiable(tokens),
        ));
      }
    }

    if (eligible.isEmpty) {
      state = null;
      return;
    }

    final rng = Random();
    eligible.shuffle(rng);
    final selected = List<WordOrderingSentence>.unmodifiable(
        eligible.take(_kMaxSentences).toList());

    state = WordOrderingSessionState(
      sentences: selected,
      currentIndex: 0,
      tokens: _buildTokens(selected[0].correctTokens, rng),
      placedIds: const [],
    );
  }

  /// Called when the user taps an available token with [tokenId].
  void tapToken(int tokenId) {
    final s = state;
    if (s == null) return;
    if (s.isAnswerCorrect == true) return; // locked after correct answer
    if (s.placedIds.contains(tokenId)) return;

    final newPlaced = List<int>.unmodifiable([...s.placedIds, tokenId]);
    final allPlaced = newPlaced.length == s.tokens.length;

    if (allPlaced) {
      final placedTexts = newPlaced
          .map((id) => s.tokens.firstWhere((t) => t.id == id).text)
          .toList();
      final correct = _listsEqual(placedTexts, s.currentSentence.correctTokens);
      state = s.copyWith(
        placedIds: newPlaced,
        isAnswerCorrect: correct,
      );
    } else {
      state = s.copyWith(
        placedIds: newPlaced,
        isAnswerCorrect: null,
      );
    }
  }

  /// Called when the user taps a placed token with [tokenId] to remove it.
  void removeToken(int tokenId) {
    final s = state;
    if (s == null) return;
    if (s.isAnswerCorrect == true) return; // can't edit after correct answer

    final newPlaced = List<int>.unmodifiable(
      [...s.placedIds]..remove(tokenId),
    );
    state = s.copyWith(
      placedIds: newPlaced,
      isAnswerCorrect: null,
    );
  }

  /// Advances to the next sentence, or marks the session as completed.
  void nextSentence() {
    final s = state;
    if (s == null) return;

    final nextIndex = s.currentIndex + 1;
    if (nextIndex >= s.sentences.length) {
      state = s.copyWith(isCompleted: true);
      return;
    }

    final rng = Random();
    state = s.copyWith(
      currentIndex: nextIndex,
      tokens: _buildTokens(s.sentences[nextIndex].correctTokens, rng),
      placedIds: const [],
      isAnswerCorrect: null,
    );
  }

  void endSession() {
    state = null;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  List<WordToken> _buildTokens(List<String> correctTokens, Random rng) {
    final shuffled = List<String>.from(correctTokens)..shuffle(rng);
    return List.unmodifiable([
      for (var i = 0; i < shuffled.length; i++)
        WordToken(id: i, text: shuffled[i]),
    ]);
  }

  bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Extracts a clean French prompt from [ex.sentenceFr].
  ///
  /// Handles two patterns:
  /// - Arabic sentence with `___` + French in `(...)`:
  ///   e.g. `"___ هَذَا ؟ (Qu'est-ce que c'est ?)"` → `"Qu'est-ce que c'est ?"`
  /// - French sentence with `___` + hint word in `(...)`:
  ///   e.g. `"Le livre est ___ la table. (sur)"` → `"Le livre est sur la table."`
  static String _extractFrenchPrompt(SentenceExerciseModel ex) {
    final fr = ex.sentenceFr;
    if (!fr.contains('___')) return fr;

    final parenMatch = RegExp(r'\(([^)]+)\)\s*$').firstMatch(fr);
    if (parenMatch == null) return fr;

    final hint = parenMatch.group(1)!;
    final beforeParens = fr.substring(0, parenMatch.start).trim();

    // If the part before the parentheses contains Arabic characters,
    // the hint IS the full French translation (possibly with a grammatical note
    // separated by " - ").
    final hasArabic = beforeParens.contains(RegExp(r'[\u0600-\u06FF\u060C\u061B\u061F]'));
    if (hasArabic) {
      return hint.split(' - ').first.trim();
    }

    // Otherwise the French sentence has a blank; fill it with the hint word.
    return beforeParens.replaceFirst('___', hint);
  }
}

final wordOrderingSessionProvider =
    NotifierProvider<WordOrderingSessionNotifier, WordOrderingSessionState?>(
  () => WordOrderingSessionNotifier(),
);
