import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/progress_calculator.dart';
import 'preferences_provider.dart';
import 'srs_provider.dart';

@immutable
class LearningModeState {
  const LearningModeState({
    required this.mode,
    required this.activeLevelId,
    this.activeLessonId,
    this.suggestedLessonId,
  });

  /// 'curriculum' or 'autodidact'
  final String mode;
  final int activeLevelId;
  final int? activeLessonId;

  /// Only set in autodidact mode: the first non-mastered lesson.
  /// Null means all lessons in the level are mastered.
  final int? suggestedLessonId;

  bool get isCurriculum => mode == 'curriculum';
  bool get isAutodidact => mode == 'autodidact';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LearningModeState &&
          mode == other.mode &&
          activeLevelId == other.activeLevelId &&
          activeLessonId == other.activeLessonId &&
          suggestedLessonId == other.suggestedLessonId;

  @override
  int get hashCode =>
      Object.hash(mode, activeLevelId, activeLessonId, suggestedLessonId);
}

final progressCalculatorProvider = Provider<ProgressCalculator>((ref) {
  return ProgressCalculator();
});

class LearningModeNotifier extends AsyncNotifier<LearningModeState> {
  @override
  Future<LearningModeState> build() async {
    final prefs = ref.read(sharedPreferencesSourceProvider);
    final mode = prefs.getLearningMode() ?? 'curriculum';
    final activeLevelId = prefs.getActiveLevelId() ?? 1;
    final activeLessonId = prefs.getActiveLessonId();

    int? suggestedLessonId;
    if (mode == 'autodidact') {
      suggestedLessonId = await _calculateSuggestedLesson(activeLevelId);
    }

    return LearningModeState(
      mode: mode,
      activeLevelId: activeLevelId,
      activeLessonId: activeLessonId,
      suggestedLessonId: suggestedLessonId,
    );
  }

  Future<void> setMode(String mode) async {
    final prefs = ref.read(sharedPreferencesSourceProvider);
    await prefs.setLearningMode(mode);
    ref.invalidateSelf();
  }

  Future<void> setActiveLevelId(int levelId) async {
    final prefs = ref.read(sharedPreferencesSourceProvider);
    await prefs.setActiveLevelId(levelId);
    ref.invalidateSelf();
  }

  Future<void> setActiveLessonId(int lessonId) async {
    final prefs = ref.read(sharedPreferencesSourceProvider);
    await prefs.setActiveLessonId(lessonId);
    final current = state.value;
    if (current != null) {
      state = AsyncData(LearningModeState(
        mode: current.mode,
        activeLevelId: current.activeLevelId,
        activeLessonId: lessonId,
        suggestedLessonId: current.suggestedLessonId,
      ));
    }
  }

  Future<void> refreshSuggestion() async {
    ref.invalidateSelf();
  }

  Future<int?> _calculateSuggestedLesson(int levelId) async {
    final progressRepo = ref.read(progressRepositoryProvider);
    final calculator = ref.read(progressCalculatorProvider);

    final summaries =
        await progressRepo.getLessonProgressSummaryForLevel(levelId);
    final lessonsWithProgress = summaries
        .map(
          (s) => LessonWithProgress(
            lessonId: s.lessonId,
            totalItems: s.totalItems,
            masteredCount: s.masteredCount,
          ),
        )
        .toList();

    return calculator.findNextLessonToStudy(lessonsWithProgress);
  }
}

final learningModeProvider =
    AsyncNotifierProvider<LearningModeNotifier, LearningModeState>(() {
  return LearningModeNotifier();
});
