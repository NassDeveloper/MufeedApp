import 'package:flutter/foundation.dart';

@immutable
class LevelModel {
  const LevelModel({
    required this.id,
    required this.number,
    required this.nameFr,
    required this.nameEn,
    required this.nameAr,
    required this.unitCount,
  });

  final int id;
  final int number;
  final String nameFr;
  final String nameEn;
  final String nameAr;
  final int unitCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelModel &&
          id == other.id &&
          number == other.number &&
          nameFr == other.nameFr &&
          nameEn == other.nameEn &&
          nameAr == other.nameAr &&
          unitCount == other.unitCount;

  @override
  int get hashCode => Object.hash(id, number, nameFr, nameEn, nameAr, unitCount);

  LevelModel copyWith({
    int? id,
    int? number,
    String? nameFr,
    String? nameEn,
    String? nameAr,
    int? unitCount,
  }) {
    return LevelModel(
      id: id ?? this.id,
      number: number ?? this.number,
      nameFr: nameFr ?? this.nameFr,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      unitCount: unitCount ?? this.unitCount,
    );
  }
}
