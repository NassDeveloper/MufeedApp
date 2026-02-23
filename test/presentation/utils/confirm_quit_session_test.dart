import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/utils/confirm_quit_session.dart';

void main() {
  group('confirmQuitSession', () {
    late bool? capturedResult;

    Widget buildApp() {
      capturedResult = null;
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('fr'),
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                capturedResult = await confirmQuitSession(context);
              },
              child: const Text('trigger'),
            ),
          ),
        ),
      );
    }

    testWidgets('shows dialog with title and message', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Quitter la session ?'), findsOneWidget);
      expect(
        find.text('Ta progression dans cette session sera perdue.'),
        findsOneWidget,
      );
    });

    testWidgets('returns false when "Continuer" is tapped', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continuer'));
      await tester.pumpAndSettle();

      expect(capturedResult, isFalse);
    });

    testWidgets('returns true when "Quitter" is tapped', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Quitter'));
      await tester.pumpAndSettle();

      expect(capturedResult, isTrue);
    });

    testWidgets('returns false when dialog is dismissed', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      // Tap the barrier to dismiss the dialog
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(capturedResult, isFalse);
    });
  });
}
