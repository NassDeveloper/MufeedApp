import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/verb_model.dart';
import '../models/word_model.dart';

@immutable
class QuizQuestion {
  QuizQuestion({
    required this.arabic,
    required this.correctAnswer,
    required List<String> choices,
    required this.itemId,
    required this.contentType,
  }) : choices = List.unmodifiable(choices);

  final String arabic;
  final String correctAnswer;
  final List<String> choices;
  final int itemId;
  final String contentType;
}

class QuizGenerator {
  QuizGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const int minItemCount = 4;

  List<QuizQuestion> generateQuestions({
    required List<WordModel> words,
    required List<VerbModel> verbs,
  }) {
    final allItems = <_QuizItem>[];

    for (final word in words) {
      allItems.add(_QuizItem(
        arabic: word.arabic,
        translationFr: word.translationFr,
        itemId: word.id,
        contentType: word.contentType,
      ));
    }

    for (final verb in verbs) {
      allItems.add(_QuizItem(
        arabic: verb.masdar,
        translationFr: verb.translationFr,
        itemId: verb.id,
        contentType: verb.contentType,
      ));
    }

    if (allItems.length < minItemCount) {
      return [];
    }

    final allTranslations =
        allItems.map((item) => item.translationFr).toSet().toList();

    // Need at least 4 unique translations to form valid questions
    if (allTranslations.length < minItemCount) {
      return [];
    }

    final questions = <QuizQuestion>[];

    for (final item in allItems) {
      final distractors = _selectDistractors(
        correctAnswer: item.translationFr,
        allTranslations: allTranslations,
      );

      final choices = [item.translationFr, ...distractors];
      _shuffle(choices);

      questions.add(QuizQuestion(
        arabic: item.arabic,
        correctAnswer: item.translationFr,
        choices: choices,
        itemId: item.itemId,
        contentType: item.contentType,
      ));
    }

    _shuffle(questions);
    return questions;
  }

  List<String> _selectDistractors({
    required String correctAnswer,
    required List<String> allTranslations,
  }) {
    assert(allTranslations.length >= minItemCount,
        'Need at least $minItemCount unique translations for distractors');

    final candidates =
        allTranslations.where((t) => t != correctAnswer).toList();
    _shuffle(candidates);
    return candidates.take(3).toList();
  }

  void _shuffle<T>(List<T> list) {
    for (var i = list.length - 1; i > 0; i--) {
      final j = _random.nextInt(i + 1);
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }
}

class _QuizItem {
  const _QuizItem({
    required this.arabic,
    required this.translationFr,
    required this.itemId,
    required this.contentType,
  });

  final String arabic;
  final String translationFr;
  final int itemId;
  final String contentType;
}
