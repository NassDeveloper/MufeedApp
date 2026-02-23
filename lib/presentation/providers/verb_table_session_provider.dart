import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/verb_table_row.dart';
import '../../domain/usecases/verb_table_generator.dart';
import 'content_provider.dart';

@immutable
class VerbTableSessionState {
  const VerbTableSessionState({
    required this.rows,
    required this.lessonId,
    required this.totalHidden,
    this.correctCount = 0,
    this.revealedCount = 0,
    this.isCompleted = false,
  });

  final List<VerbTableRow> rows;
  final int lessonId;
  final int totalHidden;
  final int correctCount;
  final int revealedCount;
  final bool isCompleted;

  int get remainingCount => totalHidden - revealedCount;

  VerbTableSessionState copyWith({
    List<VerbTableRow>? rows,
    int? lessonId,
    int? totalHidden,
    int? correctCount,
    int? revealedCount,
    bool? isCompleted,
  }) {
    return VerbTableSessionState(
      rows: rows ?? this.rows,
      lessonId: lessonId ?? this.lessonId,
      totalHidden: totalHidden ?? this.totalHidden,
      correctCount: correctCount ?? this.correctCount,
      revealedCount: revealedCount ?? this.revealedCount,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class VerbTableSessionNotifier extends Notifier<VerbTableSessionState?> {
  @override
  VerbTableSessionState? build() => null;

  Future<void> startSession(int lessonId) async {
    final repo = ref.read(contentRepositoryProvider);
    final verbs = await repo.getVerbsByLessonId(lessonId);

    if (verbs.length < 2) {
      state = null;
      return;
    }

    final generator = VerbTableGenerator();
    // Progressive difficulty: 1 hidden per row for <= 4 verbs, 2 for more
    final hiddenPerRow = verbs.length <= 4 ? 1 : 2;
    final rows = generator.generate(verbs, hiddenPerRow: hiddenPerRow);

    final totalHidden =
        rows.fold<int>(0, (sum, row) => sum + row.hiddenCount);

    state = VerbTableSessionState(
      rows: List.unmodifiable(rows),
      lessonId: lessonId,
      totalHidden: totalHidden,
    );
  }

  void submitAnswer(int rowIndex, VerbForm form, String answer) {
    if (state == null || state!.isCompleted) return;

    final row = state!.rows[rowIndex];
    final cell = row.cellForForm(form);
    if (!cell.isPending) return;

    final isCorrect = answer == cell.value;
    final updatedCell = cell.reveal(isCorrect);
    final updatedRow = row.withCell(form, updatedCell);

    final updatedRows = List<VerbTableRow>.from(state!.rows);
    updatedRows[rowIndex] = updatedRow;

    final newCorrect =
        state!.correctCount + (isCorrect ? 1 : 0);
    final newRevealed = state!.revealedCount + 1;
    final isCompleted = newRevealed >= state!.totalHidden;

    state = state!.copyWith(
      rows: List.unmodifiable(updatedRows),
      correctCount: newCorrect,
      revealedCount: newRevealed,
      isCompleted: isCompleted,
    );
  }

  void endSession() {
    state = null;
  }
}

final verbTableSessionProvider =
    NotifierProvider<VerbTableSessionNotifier, VerbTableSessionState?>(() {
  return VerbTableSessionNotifier();
});
