import 'package:mufeed_app/presentation/providers/tts_provider.dart';

class FakeTtsNotifier extends TtsNotifier {
  @override
  TtsState build() => const TtsState();

  @override
  Future<void> speak(String text) async {
    state = TtsState(status: TtsStatus.playing, currentText: text);
  }

  @override
  Future<void> stop() async {
    state = const TtsState();
  }
}
