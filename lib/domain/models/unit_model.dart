import 'package:flutter/foundation.dart';

@immutable
class UnitModel {
  const UnitModel({
    required this.id,
    required this.levelId,
    required this.number,
    required this.nameFr,
    required this.nameEn,
  });

  final int id;
  final int levelId;
  final int number;
  final String nameFr;
  final String nameEn;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitModel &&
          id == other.id &&
          levelId == other.levelId &&
          number == other.number &&
          nameFr == other.nameFr &&
          nameEn == other.nameEn;

  @override
  int get hashCode => Object.hash(id, levelId, number, nameFr, nameEn);

  UnitModel copyWith({
    int? id,
    int? levelId,
    int? number,
    String? nameFr,
    String? nameEn,
  }) {
    return UnitModel(
      id: id ?? this.id,
      levelId: levelId ?? this.levelId,
      number: number ?? this.number,
      nameFr: nameFr ?? this.nameFr,
      nameEn: nameEn ?? this.nameEn,
    );
  }
}
