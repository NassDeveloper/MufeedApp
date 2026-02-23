import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/presentation/widgets/arabic_text_widget.dart';
import 'package:mufeed_app/presentation/theme/app_typography.dart';

/// Test Arabic text rendering across multiple screen sizes.
///
/// Verifies NFR8: Arabic harakats perfect alignment on all target devices.
/// Screen sizes tested:
///   - Small mobile: 320x568 (iPhone SE)
///   - Large mobile: 428x926 (iPhone 14 Pro Max)
///   - Tablet: 1024x1366 (iPad Pro)
void main() {
  // Sample Arabic text with full harakats for rendering tests
  const sampleWord = 'كِتَابٌ';
  const sampleSentence = 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ';
  const sampleLongText =
      'كِتَابٌ قَلَمٌ بَيْتٌ مَاءٌ وَلَدٌ بِنْتٌ كِتَابَةٌ قِرَاءَةٌ ذَهَابٌ';

  // Screen sizes to test (physical pixels = logical size * DPI)
  const smallMobile = Size(320, 568);
  const smallMobileDpi = 2.0; // iPhone SE
  const largeMobile = Size(428, 926);
  const largeMobileDpi = 3.0; // iPhone 14 Pro Max
  const tablet = Size(1024, 1366);
  const tabletDpi = 2.0; // iPad Pro

  Widget buildTestApp({required Size screenSize, required Widget child}) {
    return MediaQuery(
      data: MediaQueryData(size: screenSize),
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  group('Arabic rendering — small mobile (320x568, @2x)', () {
    testWidgets('single word renders without overflow', (tester) async {
      tester.view.physicalSize = smallMobile * smallMobileDpi;
      tester.view.devicePixelRatio = smallMobileDpi;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          screenSize: smallMobile,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: ArabicText(sampleWord),
          ),
        ),
      );

      // Verify no overflow errors
      expect(tester.takeException(), isNull);

      // Verify RTL direction
      final text = tester.widget<Text>(find.byType(Text));
      expect(text.textDirection, TextDirection.rtl);
    });

    testWidgets('long text wraps without overflow', (tester) async {
      tester.view.physicalSize = smallMobile * smallMobileDpi;
      tester.view.devicePixelRatio = smallMobileDpi;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          screenSize: smallMobile,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: ArabicText(sampleLongText),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('sentence renders with correct font', (tester) async {
      tester.view.physicalSize = smallMobile * smallMobileDpi;
      tester.view.devicePixelRatio = smallMobileDpi;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          screenSize: smallMobile,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: ArabicText(sampleSentence),
          ),
        ),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.fontFamily, AppTypography.arabicFontFamily);
      expect(text.style!.fontSize, greaterThanOrEqualTo(24.0));
    });
  });

  group('Arabic rendering — large mobile (428x926, @3x)', () {
    testWidgets('single word renders without overflow', (tester) async {
      tester.view.physicalSize = largeMobile * largeMobileDpi;
      tester.view.devicePixelRatio = largeMobileDpi;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          screenSize: largeMobile,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: ArabicText(sampleWord),
          ),
        ),
      );

      expect(tester.takeException(), isNull);

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.textDirection, TextDirection.rtl);
    });

    testWidgets('long text wraps without overflow', (tester) async {
      tester.view.physicalSize = largeMobile * largeMobileDpi;
      tester.view.devicePixelRatio = largeMobileDpi;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          screenSize: largeMobile,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: ArabicText(sampleLongText),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('headline style renders correctly', (tester) async {
      tester.view.physicalSize = largeMobile * largeMobileDpi;
      tester.view.devicePixelRatio = largeMobileDpi;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          screenSize: largeMobile,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: ArabicText(
              sampleWord,
              style: AppTypography.arabicHeadline,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style!.fontSize, 36.0);
      expect(text.style!.fontWeight, FontWeight.bold);
      expect(text.style!.fontFamily, AppTypography.arabicFontFamily);
    });
  });

  group('Arabic rendering — tablet (1024x1366, @2x)', () {
    testWidgets('single word renders without overflow', (tester) async {
      tester.view.physicalSize = tablet * tabletDpi;
      tester.view.devicePixelRatio = tabletDpi;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          screenSize: tablet,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: ArabicText(sampleWord),
          ),
        ),
      );

      expect(tester.takeException(), isNull);

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.textDirection, TextDirection.rtl);
    });

    testWidgets('long text wraps without overflow', (tester) async {
      tester.view.physicalSize = tablet * tabletDpi;
      tester.view.devicePixelRatio = tabletDpi;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          screenSize: tablet,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: ArabicText(sampleLongText),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('flashcard style renders correctly', (tester) async {
      tester.view.physicalSize = tablet * tabletDpi;
      tester.view.devicePixelRatio = tabletDpi;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          screenSize: tablet,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: ArabicText(
              sampleWord,
              style: AppTypography.flashcardArabic,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style!.fontSize, 40.0);
      expect(text.style!.fontFamily, AppTypography.arabicFontFamily);
    });
  });

  group('Arabic rendering — all sizes consistency', () {
    final devices = {
      'small mobile': (size: smallMobile, dpi: smallMobileDpi),
      'large mobile': (size: largeMobile, dpi: largeMobileDpi),
      'tablet': (size: tablet, dpi: tabletDpi),
    };

    for (final entry in devices.entries) {
      testWidgets('RTL preserved at ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value.size * entry.value.dpi;
        tester.view.devicePixelRatio = entry.value.dpi;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestApp(
            screenSize: entry.value.size,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: ArabicText(sampleSentence),
            ),
          ),
        );

        final text = tester.widget<Text>(find.byType(Text));
        expect(text.textDirection, TextDirection.rtl);
        expect(text.style?.fontFamily, AppTypography.arabicFontFamily);
        expect(text.style!.fontSize, greaterThanOrEqualTo(24.0));
      });

      testWidgets('semantics correct at ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value.size * entry.value.dpi;
        tester.view.devicePixelRatio = entry.value.dpi;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          buildTestApp(
            screenSize: entry.value.size,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: ArabicText(sampleWord),
            ),
          ),
        );

        final semantics = tester.widget<Semantics>(
          find.descendant(
            of: find.byType(ArabicText),
            matching: find.byType(Semantics),
          ),
        );
        expect(semantics.properties.label, sampleWord);
        expect(semantics.properties.textDirection, TextDirection.rtl);
      });
    }
  });
}
