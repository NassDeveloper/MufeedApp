import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/analytics_service.dart';
import 'preferences_provider.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  throw UnimplementedError(
    'analyticsServiceProvider must be overridden in main.dart',
  );
});

/// GDPR consent state.
///
/// `null` = not yet asked, `true` = accepted, `false` = refused.
class GdprConsentNotifier extends Notifier<bool?> {
  @override
  bool? build() {
    final prefs = ref.read(sharedPreferencesSourceProvider);
    final consent = prefs.getGdprConsent();

    // Sync analytics service with persisted consent (fire-and-forget).
    if (consent != null) {
      unawaited(ref.read(analyticsServiceProvider).setEnabled(consent));
    }

    return consent;
  }

  Future<void> setConsent(bool consent) async {
    final prefs = ref.read(sharedPreferencesSourceProvider);
    await prefs.setGdprConsent(consent);
    state = consent;
    await ref.read(analyticsServiceProvider).setEnabled(consent);
  }
}

final gdprConsentProvider = NotifierProvider<GdprConsentNotifier, bool?>(
  GdprConsentNotifier.new,
);
