import 'package:flutter/foundation.dart';

@immutable
class SentenceExerciseModel {
  const SentenceExerciseModel({
    required this.lessonId,
    required this.sentenceFr,
    required this.sentenceAr,
    required this.choices,
    required this.correctIndex,
    required this.explanations,
  });

  factory SentenceExerciseModel.fromJson(Map<String, dynamic> json) {
    return SentenceExerciseModel(
      lessonId: json['lesson_id'] as int,
      sentenceFr: json['sentence_fr'] as String,
      sentenceAr: json['sentence_ar'] as String,
      choices: (json['choices'] as List).cast<String>(),
      correctIndex: json['correct_index'] as int,
      explanations: (json['explanations'] as List).cast<String>(),
    );
  }

  final int lessonId;
  final String sentenceFr;
  final String sentenceAr;
  final List<String> choices;
  final int correctIndex;
  final List<String> explanations;

  String get correctAnswer => choices[correctIndex];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SentenceExerciseModel &&
          lessonId == other.lessonId &&
          sentenceFr == other.sentenceFr &&
          sentenceAr == other.sentenceAr &&
          correctIndex == other.correctIndex &&
          listEquals(choices, other.choices) &&
          listEquals(explanations, other.explanations);

  @override
  int get hashCode => Object.hash(
        lessonId,
        sentenceFr,
        sentenceAr,
        correctIndex,
      );
}
