import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/presentation/widgets/error_content_widget.dart';

import '../../helpers/test_app_wrapper.dart';

void main() {
  group('ErrorContent', () {
    testWidgets('affiche le message et le bouton retry', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: ErrorContent(
            message: 'Une erreur est survenue',
            onRetry: () {},
            retryLabel: 'Réessayer',
          ),
        ),
      );

      expect(find.text('Une erreur est survenue'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);
    });

    testWidgets('affiche l\'icône d\'erreur', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: ErrorContent(
            message: 'Erreur',
            onRetry: () {},
            retryLabel: 'Retry',
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('appelle onRetry lors du tap', (tester) async {
      var called = false;
      await tester.pumpWidget(
        testAppWrapper(
          child: ErrorContent(
            message: 'Erreur',
            onRetry: () => called = true,
            retryLabel: 'Réessayer',
          ),
        ),
      );

      await tester.tap(find.text('Réessayer'));
      expect(called, isTrue);
    });

    testWidgets('a un Semantics liveRegion avec le message', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: ErrorContent(
            message: 'Erreur réseau',
            onRetry: () {},
            retryLabel: 'Retry',
          ),
        ),
      );

      final semantics = tester.widget<Semantics>(
        find.ancestor(
          of: find.byType(Column),
          matching: find.byType(Semantics),
        ).first,
      );
      expect(semantics.properties.liveRegion, isTrue);
      expect(semantics.properties.label, 'Erreur réseau');
    });
  });
}
