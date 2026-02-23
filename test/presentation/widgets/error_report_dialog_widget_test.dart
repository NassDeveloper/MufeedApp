import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/widgets/error_report_dialog_widget.dart';

void main() {
  Widget buildApp({
    required Future<void> Function(String category, String? comment) onSend,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () => showErrorReportDialog(
              context: context,
              onSend: onSend,
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );
  }

  group('ErrorReportDialog', () {
    testWidgets('displays 3 category radio buttons', (tester) async {
      await tester.pumpWidget(buildApp(onSend: (_, _) async {}));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Signaler une erreur'), findsOneWidget);
      expect(find.text('Erreur de harakat'), findsOneWidget);
      expect(find.text('Erreur de traduction'), findsOneWidget);
      expect(find.text('Autre problème'), findsOneWidget);
    });

    testWidgets('displays comment field and action buttons', (tester) async {
      await tester.pumpWidget(buildApp(onSend: (_, _) async {}));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Commentaire (optionnel)'), findsOneWidget);
      expect(find.text('Annuler'), findsOneWidget);
      expect(find.text('Envoyer'), findsOneWidget);
    });

    testWidgets('cancel closes dialog without sending', (tester) async {
      var sent = false;
      await tester.pumpWidget(buildApp(onSend: (_, _) async {
        sent = true;
      }));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();

      expect(sent, isFalse);
      expect(find.text('Signaler une erreur'), findsNothing);
    });

    testWidgets('sends report with selected category and comment',
        (tester) async {
      String? sentCategory;
      String? sentComment;
      await tester.pumpWidget(buildApp(onSend: (category, comment) async {
        sentCategory = category;
        sentComment = comment;
      }));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Select "translation_error"
      await tester.tap(find.text('Erreur de traduction'));
      await tester.pumpAndSettle();

      // Type a comment
      await tester.enterText(find.byType(TextField), 'Mauvaise traduction');
      await tester.pumpAndSettle();

      // Send
      await tester.tap(find.text('Envoyer'));
      await tester.pumpAndSettle();

      expect(sentCategory, 'translation_error');
      expect(sentComment, 'Mauvaise traduction');
      // Dialog should be closed and snackbar shown
      expect(find.text('Signaler une erreur'), findsNothing);
      expect(find.text('Merci ! Signalement envoyé'), findsOneWidget);
    });

    testWidgets('sends default category harakat_error when unchanged',
        (tester) async {
      String? sentCategory;
      String? sentComment;
      await tester.pumpWidget(buildApp(onSend: (category, comment) async {
        sentCategory = category;
        sentComment = comment;
      }));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Envoyer'));
      await tester.pumpAndSettle();

      expect(sentCategory, 'harakat_error');
      expect(sentComment, isNull);
    });
  });
}
