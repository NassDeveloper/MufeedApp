import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/badge_type.dart';
import 'package:mufeed_app/presentation/widgets/badge_celebration_overlay.dart';

import '../../helpers/test_app_wrapper.dart';

void main() {
  group('BadgeCelebrationOverlay', () {
    testWidgets('affiche le titre et le nom du badge', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: BadgeCelebrationOverlay(
            badgeType: BadgeType.firstWordReviewed,
            onDismiss: () {},
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Badge débloqué !'), findsOneWidget);
    });

    testWidgets('affiche le bouton Continuer', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: BadgeCelebrationOverlay(
            badgeType: BadgeType.words10,
            onDismiss: () {},
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Continuer'), findsOneWidget);
    });

    testWidgets('appelle onDismiss au tap sur Continuer', (tester) async {
      var dismissed = false;
      await tester.pumpWidget(
        testAppWrapper(
          child: BadgeCelebrationOverlay(
            badgeType: BadgeType.words10,
            onDismiss: () => dismissed = true,
          ),
        ),
      );
      // Attendre que l'animation de fade soit suffisamment avancée
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.text('Continuer'), warnIfMissed: false);
      expect(dismissed, isTrue);
    });

    testWidgets('appelle onDismiss au tap sur le GestureDetector', (tester) async {
      var dismissed = false;
      await tester.pumpWidget(
        testAppWrapper(
          child: BadgeCelebrationOverlay(
            badgeType: BadgeType.streak7,
            onDismiss: () => dismissed = true,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.byType(GestureDetector).first, warnIfMissed: false);
      expect(dismissed, isTrue);
    });

    testWidgets('affiche l\'icône du badge', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: BadgeCelebrationOverlay(
            badgeType: BadgeType.perfectQuiz,
            onDismiss: () {},
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Icon), findsAtLeastNWidgets(1));
    });

    testWidgets('a un Semantics liveRegion', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: BadgeCelebrationOverlay(
            badgeType: BadgeType.firstWordReviewed,
            onDismiss: () {},
          ),
        ),
      );
      await tester.pump();

      final semanticsNodes = tester.widgetList<Semantics>(
        find.byType(Semantics),
      );
      final hasLiveRegion =
          semanticsNodes.any((s) => s.properties.liveRegion == true);
      expect(hasLiveRegion, isTrue);
    });

    testWidgets('animation se lance sans erreur', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: BadgeCelebrationOverlay(
            badgeType: BadgeType.words50,
            onDismiss: () {},
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
    });
  });

  group('showBadgeCelebrations', () {
    testWidgets('ne fait rien si la liste est vide', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showBadgeCelebrations(context, []),
                child: const Text('Show'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(find.byType(BadgeCelebrationOverlay), findsNothing);
    });
  });
}
