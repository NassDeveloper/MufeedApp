import 'badge_type.dart';

class BadgeModel {
  const BadgeModel({
    required this.id,
    required this.badgeType,
    this.unlockedAt,
    this.displayed = false,
  });

  final int id;
  final BadgeType badgeType;
  final DateTime? unlockedAt;
  final bool displayed;

  bool get isUnlocked => unlockedAt != null;

  BadgeModel copyWith({
    int? id,
    BadgeType? badgeType,
    Object? unlockedAt = _sentinel,
    bool? displayed,
  }) {
    return BadgeModel(
      id: id ?? this.id,
      badgeType: badgeType ?? this.badgeType,
      unlockedAt:
          unlockedAt == _sentinel ? this.unlockedAt : unlockedAt as DateTime?,
      displayed: displayed ?? this.displayed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          badgeType == other.badgeType &&
          unlockedAt == other.unlockedAt &&
          displayed == other.displayed;

  @override
  int get hashCode => Object.hash(id, badgeType, unlockedAt, displayed);

  @override
  String toString() =>
      'BadgeModel(id: $id, badgeType: ${badgeType.key}, '
      'unlockedAt: $unlockedAt, displayed: $displayed)';

  static const _sentinel = Object();
}
