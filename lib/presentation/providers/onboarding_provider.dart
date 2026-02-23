import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale_provider.dart';
import 'preferences_provider.dart';

@immutable
class OnboardingState {
  const OnboardingState({
    this.currentPage = 0,
    this.learningMode,
    this.selectedLevelId,
    this.gdprConsent,
  });

  final int currentPage;
  final String? learningMode;
  final int? selectedLevelId;
  final bool? gdprConsent;

  static const totalPages = 4;

  bool get canProceed {
    switch (currentPage) {
      case 0:
        return true; // Welcome page — always can proceed
      case 1:
        return learningMode != null;
      case 2:
        return selectedLevelId != null;
      case 3:
        return true; // Consent page — both accept and refuse are valid
      default:
        return false;
    }
  }

  OnboardingState copyWith({
    int? currentPage,
    String? learningMode,
    int? selectedLevelId,
    bool? gdprConsent,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      learningMode: learningMode ?? this.learningMode,
      selectedLevelId: selectedLevelId ?? this.selectedLevelId,
      gdprConsent: gdprConsent ?? this.gdprConsent,
    );
  }
}

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void setLearningMode(String mode) {
    state = state.copyWith(learningMode: mode);
  }

  void setSelectedLevel(int levelId) {
    state = state.copyWith(selectedLevelId: levelId);
  }

  void setGdprConsent(bool consent) {
    state = state.copyWith(gdprConsent: consent);
  }

  void nextPage() {
    if (state.currentPage < OnboardingState.totalPages - 1) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  Future<void> completeOnboarding() async {
    if (state.learningMode == null || state.selectedLevelId == null) return;

    final prefs = ref.read(sharedPreferencesSourceProvider);
    final locale = ref.read(localeProvider);
    await prefs.setLearningMode(state.learningMode!);
    await prefs.setActiveLevelId(state.selectedLevelId!);
    await prefs.setLocale(locale.languageCode);
    if (state.gdprConsent != null) {
      await prefs.setGdprConsent(state.gdprConsent!);
    }
    await prefs.setOnboardingCompleted(true);
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(() {
  return OnboardingNotifier();
});
