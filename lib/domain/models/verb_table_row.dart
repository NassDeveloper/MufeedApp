import 'package:flutter/foundation.dart';

enum VerbForm { masdar, past, present, imperative }

@immutable
class VerbCellState {
  const VerbCellState({
    required this.value,
    required this.isHidden,
    this.isRevealed = false,
    this.isCorrect,
    this.choices,
  });

  final String value;
  final bool isHidden;
  final bool isRevealed;
  final bool? isCorrect;
  final List<String>? choices;

  bool get isPending => isHidden && !isRevealed;

  VerbCellState reveal(bool correct) => VerbCellState(
        value: value,
        isHidden: isHidden,
        isRevealed: true,
        isCorrect: correct,
        choices: choices,
      );
}

@immutable
class VerbTableRow {
  const VerbTableRow({
    required this.verbId,
    required this.translationFr,
    required this.masdar,
    required this.past,
    required this.present,
    required this.imperative,
  });

  final int verbId;
  final String translationFr;
  final VerbCellState masdar;
  final VerbCellState past;
  final VerbCellState present;
  final VerbCellState imperative;

  VerbCellState cellForForm(VerbForm form) {
    switch (form) {
      case VerbForm.masdar:
        return masdar;
      case VerbForm.past:
        return past;
      case VerbForm.present:
        return present;
      case VerbForm.imperative:
        return imperative;
    }
  }

  VerbTableRow withCell(VerbForm form, VerbCellState cell) {
    return VerbTableRow(
      verbId: verbId,
      translationFr: translationFr,
      masdar: form == VerbForm.masdar ? cell : masdar,
      past: form == VerbForm.past ? cell : past,
      present: form == VerbForm.present ? cell : present,
      imperative: form == VerbForm.imperative ? cell : imperative,
    );
  }

  List<VerbCellState> get allCells => [masdar, past, present, imperative];

  int get hiddenCount => allCells.where((c) => c.isHidden).length;
  int get revealedCount => allCells.where((c) => c.isRevealed).length;
  int get pendingCount => allCells.where((c) => c.isPending).length;
}
