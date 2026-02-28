import '../models/dialogue_model.dart';

abstract class DialogueRepository {
  Future<List<DialogueModel>> getDialoguesByLessonId(int lessonId);
}
