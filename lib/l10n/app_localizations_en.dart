// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mufeed';

  @override
  String get tabHome => 'Home';

  @override
  String get tabVocabulary => 'Vocabulary';

  @override
  String get tabExercises => 'Exercises';

  @override
  String get tabStatistics => 'Statistics';

  @override
  String levelTitle(int number) {
    return 'Level $number';
  }

  @override
  String unitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count units',
      one: '1 unit',
      zero: '0 units',
    );
    return '$_temp0';
  }

  @override
  String unitTitle(int number) {
    return 'Unit $number';
  }

  @override
  String lessonTitle(int number) {
    return 'Lesson $number';
  }

  @override
  String get loading => 'Loading...';

  @override
  String get errorLoadingContent => 'Error loading content';

  @override
  String get retry => 'Retry';

  @override
  String get emptyContent => 'No content available';

  @override
  String get emptyVocabulary => 'No vocabulary in this lesson';

  @override
  String get verbFormMasdar => 'Masdar (المصدر)';

  @override
  String get verbFormPast => 'Past (الماضي)';

  @override
  String get verbFormPresent => 'Present (المضارع)';

  @override
  String get verbFormImperative => 'Imperative (الأمر)';

  @override
  String get grammaticalCategory => 'Category';

  @override
  String get singularLabel => 'Singular';

  @override
  String get pluralLabel => 'Plural';

  @override
  String get synonymLabel => 'Synonym';

  @override
  String get antonymLabel => 'Antonym';

  @override
  String get reportError => 'Report an error';

  @override
  String get reportCategoryHarakat => 'Harakat error';

  @override
  String get reportCategoryTranslation => 'Translation error';

  @override
  String get reportCategoryOther => 'Other issue';

  @override
  String get reportComment => 'Comment (optional)';

  @override
  String get reportSend => 'Send';

  @override
  String get reportCancel => 'Cancel';

  @override
  String get errorReportSent => 'Thank you! Report sent';

  @override
  String wordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words',
      one: '1 word',
      zero: '0 words',
    );
    return '$_temp0';
  }

  @override
  String verbCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verbs',
      one: '1 verb',
      zero: '0 verbs',
    );
    return '$_temp0';
  }

  @override
  String get resumeLastLesson => 'Resume';

  @override
  String get lastLessonVisited => 'Last lesson visited';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get flashcardStartSession => 'Review';

  @override
  String get flashcardEndSession => 'End session';

  @override
  String flashcardProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get flashcardTapToFlip => 'Tap to flip';

  @override
  String get flashcardFront => 'Front';

  @override
  String get flashcardBack => 'Back';

  @override
  String get flashcardResumeSession => 'Resume session?';

  @override
  String get flashcardResumeYes => 'Resume';

  @override
  String get flashcardResumeNo => 'New session';

  @override
  String get flashcardEmpty => 'No items to review';

  @override
  String flashcardSemanticCard(int current, int total) {
    return 'Flashcard $current of $total';
  }

  @override
  String get flashcardSemanticFlipped => 'Card flipped, back side visible';

  @override
  String get ratingAgain => 'Again';

  @override
  String get ratingHard => 'Hard';

  @override
  String get ratingGood => 'Good';

  @override
  String get ratingEasy => 'Easy';

  @override
  String get sessionSummaryTitle => 'Summary';

  @override
  String sessionSummaryItemsReviewed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words reviewed',
      one: '1 word reviewed',
    );
    return '$_temp0';
  }

  @override
  String get sessionSummaryBackToLesson => 'Back to lesson';

  @override
  String get sessionSummaryRestart => 'Start new session';

  @override
  String get statsOverview => 'Overview';

  @override
  String get statsNew => 'New';

  @override
  String get statsLearning => 'Learning';

  @override
  String get statsReview => 'Mastered';

  @override
  String get statsRelearning => 'Relearning';

  @override
  String statsWordsTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words total',
      one: '1 word total',
      zero: '0 words total',
    );
    return '$_temp0';
  }

  @override
  String statsSessionsCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions completed',
      one: '1 session completed',
      zero: '0 sessions completed',
    );
    return '$_temp0';
  }

  @override
  String statsLessonProgress(int mastered, int total) {
    return '$mastered / $total';
  }

  @override
  String get statsEmpty => 'No reviews yet';

  @override
  String get statsEmptyAction => 'Start reviewing';

  @override
  String get statsProgressBar => 'Progress bar';

  @override
  String get quizTitle => 'Quiz';

  @override
  String get quizStart => 'Start Quiz';

  @override
  String quizProgress(int current, int total) {
    return 'Question $current / $total';
  }

  @override
  String get quizCorrect => 'Correct!';

  @override
  String get quizIncorrect => 'Incorrect';

  @override
  String get quizTapToContinue => 'Tap to continue';

  @override
  String get quizEmptyTitle => 'No exercises available';

  @override
  String get quizEmptyMessage =>
      'This lesson needs at least 4 words to start a quiz';

  @override
  String get quizEmptyAction => 'Go back';

  @override
  String quizSemanticOption(int index, String text) {
    return 'Choice $index: $text';
  }

  @override
  String quizSemanticQuestion(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get vocabularyScreenTitle => 'My vocabulary';

  @override
  String get vocabularyScreenSubtitle => 'Browse lessons by level';

  @override
  String get exercisesScreenTitle => 'Exercises';

  @override
  String get exercisesScreenSubtitle => 'Test your knowledge with quizzes';

  @override
  String get exercisesDescription => 'Choose a lesson to start a quiz';

  @override
  String get exercisesGoToVocabulary => 'Go to vocabulary';

  @override
  String get statisticsScreenTitle => 'My statistics';

  @override
  String get statisticsScreenSubtitle => 'Track your progress';

  @override
  String get statsActivityTitle => 'Activity over 14 days';

  @override
  String get statsUpcomingTitle => 'Upcoming reviews';

  @override
  String get statsUpcomingToday => 'Today';

  @override
  String get statsUpcomingTomorrow => 'Tomorrow';

  @override
  String get statsUpcomingWeek => 'This week';

  @override
  String get statsUpcomingNone => 'No reviews pending';

  @override
  String statsUpcomingItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: '0 item',
    );
    return '$_temp0';
  }

  @override
  String get quizSummaryTitle => 'Quiz Results';

  @override
  String quizSummaryScore(int correct, int total) {
    return '$correct / $total';
  }

  @override
  String get quizSummaryCorrectLabel => 'Correct';

  @override
  String get quizSummaryIncorrectLabel => 'Incorrect';

  @override
  String get quizSummaryMissedWords => 'Words to review';

  @override
  String get quizSummaryRestart => 'Restart quiz';

  @override
  String get quizSummaryBackToVocabulary => 'Back to vocabulary';

  @override
  String get quizSummaryGoToFlashcards => 'Review with flashcards';

  @override
  String quizSummarySemanticScore(int correct, int total) {
    return '$correct correct answers out of $total';
  }

  @override
  String quizSummarySemanticBar(String label, int count) {
    return '$label: $count';
  }

  @override
  String get onboardingWelcomeTitle => 'Learn Arabic with method';

  @override
  String get onboardingWelcomeSubtitle =>
      'A progressive and structured approach to mastering classical Arabic';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingModeTitle => 'How do you learn?';

  @override
  String get onboardingModeCurriculum => 'I study at an institute';

  @override
  String get onboardingModeCurriculumDescription =>
      'You follow a structured program with a teacher';

  @override
  String get onboardingModeAutodidact => 'Self-taught';

  @override
  String get onboardingModeAutodidactDescription =>
      'You learn at your own pace, independently';

  @override
  String get onboardingLevelTitle => 'Choose your level';

  @override
  String get onboardingLevelSubtitle => 'You can change it at any time';

  @override
  String get onboardingConfirm => 'Confirm';

  @override
  String get onboardingNext => 'Next';

  @override
  String onboardingSemanticPage(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String onboardingSemanticMode(String title, String description) {
    return '$title, $description';
  }

  @override
  String onboardingSemanticLevel(String name, String unitCount) {
    return '$name, $unitCount';
  }

  @override
  String get ttsButtonTooltip => 'Listen to pronunciation';

  @override
  String ttsButtonSemanticLabel(String text) {
    return 'Listen to pronunciation of $text';
  }

  @override
  String get ttsUnavailable => 'Pronunciation unavailable';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLearningMode => 'Learning mode';

  @override
  String get settingsActiveLevel => 'Active level';

  @override
  String get settingsModeCurriculum => 'Curriculum (free selection)';

  @override
  String get settingsModeCurriculumDescription =>
      'Choose freely which lesson to study';

  @override
  String get settingsModeAutodidact => 'Self-study (guided progression)';

  @override
  String get settingsModeAutodidactDescription =>
      'The system suggests the next lesson';

  @override
  String homeCurrentMode(String mode) {
    return 'Mode: $mode';
  }

  @override
  String homeActiveLevel(String level) {
    return 'Level $level';
  }

  @override
  String get homeSuggestedLesson => 'Suggested lesson';

  @override
  String get homeContinueLesson => 'Continue';

  @override
  String get homeNextLevelSuggestion => 'Ready for the next level?';

  @override
  String get homeModeCurriculum => 'Curriculum';

  @override
  String get homeModeAutodidact => 'Self-study';

  @override
  String get settingsSemanticButton => 'Open settings';

  @override
  String get homeGoToNextLevel => 'Go to next level';

  @override
  String get homeAllLevelsMastered => 'Congratulations! All levels completed';

  @override
  String get homeNextLevelSemanticLabel =>
      'All lessons mastered. Go to next level';

  @override
  String get dailySessionTitle => 'Daily session';

  @override
  String get dailySessionCta => 'Start session';

  @override
  String dailySessionDueCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words to review',
      one: '1 word to review',
    );
    return '$_temp0';
  }

  @override
  String dailySessionSemanticCta(int count) {
    return 'Daily session: $count words to review. Start session';
  }

  @override
  String get dailySessionEmpty => 'No words to review';

  @override
  String get dailySummaryTitle => 'Session complete!';

  @override
  String get dailySummaryBackHome => 'Back to home';

  @override
  String get dailySummaryRestart => 'Start new session';

  @override
  String get allReviewedTitle => 'All reviewed!';

  @override
  String get allReviewedSubtitle => 'Great job, all your words are up to date';

  @override
  String get allReviewedExplore => 'Explore content';

  @override
  String get allReviewedReviewEarly => 'Review early';

  @override
  String get allReviewedQuiz => 'Take a quiz';

  @override
  String get resumeWelcomeTitle => 'Welcome back!';

  @override
  String get resumeWelcomeSubtitle => 'Let\'s ease back in with a few words';

  @override
  String get resumeCtaButton => 'Resume';

  @override
  String get resumeDismissButton => 'Not now';

  @override
  String get resumeSemanticLabel => 'Resume session available. Start reviewing';

  @override
  String streakDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days in a row!',
      one: '1 day',
      zero: '0 days',
    );
    return '$_temp0';
  }

  @override
  String streakRecord(int count) {
    return 'Record: $count days';
  }

  @override
  String get streakBrokenTitle => 'Streak broken';

  @override
  String get streakBrokenMessage =>
      'Don\'t worry, what matters is getting back on track!';

  @override
  String get streakBrokenCta => 'Let\'s go';

  @override
  String get streakFreezeUsedMessage =>
      'Your streak freeze was used! Streak preserved.';

  @override
  String get streakFreezeAvailable => 'Freeze available';

  @override
  String get streakFreezeUsed => 'Freeze used';

  @override
  String streakSemanticLabel(int count, int record, String freeze) {
    return 'Streak of $count consecutive days. Record: $record days. $freeze';
  }

  @override
  String get streakEncouragement => 'Complete a session to start your streak!';

  @override
  String get badgeSectionTitle => 'Badges';

  @override
  String get badgeCelebrationTitle => 'Badge unlocked!';

  @override
  String badgeSemanticUnlocked(String badge) {
    return '$badge, unlocked';
  }

  @override
  String badgeSemanticLocked(String badge) {
    return '$badge, locked';
  }

  @override
  String get badgeFirstWordReviewed => 'First step';

  @override
  String get badgeFirstWordReviewedDesc => 'Review your first word';

  @override
  String get badgeWords10 => '10 words';

  @override
  String get badgeWords10Desc => 'Master 10 words';

  @override
  String get badgeWords50 => '50 words';

  @override
  String get badgeWords50Desc => 'Master 50 words';

  @override
  String get badgeWords100 => '100 words';

  @override
  String get badgeWords100Desc => 'Master 100 words';

  @override
  String get badgeWords500 => '500 words';

  @override
  String get badgeWords500Desc => 'Master 500 words';

  @override
  String get badgeFirstLessonCompleted => 'First lesson';

  @override
  String get badgeFirstLessonCompletedDesc => 'Complete an entire lesson';

  @override
  String get badgeStreak7 => '1 week';

  @override
  String get badgeStreak7Desc => 'Maintain a 7-day streak';

  @override
  String get badgeStreak30 => '1 month';

  @override
  String get badgeStreak30Desc => 'Maintain a 30-day streak';

  @override
  String get badgeStreak100 => '100 days';

  @override
  String get badgeStreak100Desc => 'Maintain a 100-day streak';

  @override
  String get badgePerfectQuiz => 'Perfect score';

  @override
  String get badgePerfectQuizDesc => 'Get a perfect score on a quiz';

  @override
  String get badgeContinue => 'Continue';

  @override
  String get settingsNotificationsSection => 'Notifications';

  @override
  String get settingsNotificationsEnabled => 'Daily reminder';

  @override
  String get settingsNotificationsTime => 'Reminder time';

  @override
  String get settingsNotificationsInfo =>
      'You will receive a reminder every day at this time';

  @override
  String get settingsNotificationsPermissionDenied =>
      'Enable notifications in your device settings';

  @override
  String settingsNotificationsTimeSemanticLabel(int hour, int minute) {
    return 'Reminder time: $hour:$minute. Tap to change';
  }

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsThemeSection => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get onboardingConsentTitle => 'Data & Privacy';

  @override
  String get onboardingConsentDescription =>
      'Mufeed can collect anonymous usage data (screens visited, features used) to improve the app. No personal data is collected. You can change this at any time in the settings.';

  @override
  String get onboardingConsentAccept => 'Accept';

  @override
  String get onboardingConsentRefuse => 'Decline';

  @override
  String get onboardingConsentViewPolicy => 'Read privacy policy';

  @override
  String get onboardingMiniSessionTitle => 'Content preview';

  @override
  String get onboardingMiniSessionSubtitle =>
      'A few words from your first level';

  @override
  String get onboardingPrevious => 'Back';

  @override
  String onboardingConsentRecapMode(String mode) {
    return 'Mode: $mode';
  }

  @override
  String onboardingConsentRecapLevel(String level) {
    return 'Level: $level';
  }

  @override
  String get settingsPrivacySection => 'Data & Privacy';

  @override
  String get settingsPrivacyConsent => 'Anonymous analytics';

  @override
  String get settingsPrivacyInfo =>
      'Anonymous collection of usage events to improve the app. No personal data is included.';

  @override
  String get settingsPrivacyPolicyButton => 'Privacy Policy';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicySectionData => 'Data Collected';

  @override
  String get privacyPolicyContentData =>
      'Mufeed does not collect any personal data. Your progress, preferences, and results are stored exclusively on your device. No information is transmitted to external servers.';

  @override
  String get privacyPolicySectionAnalytics => 'Anonymous Analytics';

  @override
  String get privacyPolicyContentAnalytics =>
      'If you have accepted analytics consent, Mufeed collects anonymous usage events (screens visited, features used) via Firebase Analytics. This data does not contain any personally identifiable information and is used solely to improve the app. You can enable or disable this collection at any time in the settings.';

  @override
  String get privacyPolicySectionStorage => 'Local Storage';

  @override
  String get privacyPolicyContentStorage =>
      'All your progress data (learned vocabulary, scores, streaks) is stored locally on your device in a SQLite database. This data never leaves your device and is deleted if you uninstall the app.';

  @override
  String get privacyPolicySectionRights => 'Your Rights';

  @override
  String get privacyPolicyContentRights =>
      'In accordance with GDPR, you have the following rights:\n\n• Access: your data is accessible directly within the app\n• Deletion: uninstall the app to delete all your data\n• Consent modification: change your analytics choice at any time in the settings\n• Objection: you can refuse analytics data collection\n• Portability: since your data is stored locally, it remains under your control\n• Complaint: you can lodge a complaint with your local data protection authority (e.g., CNIL in France)';

  @override
  String get privacyPolicySectionContact => 'Contact';

  @override
  String get privacyPolicyContentContact =>
      'For any questions regarding the privacy of your data, you can contact us at: privacy@mufeed.app';

  @override
  String get privacyPolicyLastUpdated => 'Last updated: February 2026';

  @override
  String get sentenceExerciseTitle => 'Complete sentences';

  @override
  String get completeTheSentence => 'Complete the sentence:';

  @override
  String get sentenceExerciseNext => 'Next';

  @override
  String get sentenceExerciseEmpty => 'No sentence exercises available';

  @override
  String get sentenceExerciseButton => 'Complete';

  @override
  String get verbTableTitle => 'Conjugation table';

  @override
  String get verbTableButton => 'Conjugation';

  @override
  String get verbTableTapToGuess => 'Tap ? to guess';

  @override
  String verbTableScore(int correct, int total) {
    return '$correct / $total correct';
  }

  @override
  String get verbTableCompleted => 'Table completed!';

  @override
  String get verbTableEmpty => 'Not enough verbs for this exercise';

  @override
  String get verbTableTranslation => 'Translation';

  @override
  String get statsVocabulary => 'Vocabulary';

  @override
  String get statsVerbs => 'Verbs';

  @override
  String statsItemsTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: '0 items',
    );
    return '$_temp0';
  }

  @override
  String statsMastered(int count) {
    return '$count mastered';
  }

  @override
  String get confirmQuitTitle => 'Quit session?';

  @override
  String get confirmQuitMessage =>
      'Your progress in this session will be lost.';

  @override
  String get confirmQuitLeave => 'Quit';

  @override
  String get confirmQuitStay => 'Continue';

  @override
  String get matchingTitle => 'Matching';

  @override
  String get matchingButton => 'Matching';

  @override
  String matchingProgress(int matched, int total) {
    return '$matched / $total';
  }

  @override
  String get matchingEmptyTitle => 'Not enough words';

  @override
  String get matchingEmptyMessage =>
      'This lesson needs at least 4 words to start a matching exercise.';

  @override
  String get matchingEmptyAction => 'Back';

  @override
  String get wordOrderingTitle => 'Word Ordering';

  @override
  String get wordOrderingButton => 'Order';

  @override
  String wordOrderingProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get wordOrderingInstruction => 'Put the words in the right order';

  @override
  String get wordOrderingCorrect => 'Correct!';

  @override
  String get wordOrderingWrong => 'Not quite, try again!';

  @override
  String get wordOrderingNext => 'Next';

  @override
  String get wordOrderingReset => 'Reset';

  @override
  String get wordOrderingEmptyTitle => 'No sentences available';

  @override
  String get wordOrderingEmptyMessage =>
      'This lesson doesn\'t have word ordering exercises yet.';

  @override
  String get wordOrderingEmptyAction => 'Back';

  @override
  String get dialogueTitle => 'Mini-dialogue';

  @override
  String get dialogueButton => 'Dialogue';

  @override
  String dialogueProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get dialogueNext => 'Next';

  @override
  String get dialogueEmptyTitle => 'No dialogue available';

  @override
  String get dialogueEmptyMessage =>
      'This lesson doesn\'t have any mini-dialogue yet.';

  @override
  String get dialogueEmptyAction => 'Back';

  @override
  String get listeningTitle => 'Listening Exercise';

  @override
  String get listeningButton => 'Listen';

  @override
  String listeningProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get listeningInstruction => 'Listen and choose the translation';

  @override
  String get listeningPlayButton => 'Play word';

  @override
  String get listeningEmptyTitle => 'Not enough words';

  @override
  String get listeningEmptyMessage =>
      'This lesson needs at least 4 words to start a listening exercise.';

  @override
  String get listeningEmptyAction => 'Back';

  @override
  String get settingsLearningSection => 'Learning';

  @override
  String get settingsNewWordsPerDay => 'New words per day';

  @override
  String get settingsNewWordsPerDayDesc =>
      'Words introduced each day in the daily session';

  @override
  String levelProgressLabel(int mastered, int total) {
    return '$mastered / $total words';
  }

  @override
  String get lessonActivitiesTitle => 'Activities';

  @override
  String lessonActivitiesProgress(int mastered, int total) {
    return '$mastered / $total mastered';
  }

  @override
  String get activityFlashcards => 'Flashcards';

  @override
  String get activityPhrases => 'Complete sentences';

  @override
  String get activityVerbTable => 'Conjugation table';

  @override
  String get activityMatching => 'Matching';

  @override
  String get activityWordOrdering => 'Word ordering';

  @override
  String get activityListening => 'Listening';

  @override
  String get activityDialogue => 'Mini-dialogue';

  @override
  String get activityQuiz => 'Quiz';

  @override
  String get activityLesson => 'Lesson';
}
