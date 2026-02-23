import 'user_progress_model.dart';

class ReviewableItemModel {
  const ReviewableItemModel({
    required this.itemId,
    required this.contentType,
    required this.arabic,
    required this.translationFr,
    required this.sortOrder,
    this.verbPast,
    this.verbPresent,
    this.verbImperative,
    this.progress,
  });

  final int itemId;
  final String contentType;
  final String arabic;
  final String translationFr;
  final int sortOrder;
  final String? verbPast;
  final String? verbPresent;
  final String? verbImperative;
  final UserProgressModel? progress;

  bool get isVerb => contentType == 'verb';

  String get effectiveState => progress?.state ?? 'new';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewableItemModel &&
          itemId == other.itemId &&
          contentType == other.contentType &&
          arabic == other.arabic &&
          translationFr == other.translationFr &&
          sortOrder == other.sortOrder &&
          verbPast == other.verbPast &&
          verbPresent == other.verbPresent &&
          verbImperative == other.verbImperative &&
          progress == other.progress;

  @override
  int get hashCode => Object.hash(itemId, contentType, arabic, translationFr,
      sortOrder, verbPast, verbPresent, verbImperative, progress);
}
