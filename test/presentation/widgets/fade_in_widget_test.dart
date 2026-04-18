import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/presentation/widgets/fade_in_widget.dart';

import '../../helpers/test_app_wrapper.dart';

void main() {
  group('FadeIn', () {
    testWidgets('affiche son enfant', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: const FadeIn(child: Text('Hello')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('démarre avec opacité 0 et monte à 1', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: const FadeIn(
            duration: Duration(milliseconds: 300),
            child: Text('fade'),
          ),
        ),
      );

      // Juste après le mount: opacité proche de 0
      await tester.pump();
      final fadeTransition = tester
          .widgetList<FadeTransition>(find.byType(FadeTransition))
          .firstWhere((ft) => ft.opacity.value < 0.5,
              orElse: () => tester
                  .widgetList<FadeTransition>(find.byType(FadeTransition))
                  .first);
      expect(fadeTransition.opacity.value, lessThan(1.0));

      // Après l'animation: opacité = 1
      await tester.pumpAndSettle();
      expect(fadeTransition.opacity.value, 1.0);
    });

    testWidgets('respecte la durée personnalisée et atteint opacity 1',
        (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: const FadeIn(
            duration: Duration(milliseconds: 500),
            child: SizedBox(),
          ),
        ),
      );

      // Avant la fin de l'animation, l'enfant est dans le tree
      await tester.pump(const Duration(milliseconds: 1));
      expect(find.byType(FadeTransition), findsAtLeastNWidgets(1));

      // Après 500ms complets, l'animation est terminée
      await tester.pumpAndSettle();
      final fadeTransition = tester
          .widgetList<FadeTransition>(find.byType(FadeTransition))
          .firstWhere((ft) => ft.opacity.value == 1.0);
      expect(fadeTransition.opacity.value, 1.0);
    });

    testWidgets('utilise Curves.easeOut par défaut', (tester) async {
      const widget = FadeIn(child: Text('test'));
      expect(widget.curve, Curves.easeOut);
    });

    testWidgets('durée par défaut est 300ms', (tester) async {
      const widget = FadeIn(child: Text('test'));
      expect(widget.duration, const Duration(milliseconds: 300));
    });

    testWidgets('accepte une curve personnalisée', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: const FadeIn(
            curve: Curves.bounceIn,
            child: Text('bounce'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('bounce'), findsOneWidget);
    });

    testWidgets('se dispose sans erreur', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: const FadeIn(child: Text('dispose test')),
        ),
      );
      await tester.pump();

      // Remplacer par un widget vide pour déclencher dispose
      await tester.pumpWidget(testAppWrapper(child: const SizedBox()));
      // Pas d'exception → dispose correct
    });
  });
}
