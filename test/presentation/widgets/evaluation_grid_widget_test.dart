import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/core/constants/app_colors.dart';
import 'package:mufeed_app/presentation/widgets/evaluation_grid_widget.dart';

import '../../helpers/test_app_wrapper.dart';

void main() {
  group('EvaluationGrid', () {
    testWidgets('displays 4 rating buttons with correct labels',
        (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: EvaluationGrid(onRating: (_) {}),
        ),
      );

      expect(find.text('À revoir'), findsOneWidget);
      expect(find.text('Difficile'), findsOneWidget);
      expect(find.text('Bien'), findsOneWidget);
      expect(find.text('Facile'), findsOneWidget);
    });

    testWidgets('displays correct colors for each rating', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: EvaluationGrid(onRating: (_) {}),
        ),
      );

      final materials = tester.widgetList<Material>(find.byType(Material));
      final colors = materials
          .where((m) => m.color != null && m.color != Colors.transparent)
          .map((m) => m.color)
          .toList();

      expect(colors, contains(AppColors.ratingAgain));
      expect(colors, contains(AppColors.ratingHard));
      expect(colors, contains(AppColors.ratingGood));
      expect(colors, contains(AppColors.ratingEasy));
    });

    testWidgets('calls onRating with correct rating value', (tester) async {
      int? receivedRating;
      await tester.pumpWidget(
        testAppWrapper(
          child: EvaluationGrid(onRating: (r) => receivedRating = r),
        ),
      );

      await tester.tap(find.text('À revoir'));
      expect(receivedRating, 1);

      await tester.tap(find.text('Difficile'));
      expect(receivedRating, 2);

      await tester.tap(find.text('Bien'));
      expect(receivedRating, 3);

      await tester.tap(find.text('Facile'));
      expect(receivedRating, 4);
    });

    testWidgets('has Semantics labels on each button', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: EvaluationGrid(onRating: (_) {}),
        ),
      );

      expect(
        find.bySemanticsLabel(RegExp(r'À revoir \(1\)')),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp(r'Difficile \(2\)')),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp(r'Bien \(3\)')),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp(r'Facile \(4\)')),
        findsOneWidget,
      );
    });
  });
}
