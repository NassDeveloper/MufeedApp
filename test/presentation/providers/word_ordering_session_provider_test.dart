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
import 'package:mufeed_app/presentation/providers/word_ordering_session_provider.dart';

class FakeContentRepository implements ContentRepository {
  List<SentenceExerciseModel> exercises = [];

  @override
  Future<List<SentenceExerciseModel>> getExercisesForLesson(
          int lessonId) async =>
      exercises;

  @override
  Future<List<WordModel>> getWordsByLessonId(int lessonId) async => [];
  @override
  Future<List<VerbModel>> getVerbsByLessonId(int lessonId) async => [];
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

SentenceExerciseModel _ex(String sentenceAr, String sentenceFr,
    List<String> choices, int correctIndex) {
  return SentenceExerciseModel(
    lessonId: 1,
    sentenceFr: sentenceFr,
    sentenceAr: sentenceAr,
    choices: choices,
    correctIndex: correctIndex,
    explanations: List.filled(choices.length, ''),
  );
}

/// Returns an exercise whose reconstructed Arabic sentence has 3 tokens.
/// e.g. "أَيْنَ المَدْرَسَةُ ؟"
SentenceExerciseModel _ex3tokens() => _ex(
      '___ المَدْرَسَةُ ؟',
      '___ المَدْرَسَةُ ؟ (Où est l\'école ?)',
      ['أَيْنَ', 'مَتَى', 'مَنْ'],
      0,
    );

/// Returns an exercise whose reconstructed Arabic sentence has only 2 tokens.
SentenceExerciseModel _ex2tokens() => _ex(
      '___ طَالِبٌ.',
      '___ est étudiant. (Il)',
      ['هُوَ', 'هِيَ'],
      0,
    );

/// Returns an exercise with 4 tokens: "لَا أَذْهَبُ إِلَى المَدْرَسَةِ."
SentenceExerciseModel _ex4tokens() => _ex(
      '___ أَذْهَبُ إِلَى المَدْرَسَةِ.',
      '___ أَذْهَبُ إِلَى المَدْرَسَةِ. (Je ne vais pas à l\'école.)',
      ['لَا', 'لَمْ', 'لَنْ'],
      0,
    );

ProviderContainer _container(FakeContentRepository repo) =>
    ProviderContainer(overrides: [
      contentRepositoryProvider.overrideWithValue(repo),
    ]);

void main() {
  group('WordOrderingSessionNotifier', () {
    late FakeContentRepository repo;
    late ProviderContainer container;

    setUp(() {
      repo = FakeContentRepository();
      container = _container(repo);
    });

    tearDown(() => container.dispose());

    test('initial state is null', () {
      expect(container.read(wordOrderingSessionProvider), isNull);
    });

    test('startSession sets null when no eligible sentences (all < 3 tokens)',
        () async {
      repo.exercises = [_ex2tokens(), _ex2tokens()];
      await container
          .read(wordOrderingSessionProvider.notifier)
          .startSession(1);
      expect(container.read(wordOrderingSessionProvider), isNull);
    });

    test('startSession sets null when exercises list is empty', () async {
      repo.exercises = [];
      await container
          .read(wordOrderingSessionProvider.notifier)
          .startSession(1);
      expect(container.read(wordOrderingSessionProvider), isNull);
    });

    test('startSession builds session when eligible sentences exist', () async {
      repo.exercises = [_ex3tokens()];
      await container
          .read(wordOrderingSessionProvider.notifier)
          .startSession(1);
      final s = container.read(wordOrderingSessionProvider);
      expect(s, isNotNull);
      expect(s!.totalSentences, 1);
      expect(s.currentIndex, 0);
      expect(s.placedIds, isEmpty);
      expect(s.isAnswerCorrect, isNull);
      expect(s.isCompleted, isFalse);
    });

    test('startSession caps at 5 sentences when more are available', () async {
      repo.exercises = List.generate(8, (_) => _ex3tokens());
      await container
          .read(wordOrderingSessionProvider.notifier)
          .startSession(1);
      final s = container.read(wordOrderingSessionProvider);
      expect(s!.totalSentences, 5);
    });

    test('startSession filters out sentences with < 3 tokens', () async {
      repo.exercises = [_ex2tokens(), _ex3tokens(), _ex2tokens()];
      await container
          .read(wordOrderingSessionProvider.notifier)
          .startSession(1);
      final s = container.read(wordOrderingSessionProvider);
      expect(s!.totalSentences, 1);
    });

    test('tapToken places token at end of placedIds', () async {
      repo.exercises = [_ex3tokens()];
      await container
          .read(wordOrderingSessionProvider.notifier)
          .startSession(1);
      final notifier = container.read(wordOrderingSessionProvider.notifier);
      final s = container.read(wordOrderingSessionProvider)!;
      final firstTokenId = s.availableTokens.first.id;

      notifier.tapToken(firstTokenId);

      final after = container.read(wordOrderingSessionProvider)!;
      expect(after.placedIds, [firstTokenId]);
      expect(after.isAnswerCorrect, isNull);
    });

    test('tapToken auto-checks when all tokens placed correctly', () async {
      repo.exercises = [_ex3tokens()];
      await container
          .read(wordOrderingSessionProvider.notifier)
          .startSession(1);
      final notifier = container.read(wordOrderingSessionProvider.notifier);
      final s = container.read(wordOrderingSessionProvider)!;

      // Place all tokens in the correct order
      for (final correctText in s.currentSentence.correctTokens) {
        final tok = s.tokens.firstWhere((t) => t.text == correctText);
        notifier.tapToken(tok.id);
      }

      final after = container.read(wordOrderingSessionProvider)!;
      expect(after.isAnswerCorrect, isTrue);
    });

    test('tapToken auto-checks when all tokens placed incorrectly', () async {
      repo.exercises = [_ex3tokens()];
      await container
          .read(wordOrderingSessionProvider.notifier)
          .startSession(1);
      final notifier = container.read(wordOrderingSessionProvider.notifier);
      final s = container.read(wordOrderingSessionProvider)!;

      // Place tokens in reversed-correct order — deterministically wrong
      // because the sentence has 3 unique tokens (أَيْنَ, المَدْرَسَةُ, ؟).
      for (final text in s.currentSentence.correctTokens.reversed.toList()) {
        final tok = s.tokens.firstWhere((t) => t.text == text);
        notifier.tapToken(tok.id);
      }

      expect(
        container.read(wordOrderingSessionProvider)!.isAnswerCorrect,
        isFalse,
      );
    });

    test('removeToken removes placed token and clears isAnswerCorrect',
        () async {
      repo.exercises = [_ex3tokens()];
      await container
          .read(wordOrderingSessionProvider.notifier)
          .startSession(1);
      final notifier = container.read(wordOrderingSessionProvider.notifier);
      final s = container.read(wordOrderingSessionProvider)!;
      final tokenId = s.availableTokens.first.id;

      notifier.tapToken(tokenId);
      expect(container.read(wordOrderingSessionProvider)!.placedIds,
          contains(tokenId));

      notifier.removeToken(tokenId);

      final after = container.read(wordOrderingSessionProvider)!;
      expect(after.placedIds, isNot(contains(tokenId)));
      expect(after.isAnswerCorrect, isNull);
    });

    test('removeToken does nothing when answer is correct', () async {
      repo.exercises = [_ex3tokens()];
      await container
          .read(wordOrderingSessionProvider.notifier)
          .startSession(1);
      final notifier = container.read(wordOrderingSessionProvider.notifier);
      final s = container.read(wordOrderingSessionProvider)!;

      // Place all in correct order to lock
      for (final text in s.currentSentence.correctTokens) {
        notifier.tapToken(s.tokens.firstWhere((t) => t.text == text).id);
      }
      expect(container.read(wordOrderingSessionProvider)!.isAnswerCorrect,
          isTrue);

      final firstPlacedId =
          container.read(wordOrderingSessionProvider)!.placedIds.first;
      notifier.removeToken(firstPlacedId);

      // Should not have changed
      expect(container.read(wordOrderingSessionProvider)!.isAnswerCorrect,
          isTrue);
      expect(container.read(wordOrderingSessionProvider)!.placedIds.first,
          firstPlacedId);
    });

    test('nextSentence advances to next sentence', () async {
      repo.exercises = [_ex3tokens(), _ex4tokens()];
      await container
          .read(wordOrderingSessionProvider.notifier)
          .startSession(1);
      final notifier = container.read(wordOrderingSessionProvider.notifier);

      expect(container.read(wordOrderingSessionProvider)!.currentIndex, 0);

      notifier.nextSentence();

      final after = container.read(wordOrderingSessionProvider)!;
      expect(after.currentIndex, 1);
      expect(after.placedIds, isEmpty);
      expect(after.isAnswerCorrect, isNull);
    });

    test('nextSentence sets isCompleted after last sentence', () async {
      repo.exercises = [_ex3tokens()];
      await container
          .read(wordOrderingSessionProvider.notifier)
          .startSession(1);
      final notifier = container.read(wordOrderingSessionProvider.notifier);

      notifier.nextSentence();

      expect(
          container.read(wordOrderingSessionProvider)!.isCompleted, isTrue);
    });

    test('endSession resets state to null', () async {
      repo.exercises = [_ex3tokens()];
      await container
          .read(wordOrderingSessionProvider.notifier)
          .startSession(1);
      container.read(wordOrderingSessionProvider.notifier).endSession();
      expect(container.read(wordOrderingSessionProvider), isNull);
    });
  });
}
