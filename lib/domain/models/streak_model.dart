class StreakModel {
  const StreakModel({
    required this.id,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActivityDate,
    required this.freezeAvailable,
    this.freezeUsedDate,
  });

  final int id;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastActivityDate;
  final bool freezeAvailable;
  final DateTime? freezeUsedDate;

  /// Sentinel used by [copyWith] to explicitly set a nullable field to null.
  static const _sentinel = Object();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakModel &&
          id == other.id &&
          currentStreak == other.currentStreak &&
          longestStreak == other.longestStreak &&
          lastActivityDate == other.lastActivityDate &&
          freezeAvailable == other.freezeAvailable &&
          freezeUsedDate == other.freezeUsedDate;

  @override
  int get hashCode => Object.hash(
        id,
        currentStreak,
        longestStreak,
        lastActivityDate,
        freezeAvailable,
        freezeUsedDate,
      );

  /// Creates a copy with the given fields replaced.
  ///
  /// Pass [clearFreezeUsedDate] as `true` to explicitly set
  /// [freezeUsedDate] to `null`.
  StreakModel copyWith({
    int? id,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityDate,
    bool? freezeAvailable,
    Object? freezeUsedDate = _sentinel,
  }) {
    return StreakModel(
      id: id ?? this.id,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      freezeAvailable: freezeAvailable ?? this.freezeAvailable,
      freezeUsedDate: freezeUsedDate == _sentinel
          ? this.freezeUsedDate
          : freezeUsedDate as DateTime?,
    );
  }

  @override
  String toString() =>
      'StreakModel(id: $id, currentStreak: $currentStreak, '
      'longestStreak: $longestStreak, lastActivityDate: $lastActivityDate, '
      'freezeAvailable: $freezeAvailable, freezeUsedDate: $freezeUsedDate)';
}
