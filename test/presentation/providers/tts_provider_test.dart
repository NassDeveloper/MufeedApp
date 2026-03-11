import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mufeed_app/core/constants/animation_constants.dart';
import 'package:mufeed_app/presentation/providers/tts_provider.dart';

class FakeFlutterTts extends Fake implements FlutterTts {
  @override
  VoidCallback? completionHandler;
  @override
  ErrorHandler? errorHandler;
  @override
  VoidCallback? cancelHandler;
  String? lastSpokenText;
  int speakResult = 1;
  String? language;
  double? speechRate;

  @override
  Future<dynamic> setLanguage(String language) async {
    this.language = language;
    return 1;
  }

  @override
  Future<dynamic> setSpeechRate(double rate) async {
    speechRate = rate;
    return 1;
  }

  @override
  void setCompletionHandler(VoidCallback callback) {
    completionHandler = callback;
  }

  @override
  void setErrorHandler(ErrorHandler handler) {
    errorHandler = handler;
  }

  @override
  void setCancelHandler(VoidCallback callback) {
    cancelHandler = callback;
  }

  @override
  Future<dynamic> speak(String text, {bool focus = false}) async {
    lastSpokenText = text;
    return speakResult;
  }

  @override
  Future<dynamic> stop() async => 1;
}

ProviderContainer _createContainer(FakeFlutterTts fakeTts) {
  return ProviderContainer(
    overrides: [
      flutterTtsProvider.overrideWithValue(fakeTts),
    ],
  );
}

void main() {
  group('TtsNotifier', () {
    late ProviderContainer container;
    late FakeFlutterTts fakeTts;

    setUp(() {
      fakeTts = FakeFlutterTts();
      container = _createContainer(fakeTts);
    });

    tearDown(() => container.dispose());

    test('initial state is idle', () {
      final state = container.read(ttsProvider);
      expect(state.status, TtsStatus.idle);
      expect(state.currentText, isNull);
    });

    test('configures language to Arabic on init', () async {
      container.read(ttsProvider);
      await Future.microtask(() {});
      expect(fakeTts.language, 'ar-SA');
    });

    test('configures speech rate to 0.5 on init', () async {
      container.read(ttsProvider);
      await Future.microtask(() {});
      expect(fakeTts.speechRate, 0.5);
    });

    test('speak waits for init before calling FlutterTts', () async {
      final notifier = container.read(ttsProvider.notifier);
      await notifier.speak('مرحبا');

      // Init should have completed before speak
      expect(fakeTts.language, 'ar-SA');
      expect(fakeTts.speechRate, 0.5);
      expect(fakeTts.lastSpokenText, 'مرحبا');
    });

    test('speak sets state to playing with text', () async {
      final notifier = container.read(ttsProvider.notifier);
      await notifier.speak('مرحبا');

      final state = container.read(ttsProvider);
      expect(state.status, TtsStatus.playing);
      expect(state.currentText, 'مرحبا');
    });

    test('speak calls FlutterTts.speak with text', () async {
      final notifier = container.read(ttsProvider.notifier);
      await notifier.speak('كتاب');

      expect(fakeTts.lastSpokenText, 'كتاب');
    });

    test('speak preserves Arabic diacritics for accurate TTS pronunciation',
        () async {
      // Diacritics must be preserved so the TTS engine can correctly
      // resolve long vowels. e.g. الخَمِيس (kasra on mim → "mees")
      // must NOT become الخميس (which the engine reads as "khamiy-as").
      final notifier = container.read(ttsProvider.notifier);
      await notifier.speak('الخَمِيس');

      expect(fakeTts.lastSpokenText, 'الخَمِيس');
    });

    test('speak sets error state when FlutterTts returns non-1', () async {
      fakeTts.speakResult = 0;
      final notifier = container.read(ttsProvider.notifier);
      await notifier.speak('مرحبا');

      final state = container.read(ttsProvider);
      expect(state.status, TtsStatus.error);
    });

    test('speak error auto-recovers after delay', () async {
      fakeTts.speakResult = 0;
      final notifier = container.read(ttsProvider.notifier);
      await notifier.speak('مرحبا');

      expect(container.read(ttsProvider).status, TtsStatus.error);

      // Wait for recovery delay
      await Future.delayed(
        AnimationConstants.ttsErrorRecoveryDelay + const Duration(milliseconds: 100),
      );

      expect(container.read(ttsProvider).status, TtsStatus.idle);
    });

    test('stop resets state to idle', () async {
      final notifier = container.read(ttsProvider.notifier);
      await notifier.speak('مرحبا');
      await notifier.stop();

      final state = container.read(ttsProvider);
      expect(state.status, TtsStatus.idle);
      expect(state.currentText, isNull);
    });

    test('completion handler resets state to idle', () async {
      final notifier = container.read(ttsProvider.notifier);
      await notifier.speak('مرحبا');

      // Simulate TTS completion callback
      fakeTts.completionHandler!();

      final state = container.read(ttsProvider);
      expect(state.status, TtsStatus.idle);
      expect(state.currentText, isNull);
    });

    test('error handler sets state to error', () async {
      container.read(ttsProvider);
      await Future.delayed(Duration.zero);

      // Simulate TTS error callback
      fakeTts.errorHandler!('TTS error');

      final state = container.read(ttsProvider);
      expect(state.status, TtsStatus.error);
    });

    test('error handler auto-recovers after delay', () async {
      container.read(ttsProvider);
      await Future.delayed(Duration.zero);

      fakeTts.errorHandler!('TTS error');
      expect(container.read(ttsProvider).status, TtsStatus.error);

      // Wait for recovery delay
      await Future.delayed(
        AnimationConstants.ttsErrorRecoveryDelay + const Duration(milliseconds: 100),
      );

      expect(container.read(ttsProvider).status, TtsStatus.idle);
    });

    test('cancel handler resets state to idle', () async {
      final notifier = container.read(ttsProvider.notifier);
      await notifier.speak('مرحبا');

      // Simulate TTS cancel callback
      fakeTts.cancelHandler!();

      final state = container.read(ttsProvider);
      expect(state.status, TtsStatus.idle);
    });

    test('speaking new text replaces previous', () async {
      final notifier = container.read(ttsProvider.notifier);
      await notifier.speak('كتاب');
      await notifier.speak('قلم');

      final state = container.read(ttsProvider);
      expect(state.status, TtsStatus.playing);
      expect(state.currentText, 'قلم');
      expect(fakeTts.lastSpokenText, 'قلم');
    });
  });
}
