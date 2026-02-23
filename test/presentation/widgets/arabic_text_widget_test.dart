import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/presentation/widgets/arabic_text_widget.dart';

void main() {
  group('ArabicText', () {
    testWidgets('renders with RTL direction', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArabicText('بسم الله'),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.textDirection, TextDirection.rtl);
    });

    testWidgets('uses ScheherazadeNew font', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArabicText('بسم الله'),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.fontFamily, 'ScheherazadeNew');
    });

    testWidgets('has minimum 24sp font size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArabicText('بسم الله'),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style!.fontSize, greaterThanOrEqualTo(24.0));
    });

    testWidgets('has Semantics label for accessibility', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArabicText('بسم الله'),
          ),
        ),
      );

      final semantics = tester.widget<Semantics>(
        find.descendant(
          of: find.byType(ArabicText),
          matching: find.byType(Semantics),
        ),
      );
      expect(semantics.properties.label, 'بسم الله');
      expect(semantics.properties.textDirection, TextDirection.rtl);
    });

    testWidgets('merges custom style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArabicText(
              'بسم الله',
              style: TextStyle(fontSize: 40, color: Colors.red),
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style!.fontSize, 40.0);
      expect(textWidget.style!.color, Colors.red);
      expect(textWidget.style!.fontFamily, 'ScheherazadeNew');
    });
  });
}
