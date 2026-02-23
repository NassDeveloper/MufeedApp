import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/presentation/widgets/quiz_option_widget.dart';

import '../../helpers/test_app_wrapper.dart';

Color _findAnimatedContainerColor(WidgetTester tester) {
  final container = tester.widget<AnimatedContainer>(
    find.descendant(
      of: find.byType(QuizOptionWidget),
      matching: find.byType(AnimatedContainer),
    ),
  );
  final decoration = container.decoration! as BoxDecoration;
  return decoration.color!;
}

void main() {
  group('QuizOptionWidget', () {
    testWidgets('displays text', (tester) async {
      await tester.pumpWidget(testAppWrapper(
        child: QuizOptionWidget(
          text: 'livre',
          optionState: QuizOptionState.idle,
          onTap: () {},
          semanticIndex: 1,
        ),
      ));

      expect(find.text('livre'), findsOneWidget);
    });

    testWidgets('calls onTap when in idle state', (tester) async {
      var tapped = false;
      await tester.pumpWidget(testAppWrapper(
        child: QuizOptionWidget(
          text: 'livre',
          optionState: QuizOptionState.idle,
          onTap: () => tapped = true,
          semanticIndex: 1,
        ),
      ));

      await tester.tap(find.text('livre'));
      expect(tapped, true);
    });

    testWidgets('does not call onTap when onTap is null', (tester) async {
      await tester.pumpWidget(testAppWrapper(
        child: const QuizOptionWidget(
          text: 'livre',
          optionState: QuizOptionState.correct,
          onTap: null,
          semanticIndex: 1,
        ),
      ));

      await tester.tap(find.text('livre'));
      // No crash = pass
    });

    testWidgets('shows green background for correct state', (tester) async {
      await tester.pumpWidget(testAppWrapper(
        child: const QuizOptionWidget(
          text: 'livre',
          optionState: QuizOptionState.correct,
          onTap: null,
          semanticIndex: 1,
        ),
      ));
      await tester.pumpAndSettle();

      expect(_findAnimatedContainerColor(tester), const Color(0xFF4CAF50));
    });

    testWidgets('shows red background for incorrect state', (tester) async {
      await tester.pumpWidget(testAppWrapper(
        child: const QuizOptionWidget(
          text: 'stylo',
          optionState: QuizOptionState.incorrect,
          onTap: null,
          semanticIndex: 2,
        ),
      ));
      await tester.pumpAndSettle();

      expect(_findAnimatedContainerColor(tester), const Color(0xFFEF5350));
    });

    testWidgets('shows green background for revealed state', (tester) async {
      await tester.pumpWidget(testAppWrapper(
        child: const QuizOptionWidget(
          text: 'livre',
          optionState: QuizOptionState.revealed,
          onTap: null,
          semanticIndex: 1,
        ),
      ));
      await tester.pumpAndSettle();

      expect(_findAnimatedContainerColor(tester), const Color(0xFF4CAF50));
    });

    testWidgets('uses onSurface text color for idle state', (tester) async {
      await tester.pumpWidget(testAppWrapper(
        child: QuizOptionWidget(
          text: 'livre',
          optionState: QuizOptionState.idle,
          onTap: () {},
          semanticIndex: 1,
        ),
      ));

      final text = tester.widget<Text>(find.text('livre'));
      // idle state should NOT use white text
      expect(text.style?.color, isNot(Colors.white));
    });

    testWidgets('has semantics button label', (tester) async {
      await tester.pumpWidget(testAppWrapper(
        child: QuizOptionWidget(
          text: 'livre',
          optionState: QuizOptionState.idle,
          onTap: () {},
          semanticIndex: 1,
        ),
      ));

      final semantics = tester.getSemantics(find.byType(QuizOptionWidget).first);
      expect(semantics.label, contains('livre'));
    });
  });
}
