import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/tts_provider.dart';
import 'package:mufeed_app/presentation/widgets/tts_button_widget.dart';

class _FakeTtsNotifier extends TtsNotifier {
  final TtsState _state = const TtsState();

  @override
  TtsState build() => _state;

  @override
  Future<void> speak(String text) async {
    state = TtsState(status: TtsStatus.playing, currentText: text);
  }

  @override
  Future<void> stop() async {
    state = const TtsState();
  }

  void setError() {
    state = const TtsState(status: TtsStatus.error);
  }
}

Widget _buildApp({required _FakeTtsNotifier notifier}) {
  return ProviderScope(
    overrides: [
      ttsProvider.overrideWith(() => notifier),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('fr'),
      home: Scaffold(
        body: TtsButton(text: 'مرحبا'),
      ),
    ),
  );
}

void main() {
  group('TtsButton', () {
    late _FakeTtsNotifier notifier;

    setUp(() {
      notifier = _FakeTtsNotifier();
    });

    testWidgets('displays volume_up icon when idle', (tester) async {
      await tester.pumpWidget(_buildApp(notifier: notifier));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });

    testWidgets('displays stop icon when playing this text', (tester) async {
      await tester.pumpWidget(_buildApp(notifier: notifier));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.stop), findsOneWidget);
    });

    testWidgets('displays volume_off icon when error', (tester) async {
      await tester.pumpWidget(_buildApp(notifier: notifier));
      await tester.pumpAndSettle();

      notifier.setError();
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.volume_off), findsOneWidget);
    });

    testWidgets('button is disabled when error', (tester) async {
      await tester.pumpWidget(_buildApp(notifier: notifier));
      await tester.pumpAndSettle();

      notifier.setError();
      await tester.pumpAndSettle();

      final button = tester.widget<IconButton>(find.byType(IconButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('tapping calls speak', (tester) async {
      await tester.pumpWidget(_buildApp(notifier: notifier));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.stop), findsOneWidget);
    });

    testWidgets('tapping while playing calls stop', (tester) async {
      await tester.pumpWidget(_buildApp(notifier: notifier));
      await tester.pumpAndSettle();

      // First tap: speak
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Second tap: stop
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });

    testWidgets('has tooltip', (tester) async {
      await tester.pumpWidget(_buildApp(notifier: notifier));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (w) => w is IconButton && w.tooltip == 'Écouter la prononciation',
        ),
        findsOneWidget,
      );
    });

    testWidgets('has Semantics label', (tester) async {
      await tester.pumpWidget(_buildApp(notifier: notifier));
      await tester.pumpAndSettle();

      expect(
        find.bySemanticsLabel(RegExp('Écouter la prononciation de مرحبا')),
        findsOneWidget,
      );
    });
  });
}
