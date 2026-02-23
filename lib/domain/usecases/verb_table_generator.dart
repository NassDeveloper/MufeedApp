import 'dart:math';

import '../models/verb_model.dart';
import '../models/verb_table_row.dart';

class VerbTableGenerator {
  VerbTableGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  /// Generates verb table rows with some cells hidden.
  ///
  /// [hiddenPerRow] controls difficulty: 1 = easy, 2 = medium, 3 = hard.
  /// For each hidden cell, 3 distractors are picked from the same form of
  /// other verbs.
  List<VerbTableRow> generate(List<VerbModel> verbs, {int hiddenPerRow = 1}) {
    if (verbs.length < 2) return [];

    final clampedHidden = hiddenPerRow.clamp(1, 3);
    const forms = VerbForm.values;

    return verbs.map((verb) {
      // Pick which forms to hide for this row
      final shuffledForms = List<VerbForm>.from(forms)..shuffle(_random);
      final hiddenForms = shuffledForms.take(clampedHidden).toSet();

      return VerbTableRow(
        verbId: verb.id,
        translationFr: verb.translationFr,
        masdar: _buildCell(verb, VerbForm.masdar, hiddenForms, verbs),
        past: _buildCell(verb, VerbForm.past, hiddenForms, verbs),
        present: _buildCell(verb, VerbForm.present, hiddenForms, verbs),
        imperative: _buildCell(verb, VerbForm.imperative, hiddenForms, verbs),
      );
    }).toList();
  }

  VerbCellState _buildCell(
    VerbModel verb,
    VerbForm form,
    Set<VerbForm> hiddenForms,
    List<VerbModel> allVerbs,
  ) {
    final value = _getFormValue(verb, form);
    final isHidden = hiddenForms.contains(form);

    if (!isHidden) {
      return VerbCellState(value: value, isHidden: false);
    }

    final distractors = _getDistractors(verb, form, allVerbs);
    final choices = [value, ...distractors]..shuffle(_random);

    return VerbCellState(
      value: value,
      isHidden: true,
      choices: choices,
    );
  }

  List<String> _getDistractors(
    VerbModel verb,
    VerbForm form,
    List<VerbModel> allVerbs,
  ) {
    final otherVerbs = allVerbs.where((v) => v.id != verb.id).toList()
      ..shuffle(_random);

    final correctValue = _getFormValue(verb, form);
    final distractors = <String>[];

    for (final other in otherVerbs) {
      if (distractors.length >= 3) break;
      final value = _getFormValue(other, form);
      if (value != correctValue && !distractors.contains(value)) {
        distractors.add(value);
      }
    }

    // If not enough unique distractors, pull from other forms
    if (distractors.length < 3) {
      final otherForms = VerbForm.values.where((f) => f != form);
      for (final f in otherForms) {
        for (final v in otherVerbs) {
          if (distractors.length >= 3) break;
          final value = _getFormValue(v, f);
          if (value != correctValue && !distractors.contains(value)) {
            distractors.add(value);
          }
        }
      }
    }

    return distractors.take(3).toList();
  }

  static String _getFormValue(VerbModel verb, VerbForm form) {
    switch (form) {
      case VerbForm.masdar:
        return verb.masdar;
      case VerbForm.past:
        return verb.past;
      case VerbForm.present:
        return verb.present;
      case VerbForm.imperative:
        return verb.imperative;
    }
  }
}
