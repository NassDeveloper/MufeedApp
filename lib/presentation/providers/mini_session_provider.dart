import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/word_model.dart';
import 'content_provider.dart';
import 'onboarding_provider.dart';

final miniSessionWordsProvider =
    FutureProvider.autoDispose<List<WordModel>>((ref) async {
  final levelId = ref.watch(onboardingProvider).selectedLevelId;
  if (levelId == null) return [];
  final repo = ref.read(contentRepositoryProvider);
  final units = await repo.getUnitsByLevelId(levelId);
  if (units.isEmpty) return [];
  final lessons = await repo.getLessonsByUnitId(units.first.id);
  if (lessons.isEmpty) return [];
  final words = await repo.getWordsByLessonId(lessons.first.id);
  return words.take(3).toList();
});
