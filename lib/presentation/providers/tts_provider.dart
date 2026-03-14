import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../core/constants/animation_constants.dart';
import '../../core/errors/app_error.dart';

enum TtsStatus { idle, playing, error }

class TtsState {
  const TtsState({this.status = TtsStatus.idle, this.currentText});

  final TtsStatus status;
  final String? currentText;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TtsState &&
          status == other.status &&
          currentText == other.currentText;

  @override
  int get hashCode => Object.hash(status, currentText);
}

final flutterTtsProvider = Provider<FlutterTts>((ref) => FlutterTts());

class TtsNotifier extends Notifier<TtsState> {
  late FlutterTts _tts;
  late Future<void> _initFuture;

  @override
  TtsState build() {
    _tts = ref.read(flutterTtsProvider);
    _initFuture = _initTts();
    ref.onDispose(() {
      _tts.stop();
    });
    return const TtsState();
  }

  Future<void> _initTts() async {
    await _setupArabicLanguage();
    await _tts.setSpeechRate(0.5);

    _tts.setCompletionHandler(() {
      state = const TtsState();
    });

    _tts.setErrorHandler((message) {
      final error = TtsError('TTS playback error', debugInfo: '$message');
      // Log error through AppError hierarchy (analytics integration point)
      assert(() {
        // ignore: avoid_print
        print(error);
        return true;
      }());
      state = const TtsState(status: TtsStatus.error);
      // Auto-recover after delay so user can retry
      _scheduleErrorRecovery();
    });

    _tts.setCancelHandler(() {
      state = const TtsState();
    });
  }

  Future<void> _setupArabicLanguage() async {
    // Try preferred variant first, then fallback to any available Arabic voice.
    for (final lang in ['ar-SA', 'ar-AE', 'ar-EG', 'ar']) {
      final result = await _tts.setLanguage(lang);
      if (result == 1) return;
    }
    // No Arabic voice installed on this device/simulator — mark as error.
    state = const TtsState(status: TtsStatus.error);
  }

  Future<void> speak(String text) async {
    await _initFuture;
    if (state.status == TtsStatus.error) return;
    await _tts.stop();
    state = TtsState(status: TtsStatus.playing, currentText: text);
    final result = await _tts.speak(text);
    if (result != 1) {
      state = const TtsState(status: TtsStatus.error);
      _scheduleErrorRecovery();
    }
  }

  void _scheduleErrorRecovery() {
    Future.delayed(AnimationConstants.ttsErrorRecoveryDelay, () {
      if (ref.mounted && state.status == TtsStatus.error) {
        state = const TtsState();
      }
    });
  }

  Future<void> stop() async {
    await _tts.stop();
    state = const TtsState();
  }
}

final ttsProvider = NotifierProvider<TtsNotifier, TtsState>(() {
  return TtsNotifier();
});
