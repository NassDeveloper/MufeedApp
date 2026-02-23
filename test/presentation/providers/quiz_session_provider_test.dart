import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/verb_model.dart';
import 'package:mufeed_app/domain/models/word_model.dart';
import 'package:mufeed_app/domain/models/session_model.dart';
import 'package:mufeed_app/domain/models/reviewable_item_model.dart';
import 'package:mufeed_app/domain/models/user_progress_model.dart';
import 'package:mufeed_app/domain/models/sentence_exercise_model.dart';
import 'package:mufeed_app/domain/repositories/content_repository.dart';
import 'package:mufeed_app/domain/repositories/progress_repository.dart';
import 'package:mufeed_app/domain/models/level_model.dart';
import 'package:mufeed_app/domain/models/unit_model.dart';
import 'package:mufeed_app/domain/models/lesson_model.dart';
import 'package:mufeed_app/domain/models/streak_model.dart';
import 'package:mufeed_app/domain/repositories/streak_repository.dart';
import 'package:mufeed_app/presentation/providers/content_provider.dart';
import 'package:mufeed_app/presentation/providers/quiz_session_provider.dart';
import 'package:mufeed_app/presentation/providers/srs_provider.dart';
import 'package:mufeed_app/presentation/providers/streak_provider.dart';

class FakeContentRepository implements ContentRepository {
  List<WordModel> words = [];
  List<VerbModel> verbs = [];

  @override
  Future<List<WordModel>> getWordsByLessonId(int lessonId) async => words;

  @override
  Future<List<VerbModel>> getVerbsByLessonId(int lessonId) async => verbs;

  @override
  Future<List<LevelModel>> getAllLevels() async => [];

  @override
  Future<List<UnitModel>> getUnitsByLevelId(int levelId) async => [];

  @override
  Future<List<LessonModel>> getLessonsByUnitId(int unitId) async => [];

  @override
  Future<List<LessonModel>> getLessonsByLevelId(int levelId) async => [];

  @override
  Future<LessonModel?> getLessonById(int lessonId) async => null;
  @override
  Future<List<SentenceExerciseModel>> getExercisesForLesson(int lessonId) async => [];
}

class FakeProgressRepository implements ProgressRepository {
  final List<SessionModel> savedSessions = [];

  @override
  Future<int> createSession(SessionModel session) async {
    savedSessions.add(session);
    return savedSessions.length;
  }

  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLesson(int lessonId) async => [];
  @override
  Future<List<UserProgressModel>> getDueItems() async => [];
  @override
  Future<List<ReviewableItemModel>> getDueReviewableItems() async => [];
  @override
  Future<UserProgressModel?> getProgressForItem(int itemId, String contentType) async => null;
  @override
  Future<void> saveProgress(UserProgressModel progress) async {}
  @override
  Future<Map<String, int>> getProgressCountsByState() async => {};
  @override
  Future<Map<String, Map<String, int>>> getProgressCountsByStateAndType() async => {};
  @override
  Future<int> getTotalWordCount() async => 0;
  @override
  Future<int> getTotalVerbCount() async => 0;
  @override
  Future<int> getTotalItemCount() async => 0;
  @override
  Future<int> getSessionCount() async => 0;
  @override
  Future<List<UserProgressModel>> getProgressForLesson(int lessonId) async => [];
  @override
  Future<int> getTotalItemCountForLesson(int lessonId) async => 0;

  @override
  Future<List<({int lessonId, int totalItems, int masteredCount})>>
      getLessonProgressSummaryForLevel(int levelId) async => [];

  @override
  Future<int> getTotalWordsReviewed() async => 0;
  @override
  Future<int> getCompletedLessonCount() async => 0;
  @override
  Future<bool> hasPerfectQuiz() async => false;
}

class FakeStreakRepository implements StreakRepository {
  @override
  Future<StreakModel?> getStreak() async => null;
  @override
  Future<DateTime?> getLastActivityDate() async => null;
  @override
  Future<void> updateLastActivityDate(DateTime date) async {}
  @override
  Future<void> updateStreak(StreakModel streak) async {}
}

WordModel _word(int id, String arabic, String translationFr) => WordModel(
      id: id,
      lessonId: 1,
      contentType: 'vocab',
      arabic: arabic,
      translationFr: translationFr,
      sortOrder: id,
    );

void main() {
  late ProviderContainer container;
  late FakeContentRepository fakeRepo;
  late FakeProgressRepository fakeProgressRepo;

  setUp(() {
    fakeRepo = FakeContentRepository();
    fakeProgressRepo = FakeProgressRepository();
    container = ProviderContainer(
      overrides: [
        contentRepositoryProvider.overrideWithValue(fakeRepo),
        progressRepositoryProvider.overrideWithValue(fakeProgressRepo),
        streakRepositoryProvider.overrideWithValue(FakeStreakRepository()),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('QuizSessionNotifier', () {
    test('startSession sets state with questions when enough items', () async {
      fakeRepo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      final notifier = container.read(quizSessionProvider.notifier);
      await notifier.startSession(1);

      final state = container.read(quizSessionProvider);
      expect(state, isNotNull);
      expect(state!.totalQuestions, 4);
      expect(state.currentIndex, 0);
      expect(state.score, 0);
      expect(state.isCompleted, false);
      expect(state.hasAnswered, false);
    });

    test('startSession sets null when not enough items', () async {
      fakeRepo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
      ];

      final notifier = container.read(quizSessionProvider.notifier);
      await notifier.startSession(1);

      expect(container.read(quizSessionProvider), isNull);
    });

    test('submitAnswer marks correct answer and increments score', () async {
      fakeRepo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      final notifier = container.read(quizSessionProvider.notifier);
      await notifier.startSession(1);

      final correctAnswer =
          container.read(quizSessionProvider)!.currentQuestion.correctAnswer;
      notifier.submitAnswer(correctAnswer);

      final state = container.read(quizSessionProvider)!;
      expect(state.isCorrect, true);
      expect(state.selectedAnswer, correctAnswer);
      expect(state.score, 1);
    });

    test('submitAnswer marks incorrect answer without incrementing score',
        () async {
      fakeRepo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      final notifier = container.read(quizSessionProvider.notifier);
      await notifier.startSession(1);

      final question = container.read(quizSessionProvider)!.currentQuestion;
      final wrongAnswer =
          question.choices.firstWhere((c) => c != question.correctAnswer);
      notifier.submitAnswer(wrongAnswer);

      final state = container.read(quizSessionProvider)!;
      expect(state.isCorrect, false);
      expect(state.selectedAnswer, wrongAnswer);
      expect(state.score, 0);
    });

    test('submitAnswer is ignored when already answered', () async {
      fakeRepo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      final notifier = container.read(quizSessionProvider.notifier);
      await notifier.startSession(1);

      final question = container.read(quizSessionProvider)!.currentQuestion;
      final wrongAnswer =
          question.choices.firstWhere((c) => c != question.correctAnswer);
      notifier.submitAnswer(wrongAnswer);
      notifier.submitAnswer(question.correctAnswer);

      final state = container.read(quizSessionProvider)!;
      expect(state.selectedAnswer, wrongAnswer);
      expect(state.score, 0);
    });

    test('nextQuestion advances to next question', () async {
      fakeRepo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      final notifier = container.read(quizSessionProvider.notifier);
      await notifier.startSession(1);

      final correctAnswer =
          container.read(quizSessionProvider)!.currentQuestion.correctAnswer;
      notifier.submitAnswer(correctAnswer);
      notifier.nextQuestion();

      final state = container.read(quizSessionProvider)!;
      expect(state.currentIndex, 1);
      expect(state.hasAnswered, false);
      expect(state.selectedAnswer, isNull);
      expect(state.isCorrect, isNull);
    });

    test('nextQuestion marks completed on last question', () async {
      fakeRepo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      final notifier = container.read(quizSessionProvider.notifier);
      await notifier.startSession(1);

      final state = container.read(quizSessionProvider)!;
      for (var i = 0; i < state.totalQuestions; i++) {
        final current = container.read(quizSessionProvider)!;
        notifier.submitAnswer(current.currentQuestion.correctAnswer);
        notifier.nextQuestion();
      }

      expect(container.read(quizSessionProvider)!.isCompleted, true);
    });

    test('endSession resets state to null', () async {
      fakeRepo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      final notifier = container.read(quizSessionProvider.notifier);
      await notifier.startSession(1);
      expect(container.read(quizSessionProvider), isNotNull);

      notifier.endSession();
      expect(container.read(quizSessionProvider), isNull);
    });

    test('score accumulates correctly across questions', () async {
      fakeRepo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      final notifier = container.read(quizSessionProvider.notifier);
      await notifier.startSession(1);

      // Answer first correctly
      var current = container.read(quizSessionProvider)!;
      notifier.submitAnswer(current.currentQuestion.correctAnswer);
      notifier.nextQuestion();

      // Answer second incorrectly
      current = container.read(quizSessionProvider)!;
      final wrongAnswer = current.currentQuestion.choices
          .firstWhere((c) => c != current.currentQuestion.correctAnswer);
      notifier.submitAnswer(wrongAnswer);
      notifier.nextQuestion();

      // Answer third correctly
      current = container.read(quizSessionProvider)!;
      notifier.submitAnswer(current.currentQuestion.correctAnswer);

      expect(container.read(quizSessionProvider)!.score, 2);
    });

    test('submitAnswer tracks results with QuizResultEntry', () async {
      fakeRepo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      final notifier = container.read(quizSessionProvider.notifier);
      await notifier.startSession(1);

      final question = container.read(quizSessionProvider)!.currentQuestion;
      notifier.submitAnswer(question.correctAnswer);

      final state = container.read(quizSessionProvider)!;
      expect(state.results.length, 1);
      expect(state.results.first.arabic, question.arabic);
      expect(state.results.first.correctAnswer, question.correctAnswer);
      expect(state.results.first.selectedAnswer, question.correctAnswer);
      expect(state.results.first.isCorrect, true);
    });

    test('incorrectResults returns only wrong answers', () async {
      fakeRepo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      final notifier = container.read(quizSessionProvider.notifier);
      await notifier.startSession(1);

      // Answer first correctly
      var current = container.read(quizSessionProvider)!;
      notifier.submitAnswer(current.currentQuestion.correctAnswer);
      notifier.nextQuestion();

      // Answer second incorrectly
      current = container.read(quizSessionProvider)!;
      final wrongAnswer = current.currentQuestion.choices
          .firstWhere((c) => c != current.currentQuestion.correctAnswer);
      notifier.submitAnswer(wrongAnswer);

      final state = container.read(quizSessionProvider)!;
      expect(state.results.length, 2);
      expect(state.incorrectResults.length, 1);
      expect(state.incorrectResults.first.isCorrect, false);
    });

    test('startSession records startedAt', () async {
      fakeRepo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      final before = DateTime.now();
      final notifier = container.read(quizSessionProvider.notifier);
      await notifier.startSession(1);
      final after = DateTime.now();

      final state = container.read(quizSessionProvider)!;
      expect(state.startedAt.isAfter(before.subtract(const Duration(seconds: 1))), true);
      expect(state.startedAt.isBefore(after.add(const Duration(seconds: 1))), true);
    });

    test('completeSession saves session to DB with results_json', () async {
      fakeRepo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      final notifier = container.read(quizSessionProvider.notifier);
      await notifier.startSession(1);

      // Answer all questions
      final state = container.read(quizSessionProvider)!;
      for (var i = 0; i < state.totalQuestions; i++) {
        final current = container.read(quizSessionProvider)!;
        notifier.submitAnswer(current.currentQuestion.correctAnswer);
        notifier.nextQuestion();
      }

      expect(container.read(quizSessionProvider)!.isCompleted, true);

      await notifier.completeSession();

      expect(fakeProgressRepo.savedSessions.length, 1);
      final saved = fakeProgressRepo.savedSessions.first;
      expect(saved.sessionType, 'quiz');
      expect(saved.itemsReviewed, 4);
      expect(saved.resultsJson, isNotNull);
      expect(saved.completedAt, isNotNull);
    });

    test('QuizResultEntry.toJson produces correct map', () {
      const entry = QuizResultEntry(
        arabic: 'كتاب',
        correctAnswer: 'livre',
        selectedAnswer: 'stylo',
        isCorrect: false,
        itemId: 1,
        contentType: 'vocab',
      );

      final json = entry.toJson();
      expect(json['arabic'], 'كتاب');
      expect(json['correctAnswer'], 'livre');
      expect(json['selectedAnswer'], 'stylo');
      expect(json['isCorrect'], false);
      expect(json['itemId'], 1);
      expect(json['contentType'], 'vocab');
    });
  });
}
