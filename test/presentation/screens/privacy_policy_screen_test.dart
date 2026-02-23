import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/screens/privacy_policy_screen.dart';

Widget _buildApp() {
  return const MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: Locale('fr'),
    home: PrivacyPolicyScreen(),
  );
}

void main() {
  group('PrivacyPolicyScreen', () {
    testWidgets('shows app bar title', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Politique de confidentialité'), findsOneWidget);
    });

    testWidgets('shows all 5 section titles', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Données collectées'), findsOneWidget);
      expect(find.text('Analytics anonymes'), findsOneWidget);
      expect(find.text('Stockage local'), findsOneWidget);

      // Scroll down to reveal sections that may be below the fold
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      expect(find.text('Vos droits'), findsOneWidget);
      expect(find.text('Contact'), findsOneWidget);
    });

    testWidgets('shows last updated text', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Scroll to the bottom to ensure the last updated text is visible
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      expect(
        find.text('Dernière mise à jour : février 2026'),
        findsOneWidget,
      );
    });
  });
}
