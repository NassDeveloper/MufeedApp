import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/dialogue_model.dart';
import '../../domain/repositories/dialogue_repository.dart';

final dialogueRepositoryProvider = Provider<DialogueRepository>((ref) {
  throw UnimplementedError(
    'dialogueRepositoryProvider must be overridden in ProviderScope',
  );
});

final dialoguesByLessonProvider =
    FutureProvider.family<List<DialogueModel>, int>((ref, lessonId) {
  return ref.watch(dialogueRepositoryProvider).getDialoguesByLessonId(lessonId);
});
