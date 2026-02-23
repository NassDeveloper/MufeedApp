import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/verb_model.dart';
import 'package:mufeed_app/domain/models/verb_table_row.dart';
import 'package:mufeed_app/domain/usecases/verb_table_generator.dart';

VerbModel _verb(int id, String masdar, String past, String present,
    String imperative, String translation) {
  return VerbModel(
    id: id,
    lessonId: 1,
    contentType: 'verb',
    masdar: masdar,
    past: past,
    present: present,
    imperative: imperative,
    translationFr: translation,
    sortOrder: id,
  );
}

void main() {
  final verbs = [
    _verb(1, 'كِتَابَةٌ', 'كَتَبَ', 'يَكْتُبُ', 'اُكْتُبْ', 'Écrire'),
    _verb(2, 'قِرَاءَةٌ', 'قَرَأَ', 'يَقْرَأُ', 'اِقْرَأْ', 'Lire'),
    _verb(3, 'ذَهَابٌ', 'ذَهَبَ', 'يَذْهَبُ', 'اِذْهَبْ', 'Aller'),
    _verb(4, 'أَكْلٌ', 'أَكَلَ', 'يَأْكُلُ', 'كُلْ', 'Manger'),
  ];

  group('VerbTableGenerator', () {
    test('returns empty for fewer than 2 verbs', () {
      final generator = VerbTableGenerator();
      expect(generator.generate([verbs.first]), isEmpty);
    });

    test('generates correct number of rows', () {
      final generator = VerbTableGenerator(random: Random(42));
      final rows = generator.generate(verbs);
      expect(rows, hasLength(4));
    });

    test('hides exactly 1 cell per row with hiddenPerRow=1', () {
      final generator = VerbTableGenerator(random: Random(42));
      final rows = generator.generate(verbs, hiddenPerRow: 1);

      for (final row in rows) {
        expect(row.hiddenCount, 1);
        expect(row.pendingCount, 1);
      }
    });

    test('hides exactly 2 cells per row with hiddenPerRow=2', () {
      final generator = VerbTableGenerator(random: Random(42));
      final rows = generator.generate(verbs, hiddenPerRow: 2);

      for (final row in rows) {
        expect(row.hiddenCount, 2);
      }
    });

    test('hidden cells have 4 choices including correct answer', () {
      final generator = VerbTableGenerator(random: Random(42));
      final rows = generator.generate(verbs, hiddenPerRow: 1);

      for (final row in rows) {
        for (final cell in row.allCells) {
          if (cell.isHidden) {
            expect(cell.choices, isNotNull);
            expect(cell.choices!.length, 4);
            expect(cell.choices!, contains(cell.value));
          } else {
            expect(cell.choices, isNull);
          }
        }
      }
    });

    test('clamps hiddenPerRow to max 3', () {
      final generator = VerbTableGenerator(random: Random(42));
      final rows = generator.generate(verbs, hiddenPerRow: 10);

      for (final row in rows) {
        expect(row.hiddenCount, 3);
      }
    });

    test('VerbCellState reveal works correctly', () {
      const cell = VerbCellState(
        value: 'كَتَبَ',
        isHidden: true,
        choices: ['كَتَبَ', 'قَرَأَ', 'ذَهَبَ', 'أَكَلَ'],
      );

      expect(cell.isPending, true);

      final revealed = cell.reveal(true);
      expect(revealed.isRevealed, true);
      expect(revealed.isCorrect, true);
      expect(revealed.isPending, false);
    });

    test('VerbTableRow withCell replaces correct form', () {
      final generator = VerbTableGenerator(random: Random(42));
      final rows = generator.generate(verbs, hiddenPerRow: 1);
      final row = rows.first;

      // Find a hidden cell
      VerbForm? hiddenForm;
      for (final form in VerbForm.values) {
        if (row.cellForForm(form).isHidden) {
          hiddenForm = form;
          break;
        }
      }

      expect(hiddenForm, isNotNull);

      final cell = row.cellForForm(hiddenForm!);
      final revealed = cell.reveal(true);
      final updatedRow = row.withCell(hiddenForm, revealed);

      expect(updatedRow.cellForForm(hiddenForm).isRevealed, true);
      expect(updatedRow.pendingCount, 0);
    });
  });
}
