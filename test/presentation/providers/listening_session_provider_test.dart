import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/lesson_model.dart';
import 'package:mufeed_app/domain/models/level_model.dart';
import 'package:mufeed_app/domain/models/sentence_exercise_model.dart';
import 'package:mufeed_app/domain/models/unit_model.dart';
import 'package:mufeed_app/domain/models/verb_model.dart';
import 'package:mufeed_app/domain/models/word_model.dart';
import 'package:mufeed_app/domain/repositories/content_repository.dart';
import 'package:mufeed_app/presentation/providers/content_provider.dart';
import 'package:mufeed_app/presentation/providers/listening_session_provider.dart';

class FakeContentRepository implements ContentRepository {
  List<WordModel> words = [];
  List<VerbModel> verbs = [];

  @override
  Future<List<WordModel>> getWordsByLessonId(int lessonId) async => words;
  @override
  Future<List<VerbModel>> getVerbsByLessonId(int lessonId) async => verbs;
  @override
  Future<List<SentenceExerciseModel>> getExercisesForLesson(int lessonId) async => [];
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
}

WordModel _word(int id, String arabic, String fr) => WordModel(
      id: id,
      lessonId: 1,
      arabic: arabic,
      translationFr: fr,
      translationEn: '',
      grammaticalCategory: '',
      contentType: 'word',
      sortOrder: id,
    );

List<WordModel> _fourWords() => [
      _word(1, 'كِتَابٌ', 'livre'),
      _word(2, 'قَلَمٌ', 'stylo'),
      _word(3, 'بَيْتٌ', 'maison'),
      _word(4, 'بَابٌ', 'porte'),
    ];

ProviderContainer _container(FakeContentRepository repo) =>
    ProviderContainer(overrides: [
      contentRepositoryProvider.overrideWithValue(repo),
    ]);

void main() {
  group('ListeningSessionNotifier', () {
    test('initial state is null', () {
      final container = _container(FakeContentRepository());
      expect(container.read(listeningSessionProvider), isNull);
    });

    test('startSession with < 4 items leaves state null', () async {
      final repo = FakeContentRepository()
        ..words = [_word(1, 'كِتَابٌ', 'livre'), _word(2, 'قَلَمٌ', 'stylo')];
      final container = _container(repo);
      await container
          .read(listeningSessionProvider.notifier)
          .startSession(1);
      expect(container.read(listeningSessionProvider), isNull);
    });

    test('startSession with 4+ words sets state', () async {
      final repo = FakeContentRepository()..words = _fourWords();
      final container = _container(repo);
      await container
          .read(listeningSessionProvider.notifier)
          .startSession(1);
      final state = container.read(listeningSessionProvider);
      expect(state, isNotNull);
      expect(state!.currentIndex, 0);
      expect(state.hasAnswered, isFalse);
      expect(state.isCompleted, isFalse);
    });

    test('startSession caps at 8 questions', () async {
      final repo = FakeContentRepository()
        ..words = List.generate(
            12,
            (i) =>
                _word(i + 1, 'كَلِمَة$i', 'mot$i'));
      final container = _container(repo);
      await container
          .read(listeningSessionProvider.notifier)
          .startSession(1);
      expect(container.read(listeningSessionProvider)!.totalQuestions,
          lessThanOrEqualTo(8));
    });

    test('selectAnswer records correct answer', () async {
      final repo = FakeContentRepository()..words = _fourWords();
      final container = _container(repo);
      await container
          .read(listeningSessionProvider.notifier)
          .startSession(1);
      final s = container.read(listeningSessionProvider)!;
      final correctIndex = s.currentQuestion.choices
          .indexOf(s.currentQuestion.correctAnswer);
      container
          .read(listeningSessionProvider.notifier)
          .selectAnswer(correctIndex);
      final after = container.read(listeningSessionProvider)!;
      expect(after.selectedChoiceIndex, correctIndex);
      expect(after.isCorrect, isTrue);
    });

    test('selectAnswer records wrong answer', () async {
      final repo = FakeContentRepository()..words = _fourWords();
      final container = _container(repo);
      await container
          .read(listeningSessionProvider.notifier)
          .startSession(1);
      final s = container.read(listeningSessionProvider)!;
      final wrongIndex = (s.currentQuestion.choices
                  .indexOf(s.currentQuestion.correctAnswer) +
              1) %
          s.currentQuestion.choices.length;
      container
          .read(listeningSessionProvider.notifier)
          .selectAnswer(wrongIndex);
      final after = container.read(listeningSessionProvider)!;
      expect(after.isCorrect, isFalse);
    });

    test('selectAnswer is ignored if already answered', () async {
      final repo = FakeContentRepository()..words = _fourWords();
      final container = _container(repo);
      await container
          .read(listeningSessionProvider.notifier)
          .startSession(1);
      final s = container.read(listeningSessionProvider)!;
      final correctIndex = s.currentQuestion.choices
          .indexOf(s.currentQuestion.correctAnswer);
      container
          .read(listeningSessionProvider.notifier)
          .selectAnswer(correctIndex);
      container.read(listeningSessionProvider.notifier).selectAnswer(0);
      expect(container.read(listeningSessionProvider)!.selectedChoiceIndex,
          correctIndex);
    });

    test('nextQuestion resets answer and advances index', () async {
      final repo = FakeContentRepository()..words = _fourWords();
      final container = _container(repo);
      await container
          .read(listeningSessionProvider.notifier)
          .startSession(1);
      final s = container.read(listeningSessionProvider)!;
      final correctIndex = s.currentQuestion.choices
          .indexOf(s.currentQuestion.correctAnswer);
      container
          .read(listeningSessionProvider.notifier)
          .selectAnswer(correctIndex);
      container.read(listeningSessionProvider.notifier).nextQuestion();
      final after = container.read(listeningSessionProvider)!;
      expect(after.currentIndex, 1);
      expect(after.hasAnswered, isFalse);
      expect(after.isCorrect, isNull);
    });

    test('nextQuestion on last question sets isCompleted', () async {
      final repo = FakeContentRepository()..words = _fourWords();
      final container = _container(repo);
      await container
          .read(listeningSessionProvider.notifier)
          .startSession(1);
      // Exhaust all questions
      var s = container.read(listeningSessionProvider)!;
      for (var i = 0; i < s.totalQuestions; i++) {
        container.read(listeningSessionProvider.notifier).nextQuestion();
      }
      expect(container.read(listeningSessionProvider)!.isCompleted, isTrue);
    });

    test('endSession resets to null', () async {
      final repo = FakeContentRepository()..words = _fourWords();
      final container = _container(repo);
      await container
          .read(listeningSessionProvider.notifier)
          .startSession(1);
      container.read(listeningSessionProvider.notifier).endSession();
      expect(container.read(listeningSessionProvider), isNull);
    });
  });
}
