import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/presentation/widgets/mode_card_widget.dart';

import '../../helpers/test_app_wrapper.dart';

void main() {
  group('ModeCard', () {
    Widget buildCard({bool isSelected = false, VoidCallback? onTap}) {
      return testAppWrapper(
        child: ModeCard(
          title: 'Flashcards',
          description: 'Révisez avec des cartes',
          icon: Icons.style,
          isSelected: isSelected,
          onTap: onTap ?? () {},
        ),
      );
    }

    testWidgets('affiche le titre et la description', (tester) async {
      await tester.pumpWidget(buildCard());

      expect(find.text('Flashcards'), findsOneWidget);
      expect(find.text('Révisez avec des cartes'), findsOneWidget);
    });

    testWidgets('affiche l\'icône', (tester) async {
      await tester.pumpWidget(buildCard());

      expect(find.byIcon(Icons.style), findsOneWidget);
    });

    testWidgets('affiche l\'icône check_circle quand sélectionné',
        (tester) async {
      await tester.pumpWidget(buildCard(isSelected: true));

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('n\'affiche pas check_circle quand non sélectionné',
        (tester) async {
      await tester.pumpWidget(buildCard(isSelected: false));

      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('appelle onTap au tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildCard(onTap: () => tapped = true));

      await tester.tap(find.byType(ModeCard));
      expect(tapped, isTrue);
    });

    testWidgets('a un Semantics button avec selected', (tester) async {
      await tester.pumpWidget(buildCard(isSelected: true));

      final semantics = tester.widget<Semantics>(
        find.descendant(
          of: find.byType(ModeCard),
          matching: find.byType(Semantics),
        ).first,
      );
      expect(semantics.properties.button, isTrue);
      expect(semantics.properties.selected, isTrue);
    });

    testWidgets('Semantics label contient titre et description', (tester) async {
      await tester.pumpWidget(buildCard());

      final semantics = tester.widget<Semantics>(
        find.descendant(
          of: find.byType(ModeCard),
          matching: find.byType(Semantics),
        ).first,
      );
      expect(semantics.properties.label, 'Flashcards, Révisez avec des cartes');
    });
  });
}
