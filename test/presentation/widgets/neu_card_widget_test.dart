import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/presentation/widgets/neu_card_widget.dart';

import '../../helpers/test_app_wrapper.dart';

Widget _buildCard({
  ThemeData? theme,
  VoidCallback? onTap,
  EdgeInsetsGeometry? padding,
  Color? color,
}) {
  return MaterialApp(
    theme: theme ?? ThemeData.dark(),
    home: Scaffold(
      body: NeuCard(
        onTap: onTap,
        padding: padding,
        color: color,
        child: const Text('contenu'),
      ),
    ),
  );
}

void main() {
  group('NeuCard', () {
    testWidgets('affiche son enfant', (tester) async {
      await tester.pumpWidget(testAppWrapper(
        child: const NeuCard(child: Text('Bonjour')),
      ));

      expect(find.text('Bonjour'), findsOneWidget);
    });

    testWidgets('applique le padding quand fourni', (tester) async {
      await tester.pumpWidget(testAppWrapper(
        child: const NeuCard(
          padding: EdgeInsets.all(20),
          child: Text('padded'),
        ),
      ));

      final padding = tester.widget<Padding>(find.byType(Padding).last);
      expect(padding.padding, const EdgeInsets.all(20));
    });

    testWidgets('est tappable quand onTap fourni', (tester) async {
      var tapped = false;
      await tester.pumpWidget(testAppWrapper(
        child: NeuCard(
          onTap: () => tapped = true,
          child: const Text('tap me'),
        ),
      ));

      await tester.tap(find.text('tap me'));
      expect(tapped, isTrue);
    });

    testWidgets('en mode sombre: utilise DecoratedBox avec boxShadow',
        (tester) async {
      await tester.pumpWidget(_buildCard(theme: ThemeData.dark()));
      await tester.pump();

      expect(find.byType(DecoratedBox), findsOneWidget);
      final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
      final decoration = box.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotEmpty);
    });

    testWidgets('en mode clair: utilise Material sans DecoratedBox',
        (tester) async {
      await tester.pumpWidget(_buildCard(theme: ThemeData.light()));
      await tester.pump();

      // Light mode n'a pas de DecoratedBox
      expect(find.byType(DecoratedBox), findsNothing);
    });

    testWidgets('utilise la couleur override quand fournie', (tester) async {
      const customColor = Colors.red;
      await tester.pumpWidget(testAppWrapper(
        child: const NeuCard(
          color: customColor,
          child: SizedBox(),
        ),
      ));

      final material = tester.widgetList<Material>(find.byType(Material))
          .firstWhere((m) => m.color == customColor, orElse: () => throw 'not found');
      expect(material.color, customColor);
    });
  });
}
