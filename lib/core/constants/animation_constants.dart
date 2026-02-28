import 'package:flutter/animation.dart';

abstract final class AnimationConstants {
  // Flashcard flip
  static const flipDuration = Duration(milliseconds: 300);
  static const flipCurve = Curves.easeInOut;

  // Card transitions
  static const cardTransitionDuration = Duration(milliseconds: 250);

  // Navigation
  static const navCrossfadeDuration = Duration(milliseconds: 300);
  static const heroPushDuration = Duration(milliseconds: 350);
  static const heroPushCurve = Curves.fastOutSlowIn;

  // Feedback
  static const buttonFeedbackDuration = Duration(milliseconds: 100);
  static const buttonFeedbackCurve = Curves.easeOut;

  // Skeleton shimmer
  static const shimmerDuration = Duration(milliseconds: 1500);

  // Summary bars
  static const summaryBarDuration = Duration(milliseconds: 400);
  static const summaryBarDelay = Duration(milliseconds: 100);
  static const summaryBarCurve = Curves.easeOutCubic;

  // Quiz
  static const quizCorrectDelay = Duration(milliseconds: 800);
  static const quizOptionColorDuration = Duration(milliseconds: 200);
  static const quizOptionColorCurve = Curves.easeOut;
  static const quizConfettiDuration = Duration(milliseconds: 700);
  static const quizDoubleHapticDelay = Duration(milliseconds: 100);

  // Onboarding
  static const onboardingPageDuration = Duration(milliseconds: 300);
  static const onboardingPageCurve = Curves.easeInOut;

  // TTS
  static const ttsIconTransitionDuration = Duration(milliseconds: 200);
  static const ttsErrorRecoveryDelay = Duration(seconds: 2);

  // Badge celebration
  static const badgeCelebrationDuration = Duration(milliseconds: 500);
  static const badgeCelebrationCurve = Curves.elasticOut;
  static const badgeCelebrationDisplayDuration = Duration(seconds: 3);

  // Matching exercise
  static const matchingFlashDuration = Duration(milliseconds: 600);
  static const matchingSuccessDelay = Duration(milliseconds: 1000);
}
