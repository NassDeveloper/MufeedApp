import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/lesson_model.dart';
import '../../domain/models/level_model.dart';
import '../../domain/models/unit_model.dart';
import '../../domain/models/verb_model.dart';
import '../../domain/models/word_model.dart';
import '../../domain/repositories/content_repository.dart';

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  throw UnimplementedError(
    'contentRepositoryProvider must be overridden in ProviderScope',
  );
});

final levelsProvider = FutureProvider<List<LevelModel>>((ref) {
  return ref.watch(contentRepositoryProvider).getAllLevels();
});

final unitsByLevelProvider =
    FutureProvider.family<List<UnitModel>, int>((ref, levelId) {
  return ref.watch(contentRepositoryProvider).getUnitsByLevelId(levelId);
});

final lessonsByUnitProvider =
    FutureProvider.family<List<LessonModel>, int>((ref, unitId) {
  return ref.watch(contentRepositoryProvider).getLessonsByUnitId(unitId);
});

final wordsByLessonProvider =
    FutureProvider.family<List<WordModel>, int>((ref, lessonId) {
  return ref.watch(contentRepositoryProvider).getWordsByLessonId(lessonId);
});

final verbsByLessonProvider =
    FutureProvider.family<List<VerbModel>, int>((ref, lessonId) {
  return ref.watch(contentRepositoryProvider).getVerbsByLessonId(lessonId);
});

final lessonsByLevelProvider =
    FutureProvider.family<List<LessonModel>, int>((ref, levelId) {
  return ref.watch(contentRepositoryProvider).getLessonsByLevelId(levelId);
});
