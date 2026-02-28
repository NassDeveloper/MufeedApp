// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Mufeed';

  @override
  String get tabHome => 'Accueil';

  @override
  String get tabVocabulary => 'Vocabulaire';

  @override
  String get tabExercises => 'Exercices';

  @override
  String get tabStatistics => 'Statistiques';

  @override
  String levelTitle(int number) {
    return 'Niveau $number';
  }

  @override
  String unitCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unités',
      one: '1 unité',
      zero: '0 unité',
    );
    return '$_temp0';
  }

  @override
  String unitTitle(int number) {
    return 'Unité $number';
  }

  @override
  String lessonTitle(int number) {
    return 'Leçon $number';
  }

  @override
  String get loading => 'Chargement...';

  @override
  String get errorLoadingContent => 'Erreur de chargement du contenu';

  @override
  String get retry => 'Réessayer';

  @override
  String get emptyContent => 'Aucun contenu disponible';

  @override
  String get emptyVocabulary => 'Aucun vocabulaire dans cette leçon';

  @override
  String get verbFormMasdar => 'Masdar (المصدر)';

  @override
  String get verbFormPast => 'Passé (الماضي)';

  @override
  String get verbFormPresent => 'Présent (المضارع)';

  @override
  String get verbFormImperative => 'Impératif (الأمر)';

  @override
  String get grammaticalCategory => 'Catégorie';

  @override
  String get singularLabel => 'Singulier';

  @override
  String get pluralLabel => 'Pluriel';

  @override
  String get synonymLabel => 'Synonyme';

  @override
  String get antonymLabel => 'Antonyme';

  @override
  String get reportError => 'Signaler une erreur';

  @override
  String get reportCategoryHarakat => 'Erreur de harakat';

  @override
  String get reportCategoryTranslation => 'Erreur de traduction';

  @override
  String get reportCategoryOther => 'Autre problème';

  @override
  String get reportComment => 'Commentaire (optionnel)';

  @override
  String get reportSend => 'Envoyer';

  @override
  String get reportCancel => 'Annuler';

  @override
  String get errorReportSent => 'Merci ! Signalement envoyé';

  @override
  String wordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mots',
      one: '1 mot',
      zero: '0 mot',
    );
    return '$_temp0';
  }

  @override
  String verbCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verbes',
      one: '1 verbe',
      zero: '0 verbe',
    );
    return '$_temp0';
  }

  @override
  String get resumeLastLesson => 'Reprendre';

  @override
  String get lastLessonVisited => 'Dernière leçon consultée';

  @override
  String get welcomeBack => 'Bon retour !';

  @override
  String get flashcardStartSession => 'Réviser';

  @override
  String get flashcardEndSession => 'Terminer la session';

  @override
  String flashcardProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get flashcardTapToFlip => 'Appuyez pour retourner';

  @override
  String get flashcardFront => 'Recto';

  @override
  String get flashcardBack => 'Verso';

  @override
  String get flashcardResumeSession => 'Reprendre la session ?';

  @override
  String get flashcardResumeYes => 'Reprendre';

  @override
  String get flashcardResumeNo => 'Nouvelle session';

  @override
  String get flashcardEmpty => 'Aucun élément à réviser';

  @override
  String flashcardSemanticCard(int current, int total) {
    return 'Flashcard $current sur $total';
  }

  @override
  String get flashcardSemanticFlipped => 'Carte retournée, verso visible';

  @override
  String get ratingAgain => 'À revoir';

  @override
  String get ratingHard => 'Difficile';

  @override
  String get ratingGood => 'Bien';

  @override
  String get ratingEasy => 'Facile';

  @override
  String get sessionSummaryTitle => 'Résumé';

  @override
  String sessionSummaryItemsReviewed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mots révisés',
      one: '1 mot révisé',
    );
    return '$_temp0';
  }

  @override
  String get sessionSummaryBackToLesson => 'Retour à la leçon';

  @override
  String get sessionSummaryRestart => 'Relancer une session';

  @override
  String get statsOverview => 'Vue d\'ensemble';

  @override
  String get statsNew => 'Nouveau';

  @override
  String get statsLearning => 'En apprentissage';

  @override
  String get statsReview => 'Maîtrisé';

  @override
  String get statsRelearning => 'À revoir';

  @override
  String statsWordsTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mots au total',
      one: '1 mot au total',
      zero: '0 mot au total',
    );
    return '$_temp0';
  }

  @override
  String statsSessionsCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions complétées',
      one: '1 session complétée',
      zero: '0 session complétée',
    );
    return '$_temp0';
  }

  @override
  String statsLessonProgress(int mastered, int total) {
    return '$mastered / $total';
  }

  @override
  String get statsEmpty => 'Aucune révision pour le moment';

  @override
  String get statsEmptyAction => 'Commencer à réviser';

  @override
  String get statsProgressBar => 'Barre de progression';

  @override
  String get quizTitle => 'QCM';

  @override
  String get quizStart => 'Lancer le QCM';

  @override
  String quizProgress(int current, int total) {
    return 'Question $current / $total';
  }

  @override
  String get quizCorrect => 'Bonne réponse !';

  @override
  String get quizIncorrect => 'Mauvaise réponse';

  @override
  String get quizTapToContinue => 'Appuyez pour continuer';

  @override
  String get quizEmptyTitle => 'Aucun exercice disponible';

  @override
  String get quizEmptyMessage =>
      'Cette leçon nécessite au minimum 4 mots pour lancer un QCM';

  @override
  String get quizEmptyAction => 'Retour';

  @override
  String quizSemanticOption(int index, String text) {
    return 'Choix $index : $text';
  }

  @override
  String quizSemanticQuestion(int current, int total) {
    return 'Question $current sur $total';
  }

  @override
  String get vocabularyScreenTitle => 'Mon vocabulaire';

  @override
  String get vocabularyScreenSubtitle => 'Parcourez les leçons par niveau';

  @override
  String get exercisesScreenTitle => 'Exercices';

  @override
  String get exercisesScreenSubtitle => 'Testez vos connaissances avec des QCM';

  @override
  String get exercisesDescription => 'Choisissez une leçon pour lancer un QCM';

  @override
  String get exercisesGoToVocabulary => 'Aller au vocabulaire';

  @override
  String get statisticsScreenTitle => 'Mes statistiques';

  @override
  String get statisticsScreenSubtitle => 'Suivez votre progression';

  @override
  String get statsActivityTitle => 'Activité des 14 derniers jours';

  @override
  String get statsUpcomingTitle => 'Révisions à venir';

  @override
  String get statsUpcomingToday => 'Aujourd\'hui';

  @override
  String get statsUpcomingTomorrow => 'Demain';

  @override
  String get statsUpcomingWeek => 'Cette semaine';

  @override
  String get statsUpcomingNone => 'Aucune révision en attente';

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
  String get quizSummaryTitle => 'Résultat QCM';

  @override
  String quizSummaryScore(int correct, int total) {
    return '$correct / $total';
  }

  @override
  String get quizSummaryCorrectLabel => 'Correctes';

  @override
  String get quizSummaryIncorrectLabel => 'Incorrectes';

  @override
  String get quizSummaryMissedWords => 'Mots à revoir';

  @override
  String get quizSummaryRestart => 'Relancer le QCM';

  @override
  String get quizSummaryBackToVocabulary => 'Retour au vocabulaire';

  @override
  String get quizSummaryGoToFlashcards => 'Réviser en flashcards';

  @override
  String quizSummarySemanticScore(int correct, int total) {
    return '$correct réponses correctes sur $total';
  }

  @override
  String quizSummarySemanticBar(String label, int count) {
    return '$label : $count';
  }

  @override
  String get onboardingWelcomeTitle => 'Apprends l\'arabe avec méthode';

  @override
  String get onboardingWelcomeSubtitle =>
      'Une méthode progressive et structurée pour maîtriser l\'arabe classique';

  @override
  String get onboardingStart => 'Commencer';

  @override
  String get onboardingModeTitle => 'Comment apprenez-vous ?';

  @override
  String get onboardingModeCurriculum => 'J\'étudie auprès d\'un institut';

  @override
  String get onboardingModeCurriculumDescription =>
      'Vous suivez un programme structuré avec un enseignant';

  @override
  String get onboardingModeAutodidact => 'Autodidacte';

  @override
  String get onboardingModeAutodidactDescription =>
      'Vous apprenez à votre rythme, de manière indépendante';

  @override
  String get onboardingLevelTitle => 'Choisissez votre niveau';

  @override
  String get onboardingLevelSubtitle =>
      'Vous pourrez le modifier à tout moment';

  @override
  String get onboardingConfirm => 'Confirmer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String onboardingSemanticPage(int current, int total) {
    return 'Étape $current sur $total';
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
  String get ttsButtonTooltip => 'Écouter la prononciation';

  @override
  String ttsButtonSemanticLabel(String text) {
    return 'Écouter la prononciation de $text';
  }

  @override
  String get ttsUnavailable => 'Prononciation non disponible';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsLearningMode => 'Mode d\'apprentissage';

  @override
  String get settingsActiveLevel => 'Niveau actif';

  @override
  String get settingsModeCurriculum => 'Cursus (sélection libre)';

  @override
  String get settingsModeCurriculumDescription =>
      'Choisissez librement la leçon à étudier';

  @override
  String get settingsModeAutodidact => 'Autodidacte (progression guidée)';

  @override
  String get settingsModeAutodidactDescription =>
      'Le système vous suggère la prochaine leçon';

  @override
  String homeCurrentMode(String mode) {
    return 'Mode : $mode';
  }

  @override
  String homeActiveLevel(String level) {
    return 'Niveau $level';
  }

  @override
  String get homeSuggestedLesson => 'Leçon suggérée';

  @override
  String get homeContinueLesson => 'Continuer';

  @override
  String get homeNextLevelSuggestion => 'Prêt pour le niveau suivant ?';

  @override
  String get homeModeCurriculum => 'Cursus';

  @override
  String get homeModeAutodidact => 'Autodidacte';

  @override
  String get settingsSemanticButton => 'Ouvrir les paramètres';

  @override
  String get homeGoToNextLevel => 'Passer au suivant';

  @override
  String get homeAllLevelsMastered => 'Bravo ! Tous les niveaux sont terminés';

  @override
  String get homeNextLevelSemanticLabel =>
      'Toutes les leçons maîtrisées. Passer au niveau suivant';

  @override
  String get dailySessionTitle => 'Session du jour';

  @override
  String get dailySessionCta => 'Lancer la session';

  @override
  String dailySessionDueCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mots à réviser',
      one: '1 mot à réviser',
    );
    return '$_temp0';
  }

  @override
  String dailySessionSemanticCta(int count) {
    return 'Session du jour : $count mots à réviser. Lancer la session';
  }

  @override
  String get dailySessionEmpty => 'Aucun mot à réviser';

  @override
  String get dailySummaryTitle => 'Session terminée !';

  @override
  String get dailySummaryBackHome => 'Retour à l\'accueil';

  @override
  String get dailySummaryRestart => 'Relancer une session';

  @override
  String get allReviewedTitle => 'Tout est révisé !';

  @override
  String get allReviewedSubtitle => 'Bravo, tous vos mots sont à jour';

  @override
  String get allReviewedExplore => 'Explorer le contenu';

  @override
  String get allReviewedReviewEarly => 'Réviser à l\'avance';

  @override
  String get allReviewedQuiz => 'Faire un QCM';

  @override
  String get resumeWelcomeTitle => 'Bon retour !';

  @override
  String get resumeWelcomeSubtitle => 'Reprenons en douceur avec quelques mots';

  @override
  String get resumeCtaButton => 'Reprendre';

  @override
  String get resumeDismissButton => 'Pas maintenant';

  @override
  String get resumeSemanticLabel =>
      'Session de reprise disponible. Reprendre la révision';

  @override
  String streakDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours de suite !',
      one: '1 jour',
      zero: '0 jour',
    );
    return '$_temp0';
  }

  @override
  String streakRecord(int count) {
    return 'Record : $count jours';
  }

  @override
  String get streakBrokenTitle => 'Série interrompue';

  @override
  String get streakBrokenMessage =>
      'Ce n\'est pas grave, l\'important c\'est de reprendre !';

  @override
  String get streakBrokenCta => 'C\'est reparti';

  @override
  String get streakFreezeUsedMessage =>
      'Votre gel de série a été utilisé ! Série préservée.';

  @override
  String get streakFreezeAvailable => 'Gel disponible';

  @override
  String get streakFreezeUsed => 'Gel utilisé';

  @override
  String streakSemanticLabel(int count, int record, String freeze) {
    return 'Série de $count jours consécutifs. Record : $record jours. $freeze';
  }

  @override
  String get streakEncouragement =>
      'Commencez une session pour lancer votre série !';

  @override
  String get badgeSectionTitle => 'Badges';

  @override
  String get badgeCelebrationTitle => 'Badge débloqué !';

  @override
  String badgeSemanticUnlocked(String badge) {
    return '$badge, débloqué';
  }

  @override
  String badgeSemanticLocked(String badge) {
    return '$badge, verrouillé';
  }

  @override
  String get badgeFirstWordReviewed => 'Premier pas';

  @override
  String get badgeFirstWordReviewedDesc => 'Révisez votre premier mot';

  @override
  String get badgeWords10 => '10 mots';

  @override
  String get badgeWords10Desc => 'Maîtrisez 10 mots';

  @override
  String get badgeWords50 => '50 mots';

  @override
  String get badgeWords50Desc => 'Maîtrisez 50 mots';

  @override
  String get badgeWords100 => '100 mots';

  @override
  String get badgeWords100Desc => 'Maîtrisez 100 mots';

  @override
  String get badgeWords500 => '500 mots';

  @override
  String get badgeWords500Desc => 'Maîtrisez 500 mots';

  @override
  String get badgeFirstLessonCompleted => 'Première leçon';

  @override
  String get badgeFirstLessonCompletedDesc => 'Complétez une leçon entière';

  @override
  String get badgeStreak7 => '1 semaine';

  @override
  String get badgeStreak7Desc => 'Maintenez une série de 7 jours';

  @override
  String get badgeStreak30 => '1 mois';

  @override
  String get badgeStreak30Desc => 'Maintenez une série de 30 jours';

  @override
  String get badgeStreak100 => '100 jours';

  @override
  String get badgeStreak100Desc => 'Maintenez une série de 100 jours';

  @override
  String get badgePerfectQuiz => 'Sans faute';

  @override
  String get badgePerfectQuizDesc => 'Obtenez un score parfait au QCM';

  @override
  String get badgeContinue => 'Continuer';

  @override
  String get settingsNotificationsSection => 'Notifications';

  @override
  String get settingsNotificationsEnabled => 'Rappel quotidien';

  @override
  String get settingsNotificationsTime => 'Heure du rappel';

  @override
  String get settingsNotificationsInfo =>
      'Vous recevrez un rappel chaque jour à cette heure';

  @override
  String get settingsNotificationsPermissionDenied =>
      'Autorisez les notifications dans les paramètres de votre appareil';

  @override
  String settingsNotificationsTimeSemanticLabel(int hour, int minute) {
    return 'Heure du rappel : ${hour}h$minute. Appuyez pour modifier';
  }

  @override
  String get settingsLanguageSection => 'Langue';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsThemeSection => 'Thème';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get onboardingConsentTitle => 'Données & confidentialité';

  @override
  String get onboardingConsentDescription =>
      'Mufeed peut collecter des données d\'utilisation anonymes (écrans visités, fonctionnalités utilisées) pour améliorer l\'application. Aucune donnée personnelle n\'est collectée. Vous pouvez modifier ce choix à tout moment dans les paramètres.';

  @override
  String get onboardingConsentAccept => 'Accepter';

  @override
  String get onboardingConsentRefuse => 'Refuser';

  @override
  String get onboardingConsentViewPolicy =>
      'Lire la politique de confidentialité';

  @override
  String get onboardingMiniSessionTitle => 'Aperçu de votre contenu';

  @override
  String get onboardingMiniSessionSubtitle =>
      'Quelques mots de votre premier niveau';

  @override
  String get onboardingPrevious => 'Précédent';

  @override
  String onboardingConsentRecapMode(String mode) {
    return 'Mode : $mode';
  }

  @override
  String onboardingConsentRecapLevel(String level) {
    return 'Niveau : $level';
  }

  @override
  String get settingsPrivacySection => 'Données & confidentialité';

  @override
  String get settingsPrivacyConsent => 'Analytics anonymes';

  @override
  String get settingsPrivacyInfo =>
      'Collecte anonyme d\'événements d\'utilisation pour améliorer l\'application. Aucune donnée personnelle n\'est incluse.';

  @override
  String get settingsPrivacyPolicyButton => 'Politique de confidentialité';

  @override
  String get privacyPolicyTitle => 'Politique de confidentialité';

  @override
  String get privacyPolicySectionData => 'Données collectées';

  @override
  String get privacyPolicyContentData =>
      'Mufeed ne collecte aucune donnée personnelle. Votre progression, vos préférences et vos résultats sont stockés exclusivement sur votre appareil. Aucune information n\'est transmise à des serveurs externes.';

  @override
  String get privacyPolicySectionAnalytics => 'Analytics anonymes';

  @override
  String get privacyPolicyContentAnalytics =>
      'Si vous avez accepté le consentement analytics, Mufeed collecte des événements d\'utilisation anonymes (écrans visités, fonctionnalités utilisées) via Firebase Analytics. Ces données ne contiennent aucune information personnelle identifiable et servent uniquement à améliorer l\'application. Vous pouvez activer ou désactiver cette collecte à tout moment dans les paramètres.';

  @override
  String get privacyPolicySectionStorage => 'Stockage local';

  @override
  String get privacyPolicyContentStorage =>
      'Toutes vos données de progression (vocabulaire appris, scores, séries) sont stockées localement sur votre appareil dans une base de données SQLite. Ces données ne quittent jamais votre appareil et sont supprimées si vous désinstallez l\'application.';

  @override
  String get privacyPolicySectionRights => 'Vos droits';

  @override
  String get privacyPolicyContentRights =>
      'Conformément au RGPD, vous disposez des droits suivants :\n\n• Accès : vos données sont accessibles directement dans l\'application\n• Suppression : désinstallez l\'application pour supprimer toutes vos données\n• Modification du consentement : modifiez votre choix analytics à tout moment dans les paramètres\n• Opposition : vous pouvez refuser la collecte de données analytics\n• Portabilité : vos données étant stockées localement, elles restent sous votre contrôle\n• Réclamation : vous pouvez introduire une réclamation auprès de la CNIL (cnil.fr) ou de l\'autorité de protection des données de votre pays';

  @override
  String get privacyPolicySectionContact => 'Contact';

  @override
  String get privacyPolicyContentContact =>
      'Pour toute question concernant la confidentialité de vos données, vous pouvez nous contacter à l\'adresse : privacy@mufeed.app';

  @override
  String get privacyPolicyLastUpdated => 'Dernière mise à jour : février 2026';

  @override
  String get sentenceExerciseTitle => 'Compléter les phrases';

  @override
  String get completeTheSentence => 'Complétez la phrase :';

  @override
  String get sentenceExerciseNext => 'Suivant';

  @override
  String get sentenceExerciseEmpty => 'Aucun exercice de complétion disponible';

  @override
  String get sentenceExerciseButton => 'Compléter';

  @override
  String get verbTableTitle => 'Tableau de conjugaison';

  @override
  String get verbTableButton => 'Conjugaison';

  @override
  String get verbTableTapToGuess => 'Tapez sur ? pour deviner';

  @override
  String verbTableScore(int correct, int total) {
    return '$correct / $total correct';
  }

  @override
  String get verbTableCompleted => 'Tableau complété !';

  @override
  String get verbTableEmpty => 'Pas assez de verbes pour cet exercice';

  @override
  String get verbTableTranslation => 'Traduction';

  @override
  String get statsVocabulary => 'Vocabulaire';

  @override
  String get statsVerbs => 'Verbes';

  @override
  String statsItemsTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '1 élément',
      zero: '0 élément',
    );
    return '$_temp0';
  }

  @override
  String statsMastered(int count) {
    return '$count maîtrisé(s)';
  }

  @override
  String get confirmQuitTitle => 'Quitter la session ?';

  @override
  String get confirmQuitMessage =>
      'Ta progression dans cette session sera perdue.';

  @override
  String get confirmQuitLeave => 'Quitter';

  @override
  String get confirmQuitStay => 'Continuer';

  @override
  String get matchingTitle => 'Association';

  @override
  String get matchingButton => 'Association';

  @override
  String matchingProgress(int matched, int total) {
    return '$matched / $total';
  }

  @override
  String get matchingEmptyTitle => 'Pas assez de mots';

  @override
  String get matchingEmptyMessage =>
      'Cette leçon nécessite au minimum 4 mots pour lancer un exercice d\'association.';

  @override
  String get matchingEmptyAction => 'Retour';

  @override
  String get wordOrderingTitle => 'Remise en ordre';

  @override
  String get wordOrderingButton => 'Ordre';

  @override
  String wordOrderingProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get wordOrderingInstruction => 'Remettez les mots dans le bon ordre';

  @override
  String get wordOrderingCorrect => 'Bonne réponse !';

  @override
  String get wordOrderingWrong => 'Pas tout à fait, réessayez !';

  @override
  String get wordOrderingNext => 'Suivant';

  @override
  String get wordOrderingReset => 'Réinitialiser';

  @override
  String get wordOrderingEmptyTitle => 'Aucune phrase disponible';

  @override
  String get wordOrderingEmptyMessage =>
      'Cette leçon ne possède pas encore d\'exercice de remise en ordre.';

  @override
  String get wordOrderingEmptyAction => 'Retour';

  @override
  String get dialogueTitle => 'Mini-dialogue';

  @override
  String get dialogueButton => 'Dialogue';

  @override
  String dialogueProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get dialogueNext => 'Suivant';

  @override
  String get dialogueEmptyTitle => 'Aucun dialogue disponible';

  @override
  String get dialogueEmptyMessage =>
      'Cette leçon ne possède pas encore de mini-dialogue.';

  @override
  String get dialogueEmptyAction => 'Retour';

  @override
  String get listeningTitle => 'Exercice d\'écoute';

  @override
  String get listeningButton => 'Écoute';

  @override
  String listeningProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get listeningInstruction => 'Écoutez et choisissez la traduction';

  @override
  String get listeningPlayButton => 'Jouer le mot';

  @override
  String get listeningEmptyTitle => 'Pas assez de mots';

  @override
  String get listeningEmptyMessage =>
      'Cette leçon nécessite au minimum 4 mots pour lancer un exercice d\'écoute.';

  @override
  String get listeningEmptyAction => 'Retour';
}
