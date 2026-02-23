import 'package:flutter/foundation.dart';

@immutable
class WordModel {
  const WordModel({
    required this.id,
    required this.lessonId,
    required this.contentType,
    required this.arabic,
    required this.translationFr,
    required this.sortOrder,
    this.translationEn,
    this.grammaticalCategory,
    this.singular,
    this.plural,
    this.synonym,
    this.antonym,
    this.exampleSentence,
    this.audioPath,
  });

  final int id;
  final int lessonId;
  final String contentType;
  final String arabic;
  final String translationFr;
  final String? translationEn;
  final String? grammaticalCategory;
  final String? singular;
  final String? plural;
  final String? synonym;
  final String? antonym;
  final String? exampleSentence;
  final String? audioPath;
  final int sortOrder;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordModel &&
          id == other.id &&
          lessonId == other.lessonId &&
          contentType == other.contentType &&
          arabic == other.arabic &&
          translationFr == other.translationFr &&
          translationEn == other.translationEn &&
          grammaticalCategory == other.grammaticalCategory &&
          singular == other.singular &&
          plural == other.plural &&
          synonym == other.synonym &&
          antonym == other.antonym &&
          exampleSentence == other.exampleSentence &&
          audioPath == other.audioPath &&
          sortOrder == other.sortOrder;

  @override
  int get hashCode => Object.hash(
        id,
        lessonId,
        contentType,
        arabic,
        translationFr,
        translationEn,
        grammaticalCategory,
        singular,
        plural,
        synonym,
        antonym,
        exampleSentence,
        audioPath,
        sortOrder,
      );

  WordModel copyWith({
    int? id,
    int? lessonId,
    String? contentType,
    String? arabic,
    String? translationFr,
    String? translationEn,
    String? grammaticalCategory,
    String? singular,
    String? plural,
    String? synonym,
    String? antonym,
    String? exampleSentence,
    String? audioPath,
    int? sortOrder,
  }) {
    return WordModel(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      contentType: contentType ?? this.contentType,
      arabic: arabic ?? this.arabic,
      translationFr: translationFr ?? this.translationFr,
      translationEn: translationEn ?? this.translationEn,
      grammaticalCategory: grammaticalCategory ?? this.grammaticalCategory,
      singular: singular ?? this.singular,
      plural: plural ?? this.plural,
      synonym: synonym ?? this.synonym,
      antonym: antonym ?? this.antonym,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      audioPath: audioPath ?? this.audioPath,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
