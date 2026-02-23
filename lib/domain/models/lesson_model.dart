import 'package:flutter/foundation.dart';

@immutable
class LessonModel {
  const LessonModel({
    required this.id,
    required this.unitId,
    required this.number,
    required this.nameFr,
    required this.nameEn,
    this.descriptionFr,
    this.descriptionEn,
  });

  final int id;
  final int unitId;
  final int number;
  final String nameFr;
  final String nameEn;
  final String? descriptionFr;
  final String? descriptionEn;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonModel &&
          id == other.id &&
          unitId == other.unitId &&
          number == other.number &&
          nameFr == other.nameFr &&
          nameEn == other.nameEn &&
          descriptionFr == other.descriptionFr &&
          descriptionEn == other.descriptionEn;

  @override
  int get hashCode =>
      Object.hash(id, unitId, number, nameFr, nameEn, descriptionFr, descriptionEn);

  LessonModel copyWith({
    int? id,
    int? unitId,
    int? number,
    String? nameFr,
    String? nameEn,
    String? descriptionFr,
    String? descriptionEn,
  }) {
    return LessonModel(
      id: id ?? this.id,
      unitId: unitId ?? this.unitId,
      number: number ?? this.number,
      nameFr: nameFr ?? this.nameFr,
      nameEn: nameEn ?? this.nameEn,
      descriptionFr: descriptionFr ?? this.descriptionFr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
    );
  }
}
