import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/core/errors/app_error.dart';

void main() {
  group('AppError', () {
    test('DatabaseError is an AppError', () {
      const error = DatabaseError('DB failed');
      expect(error, isA<AppError>());
      expect(error.message, 'DB failed');
      expect(error.debugInfo, isNull);
    });

    test('ContentError stores debugInfo', () {
      const error = ContentError(
        'Invalid JSON',
        debugInfo: 'file: words.json',
      );
      expect(error, isA<AppError>());
      expect(error.message, 'Invalid JSON');
      expect(error.debugInfo, 'file: words.json');
    });

    test('TtsError is an AppError', () {
      const error = TtsError('TTS unavailable');
      expect(error, isA<AppError>());
    });

    test('AnalyticsError is an AppError', () {
      const error = AnalyticsError('Analytics failed');
      expect(error, isA<AppError>());
    });

    test('sealed class exhaustive switch', () {
      const AppError error = DatabaseError('test');
      final result = switch (error) {
        DatabaseError() => 'database',
        ContentError() => 'content',
        TtsError() => 'tts',
        AnalyticsError() => 'analytics',
      };
      expect(result, 'database');
    });

    test('toString includes type and message', () {
      const error = DatabaseError('connection lost');
      expect(error.toString(), contains('DatabaseError'));
      expect(error.toString(), contains('connection lost'));
    });
  });
}
