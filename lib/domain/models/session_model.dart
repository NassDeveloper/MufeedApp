class SessionModel {
  const SessionModel({
    this.id,
    required this.sessionType,
    required this.startedAt,
    this.completedAt,
    this.itemsReviewed = 0,
    this.resultsJson,
  });

  final int? id;
  final String sessionType;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int itemsReviewed;
  final String? resultsJson;

  SessionModel copyWith({
    int? id,
    String? sessionType,
    DateTime? startedAt,
    DateTime? completedAt,
    int? itemsReviewed,
    String? resultsJson,
  }) {
    return SessionModel(
      id: id ?? this.id,
      sessionType: sessionType ?? this.sessionType,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      itemsReviewed: itemsReviewed ?? this.itemsReviewed,
      resultsJson: resultsJson ?? this.resultsJson,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionModel &&
          id == other.id &&
          sessionType == other.sessionType &&
          startedAt == other.startedAt;

  @override
  int get hashCode => Object.hash(id, sessionType, startedAt);
}
