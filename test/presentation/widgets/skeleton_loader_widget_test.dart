import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/widgets/skeleton_loader_widget.dart';

Widget _buildTestApp({required Widget child}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('fr'),
    home: Scaffold(body: child),
  );
}

void main() {
  group('SkeletonLoader', () {
    testWidgets('renders with correct dimensions', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const SkeletonLoader(width: 100, height: 20),
        ),
      );
      await tester.pump();

      final container = tester.widget<Container>(find.byType(Container).last);
      expect(container.constraints?.maxWidth, 100);
      expect(container.constraints?.maxHeight, 20);
    });

    testWidgets('has Semantics label for accessibility', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const SkeletonLoader(),
        ),
      );
      await tester.pump();

      final semantics = tester.widget<Semantics>(
        find.descendant(
          of: find.byType(SkeletonLoader),
          matching: find.byType(Semantics),
        ),
      );
      expect(semantics.properties.label, 'Chargement...');
    });
  });

  group('SkeletonListLoader', () {
    testWidgets('renders correct number of skeleton cards', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const SkeletonListLoader(itemCount: 3),
        ),
      );
      await tester.pump();

      expect(find.byType(Card), findsNWidgets(3));
    });
  });
}
