import 'package:flutter/foundation.dart';

@immutable
class DialogueTurn {
  const DialogueTurn({
    required this.speaker,
    required this.arabic,
    required this.translationFr,
    this.choices,
    this.correctIndex,
  });

  factory DialogueTurn.fromJson(Map<String, dynamic> json) {
    return DialogueTurn(
      speaker: json['speaker'] as String,
      arabic: json['arabic'] as String,
      translationFr: json['translation_fr'] as String,
      choices: json.containsKey('choices')
          ? (json['choices'] as List).cast<String>()
          : null,
      correctIndex: json['correct_index'] as int?,
    );
  }

  /// 'A' or 'B'
  final String speaker;

  /// Arabic text. '___' means the user must fill in this turn.
  final String arabic;

  final String translationFr;

  /// Non-null when [arabic] == '___'.
  final List<String>? choices;

  /// Non-null when [arabic] == '___'.
  final int? correctIndex;

  bool get isBlank => arabic == '___';

  String? get correctChoice => isBlank ? choices![correctIndex!] : null;
}

@immutable
class DialogueModel {
  const DialogueModel({
    required this.id,
    required this.lessonId,
    required this.titleFr,
    required this.turns,
  });

  factory DialogueModel.fromJson(Map<String, dynamic> json) {
    return DialogueModel(
      id: json['id'] as int,
      lessonId: json['lesson_id'] as int,
      titleFr: json['title_fr'] as String,
      turns: (json['turns'] as List)
          .map((t) => DialogueTurn.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }

  final int id;
  final int lessonId;
  final String titleFr;
  final List<DialogueTurn> turns;

  /// Indices of turns that have a blank (___).
  List<int> get blankTurnIndices => [
        for (var i = 0; i < turns.length; i++)
          if (turns[i].isBlank) i,
      ];
}
