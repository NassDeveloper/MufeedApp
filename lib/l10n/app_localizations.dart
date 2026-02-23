import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mufeed'**
  String get appTitle;

  /// No description provided for @tabHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get tabHome;

  /// No description provided for @tabVocabulary.
  ///
  /// In fr, this message translates to:
  /// **'Vocabulaire'**
  String get tabVocabulary;

  /// No description provided for @tabExercises.
  ///
  /// In fr, this message translates to:
  /// **'Exercices'**
  String get tabExercises;

  /// No description provided for @tabStatistics.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get tabStatistics;

  /// No description provided for @levelTitle.
  ///
  /// In fr, this message translates to:
  /// **'Niveau {number}'**
  String levelTitle(int number);

  /// No description provided for @unitCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 unité} =1{1 unité} other{{count} unités}}'**
  String unitCount(int count);

  /// No description provided for @unitTitle.
  ///
  /// In fr, this message translates to:
  /// **'Unité {number}'**
  String unitTitle(int number);

  /// No description provided for @lessonTitle.
  ///
  /// In fr, this message translates to:
  /// **'Leçon {number}'**
  String lessonTitle(int number);

  /// No description provided for @loading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement...'**
  String get loading;

  /// No description provided for @errorLoadingContent.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de chargement du contenu'**
  String get errorLoadingContent;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @emptyContent.
  ///
  /// In fr, this message translates to:
  /// **'Aucun contenu disponible'**
  String get emptyContent;

  /// No description provided for @emptyVocabulary.
  ///
  /// In fr, this message translates to:
  /// **'Aucun vocabulaire dans cette leçon'**
  String get emptyVocabulary;

  /// No description provided for @verbFormMasdar.
  ///
  /// In fr, this message translates to:
  /// **'Masdar (المصدر)'**
  String get verbFormMasdar;

  /// No description provided for @verbFormPast.
  ///
  /// In fr, this message translates to:
  /// **'Passé (الماضي)'**
  String get verbFormPast;

  /// No description provided for @verbFormPresent.
  ///
  /// In fr, this message translates to:
  /// **'Présent (المضارع)'**
  String get verbFormPresent;

  /// No description provided for @verbFormImperative.
  ///
  /// In fr, this message translates to:
  /// **'Impératif (الأمر)'**
  String get verbFormImperative;

  /// No description provided for @grammaticalCategory.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get grammaticalCategory;

  /// No description provided for @singularLabel.
  ///
  /// In fr, this message translates to:
  /// **'Singulier'**
  String get singularLabel;

  /// No description provided for @pluralLabel.
  ///
  /// In fr, this message translates to:
  /// **'Pluriel'**
  String get pluralLabel;

  /// No description provided for @synonymLabel.
  ///
  /// In fr, this message translates to:
  /// **'Synonyme'**
  String get synonymLabel;

  /// No description provided for @antonymLabel.
  ///
  /// In fr, this message translates to:
  /// **'Antonyme'**
  String get antonymLabel;

  /// No description provided for @reportError.
  ///
  /// In fr, this message translates to:
  /// **'Signaler une erreur'**
  String get reportError;

  /// No description provided for @reportCategoryHarakat.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de harakat'**
  String get reportCategoryHarakat;

  /// No description provided for @reportCategoryTranslation.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de traduction'**
  String get reportCategoryTranslation;

  /// No description provided for @reportCategoryOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre problème'**
  String get reportCategoryOther;

  /// No description provided for @reportComment.
  ///
  /// In fr, this message translates to:
  /// **'Commentaire (optionnel)'**
  String get reportComment;

  /// No description provided for @reportSend.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get reportSend;

  /// No description provided for @reportCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get reportCancel;

  /// No description provided for @errorReportSent.
  ///
  /// In fr, this message translates to:
  /// **'Merci ! Signalement envoyé'**
  String get errorReportSent;

  /// No description provided for @wordCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 mot} =1{1 mot} other{{count} mots}}'**
  String wordCount(int count);

  /// No description provided for @verbCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 verbe} =1{1 verbe} other{{count} verbes}}'**
  String verbCount(int count);

  /// No description provided for @resumeLastLesson.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre'**
  String get resumeLastLesson;

  /// No description provided for @lastLessonVisited.
  ///
  /// In fr, this message translates to:
  /// **'Dernière leçon consultée'**
  String get lastLessonVisited;

  /// No description provided for @welcomeBack.
  ///
  /// In fr, this message translates to:
  /// **'Bon retour !'**
  String get welcomeBack;

  /// No description provided for @flashcardStartSession.
  ///
  /// In fr, this message translates to:
  /// **'Réviser'**
  String get flashcardStartSession;

  /// No description provided for @flashcardEndSession.
  ///
  /// In fr, this message translates to:
  /// **'Terminer la session'**
  String get flashcardEndSession;

  /// No description provided for @flashcardProgress.
  ///
  /// In fr, this message translates to:
  /// **'{current} / {total}'**
  String flashcardProgress(int current, int total);

  /// No description provided for @flashcardTapToFlip.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez pour retourner'**
  String get flashcardTapToFlip;

  /// No description provided for @flashcardFront.
  ///
  /// In fr, this message translates to:
  /// **'Recto'**
  String get flashcardFront;

  /// No description provided for @flashcardBack.
  ///
  /// In fr, this message translates to:
  /// **'Verso'**
  String get flashcardBack;

  /// No description provided for @flashcardResumeSession.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre la session ?'**
  String get flashcardResumeSession;

  /// No description provided for @flashcardResumeYes.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre'**
  String get flashcardResumeYes;

  /// No description provided for @flashcardResumeNo.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle session'**
  String get flashcardResumeNo;

  /// No description provided for @flashcardEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun élément à réviser'**
  String get flashcardEmpty;

  /// No description provided for @flashcardSemanticCard.
  ///
  /// In fr, this message translates to:
  /// **'Flashcard {current} sur {total}'**
  String flashcardSemanticCard(int current, int total);

  /// No description provided for @flashcardSemanticFlipped.
  ///
  /// In fr, this message translates to:
  /// **'Carte retournée, verso visible'**
  String get flashcardSemanticFlipped;

  /// No description provided for @ratingAgain.
  ///
  /// In fr, this message translates to:
  /// **'À revoir'**
  String get ratingAgain;

  /// No description provided for @ratingHard.
  ///
  /// In fr, this message translates to:
  /// **'Difficile'**
  String get ratingHard;

  /// No description provided for @ratingGood.
  ///
  /// In fr, this message translates to:
  /// **'Bien'**
  String get ratingGood;

  /// No description provided for @ratingEasy.
  ///
  /// In fr, this message translates to:
  /// **'Facile'**
  String get ratingEasy;

  /// No description provided for @sessionSummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Résumé'**
  String get sessionSummaryTitle;

  /// No description provided for @sessionSummaryItemsReviewed.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 mot révisé} other{{count} mots révisés}}'**
  String sessionSummaryItemsReviewed(int count);

  /// No description provided for @sessionSummaryBackToLesson.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la leçon'**
  String get sessionSummaryBackToLesson;

  /// No description provided for @sessionSummaryRestart.
  ///
  /// In fr, this message translates to:
  /// **'Relancer une session'**
  String get sessionSummaryRestart;

  /// No description provided for @statsOverview.
  ///
  /// In fr, this message translates to:
  /// **'Vue d\'ensemble'**
  String get statsOverview;

  /// No description provided for @statsNew.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau'**
  String get statsNew;

  /// No description provided for @statsLearning.
  ///
  /// In fr, this message translates to:
  /// **'En apprentissage'**
  String get statsLearning;

  /// No description provided for @statsReview.
  ///
  /// In fr, this message translates to:
  /// **'Maîtrisé'**
  String get statsReview;

  /// No description provided for @statsRelearning.
  ///
  /// In fr, this message translates to:
  /// **'À revoir'**
  String get statsRelearning;

  /// No description provided for @statsWordsTotal.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 mot au total} =1{1 mot au total} other{{count} mots au total}}'**
  String statsWordsTotal(int count);

  /// No description provided for @statsSessionsCompleted.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 session complétée} =1{1 session complétée} other{{count} sessions complétées}}'**
  String statsSessionsCompleted(int count);

  /// No description provided for @statsLessonProgress.
  ///
  /// In fr, this message translates to:
  /// **'{mastered} / {total}'**
  String statsLessonProgress(int mastered, int total);

  /// No description provided for @statsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune révision pour le moment'**
  String get statsEmpty;

  /// No description provided for @statsEmptyAction.
  ///
  /// In fr, this message translates to:
  /// **'Commencer à réviser'**
  String get statsEmptyAction;

  /// No description provided for @statsProgressBar.
  ///
  /// In fr, this message translates to:
  /// **'Barre de progression'**
  String get statsProgressBar;

  /// No description provided for @quizTitle.
  ///
  /// In fr, this message translates to:
  /// **'QCM'**
  String get quizTitle;

  /// No description provided for @quizStart.
  ///
  /// In fr, this message translates to:
  /// **'Lancer le QCM'**
  String get quizStart;

  /// No description provided for @quizProgress.
  ///
  /// In fr, this message translates to:
  /// **'Question {current} / {total}'**
  String quizProgress(int current, int total);

  /// No description provided for @quizCorrect.
  ///
  /// In fr, this message translates to:
  /// **'Bonne réponse !'**
  String get quizCorrect;

  /// No description provided for @quizIncorrect.
  ///
  /// In fr, this message translates to:
  /// **'Mauvaise réponse'**
  String get quizIncorrect;

  /// No description provided for @quizTapToContinue.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez pour continuer'**
  String get quizTapToContinue;

  /// No description provided for @quizEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun exercice disponible'**
  String get quizEmptyTitle;

  /// No description provided for @quizEmptyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette leçon nécessite au minimum 4 mots pour lancer un QCM'**
  String get quizEmptyMessage;

  /// No description provided for @quizEmptyAction.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get quizEmptyAction;

  /// No description provided for @quizSemanticOption.
  ///
  /// In fr, this message translates to:
  /// **'Choix {index} : {text}'**
  String quizSemanticOption(int index, String text);

  /// No description provided for @quizSemanticQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Question {current} sur {total}'**
  String quizSemanticQuestion(int current, int total);

  /// No description provided for @vocabularyScreenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon vocabulaire'**
  String get vocabularyScreenTitle;

  /// No description provided for @vocabularyScreenSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Parcourez les leçons par niveau'**
  String get vocabularyScreenSubtitle;

  /// No description provided for @exercisesScreenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Exercices'**
  String get exercisesScreenTitle;

  /// No description provided for @exercisesScreenSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Testez vos connaissances avec des QCM'**
  String get exercisesScreenSubtitle;

  /// No description provided for @exercisesDescription.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une leçon pour lancer un QCM'**
  String get exercisesDescription;

  /// No description provided for @exercisesGoToVocabulary.
  ///
  /// In fr, this message translates to:
  /// **'Aller au vocabulaire'**
  String get exercisesGoToVocabulary;

  /// No description provided for @statisticsScreenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes statistiques'**
  String get statisticsScreenTitle;

  /// No description provided for @statisticsScreenSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Suivez votre progression'**
  String get statisticsScreenSubtitle;

  /// No description provided for @quizSummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Résultat QCM'**
  String get quizSummaryTitle;

  /// No description provided for @quizSummaryScore.
  ///
  /// In fr, this message translates to:
  /// **'{correct} / {total}'**
  String quizSummaryScore(int correct, int total);

  /// No description provided for @quizSummaryCorrectLabel.
  ///
  /// In fr, this message translates to:
  /// **'Correctes'**
  String get quizSummaryCorrectLabel;

  /// No description provided for @quizSummaryIncorrectLabel.
  ///
  /// In fr, this message translates to:
  /// **'Incorrectes'**
  String get quizSummaryIncorrectLabel;

  /// No description provided for @quizSummaryMissedWords.
  ///
  /// In fr, this message translates to:
  /// **'Mots à revoir'**
  String get quizSummaryMissedWords;

  /// No description provided for @quizSummaryRestart.
  ///
  /// In fr, this message translates to:
  /// **'Relancer le QCM'**
  String get quizSummaryRestart;

  /// No description provided for @quizSummaryBackToVocabulary.
  ///
  /// In fr, this message translates to:
  /// **'Retour au vocabulaire'**
  String get quizSummaryBackToVocabulary;

  /// No description provided for @quizSummaryGoToFlashcards.
  ///
  /// In fr, this message translates to:
  /// **'Réviser en flashcards'**
  String get quizSummaryGoToFlashcards;

  /// No description provided for @quizSummarySemanticScore.
  ///
  /// In fr, this message translates to:
  /// **'{correct} réponses correctes sur {total}'**
  String quizSummarySemanticScore(int correct, int total);

  /// No description provided for @quizSummarySemanticBar.
  ///
  /// In fr, this message translates to:
  /// **'{label} : {count}'**
  String quizSummarySemanticBar(String label, int count);

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Apprends l\'arabe avec méthode'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Une méthode progressive et structurée pour maîtriser l\'arabe classique'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get onboardingStart;

  /// No description provided for @onboardingModeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Comment apprenez-vous ?'**
  String get onboardingModeTitle;

  /// No description provided for @onboardingModeCurriculum.
  ///
  /// In fr, this message translates to:
  /// **'J\'étudie auprès d\'un institut'**
  String get onboardingModeCurriculum;

  /// No description provided for @onboardingModeCurriculumDescription.
  ///
  /// In fr, this message translates to:
  /// **'Vous suivez un programme structuré avec un enseignant'**
  String get onboardingModeCurriculumDescription;

  /// No description provided for @onboardingModeAutodidact.
  ///
  /// In fr, this message translates to:
  /// **'Autodidacte'**
  String get onboardingModeAutodidact;

  /// No description provided for @onboardingModeAutodidactDescription.
  ///
  /// In fr, this message translates to:
  /// **'Vous apprenez à votre rythme, de manière indépendante'**
  String get onboardingModeAutodidactDescription;

  /// No description provided for @onboardingLevelTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre niveau'**
  String get onboardingLevelTitle;

  /// No description provided for @onboardingLevelSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vous pourrez le modifier à tout moment'**
  String get onboardingLevelSubtitle;

  /// No description provided for @onboardingConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get onboardingConfirm;

  /// No description provided for @onboardingNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get onboardingNext;

  /// No description provided for @onboardingSemanticPage.
  ///
  /// In fr, this message translates to:
  /// **'Étape {current} sur {total}'**
  String onboardingSemanticPage(int current, int total);

  /// No description provided for @onboardingSemanticMode.
  ///
  /// In fr, this message translates to:
  /// **'{title}, {description}'**
  String onboardingSemanticMode(String title, String description);

  /// No description provided for @onboardingSemanticLevel.
  ///
  /// In fr, this message translates to:
  /// **'{name}, {unitCount}'**
  String onboardingSemanticLevel(String name, String unitCount);

  /// No description provided for @ttsButtonTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Écouter la prononciation'**
  String get ttsButtonTooltip;

  /// No description provided for @ttsButtonSemanticLabel.
  ///
  /// In fr, this message translates to:
  /// **'Écouter la prononciation de {text}'**
  String ttsButtonSemanticLabel(String text);

  /// No description provided for @ttsUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Prononciation non disponible'**
  String get ttsUnavailable;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// No description provided for @settingsLearningMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode d\'apprentissage'**
  String get settingsLearningMode;

  /// No description provided for @settingsActiveLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau actif'**
  String get settingsActiveLevel;

  /// No description provided for @settingsModeCurriculum.
  ///
  /// In fr, this message translates to:
  /// **'Cursus (sélection libre)'**
  String get settingsModeCurriculum;

  /// No description provided for @settingsModeCurriculumDescription.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez librement la leçon à étudier'**
  String get settingsModeCurriculumDescription;

  /// No description provided for @settingsModeAutodidact.
  ///
  /// In fr, this message translates to:
  /// **'Autodidacte (progression guidée)'**
  String get settingsModeAutodidact;

  /// No description provided for @settingsModeAutodidactDescription.
  ///
  /// In fr, this message translates to:
  /// **'Le système vous suggère la prochaine leçon'**
  String get settingsModeAutodidactDescription;

  /// No description provided for @homeCurrentMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode : {mode}'**
  String homeCurrentMode(String mode);

  /// No description provided for @homeActiveLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau {level}'**
  String homeActiveLevel(String level);

  /// No description provided for @homeSuggestedLesson.
  ///
  /// In fr, this message translates to:
  /// **'Leçon suggérée'**
  String get homeSuggestedLesson;

  /// No description provided for @homeContinueLesson.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get homeContinueLesson;

  /// No description provided for @homeNextLevelSuggestion.
  ///
  /// In fr, this message translates to:
  /// **'Prêt pour le niveau suivant ?'**
  String get homeNextLevelSuggestion;

  /// No description provided for @homeModeCurriculum.
  ///
  /// In fr, this message translates to:
  /// **'Cursus'**
  String get homeModeCurriculum;

  /// No description provided for @homeModeAutodidact.
  ///
  /// In fr, this message translates to:
  /// **'Autodidacte'**
  String get homeModeAutodidact;

  /// No description provided for @settingsSemanticButton.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir les paramètres'**
  String get settingsSemanticButton;

  /// No description provided for @homeGoToNextLevel.
  ///
  /// In fr, this message translates to:
  /// **'Passer au suivant'**
  String get homeGoToNextLevel;

  /// No description provided for @homeAllLevelsMastered.
  ///
  /// In fr, this message translates to:
  /// **'Bravo ! Tous les niveaux sont terminés'**
  String get homeAllLevelsMastered;

  /// No description provided for @homeNextLevelSemanticLabel.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les leçons maîtrisées. Passer au niveau suivant'**
  String get homeNextLevelSemanticLabel;

  /// No description provided for @dailySessionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Session du jour'**
  String get dailySessionTitle;

  /// No description provided for @dailySessionCta.
  ///
  /// In fr, this message translates to:
  /// **'Lancer la session'**
  String get dailySessionCta;

  /// No description provided for @dailySessionDueCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 mot à réviser} other{{count} mots à réviser}}'**
  String dailySessionDueCount(int count);

  /// No description provided for @dailySessionSemanticCta.
  ///
  /// In fr, this message translates to:
  /// **'Session du jour : {count} mots à réviser. Lancer la session'**
  String dailySessionSemanticCta(int count);

  /// No description provided for @dailySessionEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun mot à réviser'**
  String get dailySessionEmpty;

  /// No description provided for @dailySummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Session terminée !'**
  String get dailySummaryTitle;

  /// No description provided for @dailySummaryBackHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get dailySummaryBackHome;

  /// No description provided for @dailySummaryRestart.
  ///
  /// In fr, this message translates to:
  /// **'Relancer une session'**
  String get dailySummaryRestart;

  /// No description provided for @allReviewedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tout est révisé !'**
  String get allReviewedTitle;

  /// No description provided for @allReviewedSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Bravo, tous vos mots sont à jour'**
  String get allReviewedSubtitle;

  /// No description provided for @allReviewedExplore.
  ///
  /// In fr, this message translates to:
  /// **'Explorer le contenu'**
  String get allReviewedExplore;

  /// No description provided for @allReviewedReviewEarly.
  ///
  /// In fr, this message translates to:
  /// **'Réviser à l\'avance'**
  String get allReviewedReviewEarly;

  /// No description provided for @allReviewedQuiz.
  ///
  /// In fr, this message translates to:
  /// **'Faire un QCM'**
  String get allReviewedQuiz;

  /// No description provided for @resumeWelcomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bon retour !'**
  String get resumeWelcomeTitle;

  /// No description provided for @resumeWelcomeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Reprenons en douceur avec quelques mots'**
  String get resumeWelcomeSubtitle;

  /// No description provided for @resumeCtaButton.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre'**
  String get resumeCtaButton;

  /// No description provided for @resumeDismissButton.
  ///
  /// In fr, this message translates to:
  /// **'Pas maintenant'**
  String get resumeDismissButton;

  /// No description provided for @resumeSemanticLabel.
  ///
  /// In fr, this message translates to:
  /// **'Session de reprise disponible. Reprendre la révision'**
  String get resumeSemanticLabel;

  /// No description provided for @streakDaysCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 jour} =1{1 jour} other{{count} jours de suite !}}'**
  String streakDaysCount(int count);

  /// No description provided for @streakRecord.
  ///
  /// In fr, this message translates to:
  /// **'Record : {count} jours'**
  String streakRecord(int count);

  /// No description provided for @streakBrokenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Série interrompue'**
  String get streakBrokenTitle;

  /// No description provided for @streakBrokenMessage.
  ///
  /// In fr, this message translates to:
  /// **'Ce n\'est pas grave, l\'important c\'est de reprendre !'**
  String get streakBrokenMessage;

  /// No description provided for @streakBrokenCta.
  ///
  /// In fr, this message translates to:
  /// **'C\'est reparti'**
  String get streakBrokenCta;

  /// No description provided for @streakFreezeUsedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Votre gel de série a été utilisé ! Série préservée.'**
  String get streakFreezeUsedMessage;

  /// No description provided for @streakFreezeAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Gel disponible'**
  String get streakFreezeAvailable;

  /// No description provided for @streakFreezeUsed.
  ///
  /// In fr, this message translates to:
  /// **'Gel utilisé'**
  String get streakFreezeUsed;

  /// No description provided for @streakSemanticLabel.
  ///
  /// In fr, this message translates to:
  /// **'Série de {count} jours consécutifs. Record : {record} jours. {freeze}'**
  String streakSemanticLabel(int count, int record, String freeze);

  /// No description provided for @streakEncouragement.
  ///
  /// In fr, this message translates to:
  /// **'Commencez une session pour lancer votre série !'**
  String get streakEncouragement;

  /// No description provided for @badgeSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Badges'**
  String get badgeSectionTitle;

  /// No description provided for @badgeCelebrationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Badge débloqué !'**
  String get badgeCelebrationTitle;

  /// No description provided for @badgeSemanticUnlocked.
  ///
  /// In fr, this message translates to:
  /// **'{badge}, débloqué'**
  String badgeSemanticUnlocked(String badge);

  /// No description provided for @badgeSemanticLocked.
  ///
  /// In fr, this message translates to:
  /// **'{badge}, verrouillé'**
  String badgeSemanticLocked(String badge);

  /// No description provided for @badgeFirstWordReviewed.
  ///
  /// In fr, this message translates to:
  /// **'Premier pas'**
  String get badgeFirstWordReviewed;

  /// No description provided for @badgeFirstWordReviewedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Révisez votre premier mot'**
  String get badgeFirstWordReviewedDesc;

  /// No description provided for @badgeWords10.
  ///
  /// In fr, this message translates to:
  /// **'10 mots'**
  String get badgeWords10;

  /// No description provided for @badgeWords10Desc.
  ///
  /// In fr, this message translates to:
  /// **'Maîtrisez 10 mots'**
  String get badgeWords10Desc;

  /// No description provided for @badgeWords50.
  ///
  /// In fr, this message translates to:
  /// **'50 mots'**
  String get badgeWords50;

  /// No description provided for @badgeWords50Desc.
  ///
  /// In fr, this message translates to:
  /// **'Maîtrisez 50 mots'**
  String get badgeWords50Desc;

  /// No description provided for @badgeWords100.
  ///
  /// In fr, this message translates to:
  /// **'100 mots'**
  String get badgeWords100;

  /// No description provided for @badgeWords100Desc.
  ///
  /// In fr, this message translates to:
  /// **'Maîtrisez 100 mots'**
  String get badgeWords100Desc;

  /// No description provided for @badgeWords500.
  ///
  /// In fr, this message translates to:
  /// **'500 mots'**
  String get badgeWords500;

  /// No description provided for @badgeWords500Desc.
  ///
  /// In fr, this message translates to:
  /// **'Maîtrisez 500 mots'**
  String get badgeWords500Desc;

  /// No description provided for @badgeFirstLessonCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Première leçon'**
  String get badgeFirstLessonCompleted;

  /// No description provided for @badgeFirstLessonCompletedDesc.
  ///
  /// In fr, this message translates to:
  /// **'Complétez une leçon entière'**
  String get badgeFirstLessonCompletedDesc;

  /// No description provided for @badgeStreak7.
  ///
  /// In fr, this message translates to:
  /// **'1 semaine'**
  String get badgeStreak7;

  /// No description provided for @badgeStreak7Desc.
  ///
  /// In fr, this message translates to:
  /// **'Maintenez une série de 7 jours'**
  String get badgeStreak7Desc;

  /// No description provided for @badgeStreak30.
  ///
  /// In fr, this message translates to:
  /// **'1 mois'**
  String get badgeStreak30;

  /// No description provided for @badgeStreak30Desc.
  ///
  /// In fr, this message translates to:
  /// **'Maintenez une série de 30 jours'**
  String get badgeStreak30Desc;

  /// No description provided for @badgeStreak100.
  ///
  /// In fr, this message translates to:
  /// **'100 jours'**
  String get badgeStreak100;

  /// No description provided for @badgeStreak100Desc.
  ///
  /// In fr, this message translates to:
  /// **'Maintenez une série de 100 jours'**
  String get badgeStreak100Desc;

  /// No description provided for @badgePerfectQuiz.
  ///
  /// In fr, this message translates to:
  /// **'Sans faute'**
  String get badgePerfectQuiz;

  /// No description provided for @badgePerfectQuizDesc.
  ///
  /// In fr, this message translates to:
  /// **'Obtenez un score parfait au QCM'**
  String get badgePerfectQuizDesc;

  /// No description provided for @badgeContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get badgeContinue;

  /// No description provided for @settingsNotificationsSection.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsSection;

  /// No description provided for @settingsNotificationsEnabled.
  ///
  /// In fr, this message translates to:
  /// **'Rappel quotidien'**
  String get settingsNotificationsEnabled;

  /// No description provided for @settingsNotificationsTime.
  ///
  /// In fr, this message translates to:
  /// **'Heure du rappel'**
  String get settingsNotificationsTime;

  /// No description provided for @settingsNotificationsInfo.
  ///
  /// In fr, this message translates to:
  /// **'Vous recevrez un rappel chaque jour à cette heure'**
  String get settingsNotificationsInfo;

  /// No description provided for @settingsNotificationsPermissionDenied.
  ///
  /// In fr, this message translates to:
  /// **'Autorisez les notifications dans les paramètres de votre appareil'**
  String get settingsNotificationsPermissionDenied;

  /// No description provided for @settingsNotificationsTimeSemanticLabel.
  ///
  /// In fr, this message translates to:
  /// **'Heure du rappel : {hour}h{minute}. Appuyez pour modifier'**
  String settingsNotificationsTimeSemanticLabel(int hour, int minute);

  /// No description provided for @settingsLanguageSection.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguageSection;

  /// No description provided for @settingsLanguageFr.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get settingsLanguageFr;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsThemeSection.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get settingsThemeSection;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get settingsThemeDark;

  /// No description provided for @onboardingConsentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Données & confidentialité'**
  String get onboardingConsentTitle;

  /// No description provided for @onboardingConsentDescription.
  ///
  /// In fr, this message translates to:
  /// **'Mufeed peut collecter des données d\'utilisation anonymes (écrans visités, fonctionnalités utilisées) pour améliorer l\'application. Aucune donnée personnelle n\'est collectée. Vous pouvez modifier ce choix à tout moment dans les paramètres.'**
  String get onboardingConsentDescription;

  /// No description provided for @onboardingConsentAccept.
  ///
  /// In fr, this message translates to:
  /// **'Accepter'**
  String get onboardingConsentAccept;

  /// No description provided for @onboardingConsentRefuse.
  ///
  /// In fr, this message translates to:
  /// **'Refuser'**
  String get onboardingConsentRefuse;

  /// No description provided for @onboardingConsentViewPolicy.
  ///
  /// In fr, this message translates to:
  /// **'Lire la politique de confidentialité'**
  String get onboardingConsentViewPolicy;

  /// No description provided for @settingsPrivacySection.
  ///
  /// In fr, this message translates to:
  /// **'Données & confidentialité'**
  String get settingsPrivacySection;

  /// No description provided for @settingsPrivacyConsent.
  ///
  /// In fr, this message translates to:
  /// **'Analytics anonymes'**
  String get settingsPrivacyConsent;

  /// No description provided for @settingsPrivacyInfo.
  ///
  /// In fr, this message translates to:
  /// **'Collecte anonyme d\'événements d\'utilisation pour améliorer l\'application. Aucune donnée personnelle n\'est incluse.'**
  String get settingsPrivacyInfo;

  /// No description provided for @settingsPrivacyPolicyButton.
  ///
  /// In fr, this message translates to:
  /// **'Politique de confidentialité'**
  String get settingsPrivacyPolicyButton;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Politique de confidentialité'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicySectionData.
  ///
  /// In fr, this message translates to:
  /// **'Données collectées'**
  String get privacyPolicySectionData;

  /// No description provided for @privacyPolicyContentData.
  ///
  /// In fr, this message translates to:
  /// **'Mufeed ne collecte aucune donnée personnelle. Votre progression, vos préférences et vos résultats sont stockés exclusivement sur votre appareil. Aucune information n\'est transmise à des serveurs externes.'**
  String get privacyPolicyContentData;

  /// No description provided for @privacyPolicySectionAnalytics.
  ///
  /// In fr, this message translates to:
  /// **'Analytics anonymes'**
  String get privacyPolicySectionAnalytics;

  /// No description provided for @privacyPolicyContentAnalytics.
  ///
  /// In fr, this message translates to:
  /// **'Si vous avez accepté le consentement analytics, Mufeed collecte des événements d\'utilisation anonymes (écrans visités, fonctionnalités utilisées) via Firebase Analytics. Ces données ne contiennent aucune information personnelle identifiable et servent uniquement à améliorer l\'application. Vous pouvez activer ou désactiver cette collecte à tout moment dans les paramètres.'**
  String get privacyPolicyContentAnalytics;

  /// No description provided for @privacyPolicySectionStorage.
  ///
  /// In fr, this message translates to:
  /// **'Stockage local'**
  String get privacyPolicySectionStorage;

  /// No description provided for @privacyPolicyContentStorage.
  ///
  /// In fr, this message translates to:
  /// **'Toutes vos données de progression (vocabulaire appris, scores, séries) sont stockées localement sur votre appareil dans une base de données SQLite. Ces données ne quittent jamais votre appareil et sont supprimées si vous désinstallez l\'application.'**
  String get privacyPolicyContentStorage;

  /// No description provided for @privacyPolicySectionRights.
  ///
  /// In fr, this message translates to:
  /// **'Vos droits'**
  String get privacyPolicySectionRights;

  /// No description provided for @privacyPolicyContentRights.
  ///
  /// In fr, this message translates to:
  /// **'Conformément au RGPD, vous disposez des droits suivants :\n\n• Accès : vos données sont accessibles directement dans l\'application\n• Suppression : désinstallez l\'application pour supprimer toutes vos données\n• Modification du consentement : modifiez votre choix analytics à tout moment dans les paramètres\n• Opposition : vous pouvez refuser la collecte de données analytics\n• Portabilité : vos données étant stockées localement, elles restent sous votre contrôle\n• Réclamation : vous pouvez introduire une réclamation auprès de la CNIL (cnil.fr) ou de l\'autorité de protection des données de votre pays'**
  String get privacyPolicyContentRights;

  /// No description provided for @privacyPolicySectionContact.
  ///
  /// In fr, this message translates to:
  /// **'Contact'**
  String get privacyPolicySectionContact;

  /// No description provided for @privacyPolicyContentContact.
  ///
  /// In fr, this message translates to:
  /// **'Pour toute question concernant la confidentialité de vos données, vous pouvez nous contacter à l\'adresse : privacy@mufeed.app'**
  String get privacyPolicyContentContact;

  /// No description provided for @privacyPolicyLastUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Dernière mise à jour : février 2026'**
  String get privacyPolicyLastUpdated;

  /// No description provided for @sentenceExerciseTitle.
  ///
  /// In fr, this message translates to:
  /// **'Compléter les phrases'**
  String get sentenceExerciseTitle;

  /// No description provided for @completeTheSentence.
  ///
  /// In fr, this message translates to:
  /// **'Complétez la phrase :'**
  String get completeTheSentence;

  /// No description provided for @sentenceExerciseNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get sentenceExerciseNext;

  /// No description provided for @sentenceExerciseEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun exercice de complétion disponible'**
  String get sentenceExerciseEmpty;

  /// No description provided for @sentenceExerciseButton.
  ///
  /// In fr, this message translates to:
  /// **'Compléter'**
  String get sentenceExerciseButton;

  /// No description provided for @verbTableTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de conjugaison'**
  String get verbTableTitle;

  /// No description provided for @verbTableButton.
  ///
  /// In fr, this message translates to:
  /// **'Conjugaison'**
  String get verbTableButton;

  /// No description provided for @verbTableTapToGuess.
  ///
  /// In fr, this message translates to:
  /// **'Tapez sur ? pour deviner'**
  String get verbTableTapToGuess;

  /// No description provided for @verbTableScore.
  ///
  /// In fr, this message translates to:
  /// **'{correct} / {total} correct'**
  String verbTableScore(int correct, int total);

  /// No description provided for @verbTableCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Tableau complété !'**
  String get verbTableCompleted;

  /// No description provided for @verbTableEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Pas assez de verbes pour cet exercice'**
  String get verbTableEmpty;

  /// No description provided for @verbTableTranslation.
  ///
  /// In fr, this message translates to:
  /// **'Traduction'**
  String get verbTableTranslation;

  /// No description provided for @statsVocabulary.
  ///
  /// In fr, this message translates to:
  /// **'Vocabulaire'**
  String get statsVocabulary;

  /// No description provided for @statsVerbs.
  ///
  /// In fr, this message translates to:
  /// **'Verbes'**
  String get statsVerbs;

  /// No description provided for @statsItemsTotal.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 élément} =1{1 élément} other{{count} éléments}}'**
  String statsItemsTotal(int count);

  /// No description provided for @statsMastered.
  ///
  /// In fr, this message translates to:
  /// **'{count} maîtrisé(s)'**
  String statsMastered(int count);

  /// No description provided for @confirmQuitTitle.
  ///
  /// In fr, this message translates to:
  /// **'Quitter la session ?'**
  String get confirmQuitTitle;

  /// No description provided for @confirmQuitMessage.
  ///
  /// In fr, this message translates to:
  /// **'Ta progression dans cette session sera perdue.'**
  String get confirmQuitMessage;

  /// No description provided for @confirmQuitLeave.
  ///
  /// In fr, this message translates to:
  /// **'Quitter'**
  String get confirmQuitLeave;

  /// No description provided for @confirmQuitStay.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get confirmQuitStay;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
