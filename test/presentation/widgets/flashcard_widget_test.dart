import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/reviewable_item_model.dart';
import 'package:mufeed_app/presentation/widgets/flashcard_widget.dart';

import '../../helpers/test_app_wrapper.dart';

void main() {
  group('FlashcardWidget', () {
    const vocabItem = ReviewableItemModel(
      itemId: 1,
      contentType: 'vocab',
      arabic: 'كتاب',
      translationFr: 'livre',
      sortOrder: 1,
    );

    const verbItem = ReviewableItemModel(
      itemId: 2,
      contentType: 'verb',
      arabic: 'كِتَابَة',
      translationFr: 'ecrire',
      sortOrder: 2,
      verbPast: 'كَتَبَ',
      verbPresent: 'يَكْتُبُ',
      verbImperative: 'اُكْتُبْ',
    );

    testWidgets('shows Arabic text on front for vocab', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: FlashcardWidget(
            item: vocabItem,
            isFlipped: false,
            onFlip: () {},
          ),
        ),
      );

      expect(find.text('كتاب'), findsOneWidget);
    });

    testWidgets('shows translation on back for vocab', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: FlashcardWidget(
            item: vocabItem,
            isFlipped: true,
            onFlip: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('livre'), findsOneWidget);
    });

    testWidgets('shows masdar on front for verb', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: FlashcardWidget(
            item: verbItem,
            isFlipped: false,
            onFlip: () {},
          ),
        ),
      );

      expect(find.text('كِتَابَة'), findsOneWidget);
    });

    testWidgets('shows verb forms on back for verb', (tester) async {
      await tester.pumpWidget(
        testAppWrapper(
          child: FlashcardWidget(
            item: verbItem,
            isFlipped: true,
            onFlip: () {},
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('ecrire'), findsOneWidget);
      expect(find.text('كَتَبَ'), findsOneWidget);
      expect(find.text('يَكْتُبُ'), findsOneWidget);
      expect(find.text('اُكْتُبْ'), findsOneWidget);
    });

    testWidgets('calls onFlip when tapped', (tester) async {
      var flipped = false;
      await tester.pumpWidget(
        testAppWrapper(
          child: FlashcardWidget(
            item: vocabItem,
            isFlipped: false,
            onFlip: () => flipped = true,
          ),
        ),
      );

      // Tap on the Arabic text area (not the TTS button)
      await tester.tap(find.text('كتاب'));
      expect(flipped, true);
    });
  });
}
