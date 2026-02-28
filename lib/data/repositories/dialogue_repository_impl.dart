import '../../domain/models/dialogue_model.dart';
import '../../domain/repositories/dialogue_repository.dart';
import '../database/daos/content_dao.dart';
import '../datasources/json_content_loader.dart';

class DialogueRepositoryImpl implements DialogueRepository {
  DialogueRepositoryImpl(this._contentDao, this._jsonLoader);

  final ContentDao _contentDao;
  final JsonContentLoader _jsonLoader;

  @override
  Future<List<DialogueModel>> getDialoguesByLessonId(int lessonId) async {
    final coords = await _contentDao.getLessonCoordinates(lessonId);
    if (coords == null) return [];

    final jsonList = await _jsonLoader.loadDialogues(coords.levelNumber);
    if (jsonList.isEmpty) return [];

    var id = 0;
    return jsonList
        .where((j) =>
            j['unit'] == coords.unitNumber &&
            j['lesson'] == coords.lessonNumber)
        .map((j) => DialogueModel.fromJson({
              ...j,
              'lesson_id': lessonId,
              'id': ++id,
            }))
        .toList();
  }
}
