import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/presentation/widgets/rating_distribution_widget.dart';

import '../../helpers/test_app_wrapper.dart';

void main() {
  group('RatingDistribution', () {
    testWidgets('affiche les 4 labels de notation', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: const RatingDistribution(
            ratingCounts: {1: 2, 2: 3, 3: 5, 4: 1},
            totalItems: 11,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('À revoir'), findsOneWidget);
      expect(find.text('Difficile'), findsOneWidget);
      expect(find.text('Bien'), findsOneWidget);
      expect(find.text('Facile'), findsOneWidget);
    });

    testWidgets('affiche les comptes corrects', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: const RatingDistribution(
            ratingCounts: {1: 2, 2: 3, 3: 5, 4: 1},
            totalItems: 11,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('fonctionne avec totalItems = 0 (pas de division par zéro)',
        (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: const RatingDistribution(
            ratingCounts: {},
            totalItems: 0,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('À revoir'), findsOneWidget);
      expect(find.text('0'), findsNWidgets(4));
    });

    testWidgets('a des Semantics widgets sur chaque barre', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: const RatingDistribution(
            ratingCounts: {1: 4, 2: 0, 3: 6, 4: 2},
            totalItems: 12,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Chaque barre a un Semantics wrapping — 4 barres minimum
      final semanticsNodes = tester.widgetList<Semantics>(
        find.byType(Semantics),
      );
      // Vérifie qu'au moins 4 Semantics avec label non-null existent
      final labeled =
          semanticsNodes.where((s) => s.properties.label != null).toList();
      expect(labeled.length, greaterThanOrEqualTo(4));
    });

    testWidgets('démarre l\'animation au mount', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: const RatingDistribution(
            ratingCounts: {1: 1, 2: 1, 3: 1, 4: 1},
            totalItems: 4,
          ),
        ),
      );

      // Animation en cours → pas d'erreur
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
    });
  });
}
