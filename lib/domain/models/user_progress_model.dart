class UserProgressModel {
  const UserProgressModel({
    this.id,
    required this.itemId,
    required this.contentType,
    this.stability = 0,
    this.difficulty = 0,
    this.state = 'new',
    this.lastReview,
    this.nextReview,
    this.reviewCount = 0,
    this.elapsedDays = 0,
    this.scheduledDays = 0,
    this.reps = 0,
  }) : assert(contentType == 'vocab' || contentType == 'verb',
            'contentType must be "vocab" or "verb"');

  final int? id;
  final int itemId;
  final String contentType;
  final double stability;
  final double difficulty;
  final String state;
  final DateTime? lastReview;
  final DateTime? nextReview;
  final int reviewCount;
  final int elapsedDays;
  final int scheduledDays;
  final int reps;

  UserProgressModel copyWith({
    int? id,
    int? itemId,
    String? contentType,
    double? stability,
    double? difficulty,
    String? state,
    DateTime? lastReview,
    DateTime? nextReview,
    int? reviewCount,
    int? elapsedDays,
    int? scheduledDays,
    int? reps,
  }) {
    return UserProgressModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      contentType: contentType ?? this.contentType,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      state: state ?? this.state,
      lastReview: lastReview ?? this.lastReview,
      nextReview: nextReview ?? this.nextReview,
      reviewCount: reviewCount ?? this.reviewCount,
      elapsedDays: elapsedDays ?? this.elapsedDays,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      reps: reps ?? this.reps,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgressModel &&
          id == other.id &&
          itemId == other.itemId &&
          contentType == other.contentType &&
          stability == other.stability &&
          difficulty == other.difficulty &&
          state == other.state &&
          lastReview == other.lastReview &&
          nextReview == other.nextReview &&
          reviewCount == other.reviewCount &&
          elapsedDays == other.elapsedDays &&
          scheduledDays == other.scheduledDays &&
          reps == other.reps;

  @override
  int get hashCode => Object.hash(
        id,
        itemId,
        contentType,
        stability,
        difficulty,
        state,
        lastReview,
        nextReview,
        reviewCount,
        elapsedDays,
        scheduledDays,
        reps,
      );
}
