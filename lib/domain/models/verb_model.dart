import 'package:flutter/foundation.dart';

@immutable
class VerbModel {
  const VerbModel({
    required this.id,
    required this.lessonId,
    required this.contentType,
    required this.masdar,
    required this.past,
    required this.present,
    required this.imperative,
    required this.translationFr,
    required this.sortOrder,
    this.translationEn,
    this.exampleSentence,
    this.audioPathMasdar,
    this.audioPathPast,
    this.audioPathPresent,
    this.audioPathImperative,
  });

  final int id;
  final int lessonId;
  final String contentType;
  final String masdar;
  final String past;
  final String present;
  final String imperative;
  final String translationFr;
  final String? translationEn;
  final String? exampleSentence;
  final String? audioPathMasdar;
  final String? audioPathPast;
  final String? audioPathPresent;
  final String? audioPathImperative;
  final int sortOrder;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerbModel &&
          id == other.id &&
          lessonId == other.lessonId &&
          contentType == other.contentType &&
          masdar == other.masdar &&
          past == other.past &&
          present == other.present &&
          imperative == other.imperative &&
          translationFr == other.translationFr &&
          translationEn == other.translationEn &&
          exampleSentence == other.exampleSentence &&
          audioPathMasdar == other.audioPathMasdar &&
          audioPathPast == other.audioPathPast &&
          audioPathPresent == other.audioPathPresent &&
          audioPathImperative == other.audioPathImperative &&
          sortOrder == other.sortOrder;

  @override
  int get hashCode => Object.hash(
        id,
        lessonId,
        contentType,
        masdar,
        past,
        present,
        imperative,
        translationFr,
        translationEn,
        exampleSentence,
        audioPathMasdar,
        audioPathPast,
        audioPathPresent,
        audioPathImperative,
        sortOrder,
      );

  VerbModel copyWith({
    int? id,
    int? lessonId,
    String? contentType,
    String? masdar,
    String? past,
    String? present,
    String? imperative,
    String? translationFr,
    String? translationEn,
    String? exampleSentence,
    String? audioPathMasdar,
    String? audioPathPast,
    String? audioPathPresent,
    String? audioPathImperative,
    int? sortOrder,
  }) {
    return VerbModel(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      contentType: contentType ?? this.contentType,
      masdar: masdar ?? this.masdar,
      past: past ?? this.past,
      present: present ?? this.present,
      imperative: imperative ?? this.imperative,
      translationFr: translationFr ?? this.translationFr,
      translationEn: translationEn ?? this.translationEn,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      audioPathMasdar: audioPathMasdar ?? this.audioPathMasdar,
      audioPathPast: audioPathPast ?? this.audioPathPast,
      audioPathPresent: audioPathPresent ?? this.audioPathPresent,
      audioPathImperative: audioPathImperative ?? this.audioPathImperative,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
