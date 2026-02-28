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
import 'package:mufeed_app/presentation/providers/matching_session_provider.dart';

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
  Future<List<SentenceExerciseModel>> getExercisesForLesson(
          int lessonId) async =>
      [];
}

WordModel _word(int id, String arabic, String fr, {int sortOrder = 1}) =>
    WordModel(
      id: id,
      lessonId: 1,
      contentType: 'vocab',
      arabic: arabic,
      translationFr: fr,
      sortOrder: sortOrder,
    );

VerbModel _verb(int id, String past, String fr) => VerbModel(
      id: id,
      lessonId: 1,
      contentType: 'verb',
      masdar: 'مَصدَر',
      past: past,
      present: 'يَفعَل',
      imperative: 'افعَل',
      translationFr: fr,
      sortOrder: 10,
    );

ProviderContainer _container(FakeContentRepository repo) =>
    ProviderContainer(overrides: [
      contentRepositoryProvider.overrideWithValue(repo),
    ]);

void main() {
  group('MatchingSessionNotifier', () {
    late FakeContentRepository repo;
    late ProviderContainer container;

    setUp(() {
      repo = FakeContentRepository();
      container = _container(repo);
    });

    tearDown(() => container.dispose());

    test('initial state is null', () {
      expect(container.read(matchingSessionProvider), isNull);
    });

    test('startSession sets state to null when fewer than 4 items', () async {
      repo.words = [_word(1, 'كتاب', 'livre'), _word(2, 'قلم', 'stylo')];
      await container.read(matchingSessionProvider.notifier).startSession(1);
      expect(container.read(matchingSessionProvider), isNull);
    });

    test('startSession builds session when 4+ words available', () async {
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'بيت', 'maison'),
      ];
      await container.read(matchingSessionProvider.notifier).startSession(1);
      final s = container.read(matchingSessionProvider);
      expect(s, isNotNull);
      expect(s!.totalPairs, 4);
      expect(s.matchedCount, 0);
      expect(s.isCompleted, isFalse);
    });

    test('startSession caps at 6 pairs when more items available', () async {
      repo.words = List.generate(
          10, (i) => _word(i + 1, 'كلمة$i', 'mot$i', sortOrder: i));
      await container.read(matchingSessionProvider.notifier).startSession(1);
      final s = container.read(matchingSessionProvider);
      expect(s!.totalPairs, 6);
    });

    test('startSession uses past tense for verbs (not masdar)', () async {
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
      ];
      repo.verbs = [_verb(10, 'كَتَبَ', 'ecrire')];
      await container.read(matchingSessionProvider.notifier).startSession(1);
      final s = container.read(matchingSessionProvider);
      expect(s, isNotNull);
      final verbPair =
          s!.pairs.firstWhere((p) => p.contentType == 'verb');
      expect(verbPair.arabic, 'كَتَبَ');
    });

    test('tapArabic selects card', () async {
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'بيت', 'maison'),
      ];
      await container.read(matchingSessionProvider.notifier).startSession(1);
      final notifier = container.read(matchingSessionProvider.notifier);
      notifier.tapArabic(0);
      expect(container.read(matchingSessionProvider)!.selectedArabicPairId, 0);
    });

    test('tapArabic deselects when tapped again', () async {
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'بيت', 'maison'),
      ];
      await container.read(matchingSessionProvider.notifier).startSession(1);
      final notifier = container.read(matchingSessionProvider.notifier);
      notifier.tapArabic(0);
      notifier.tapArabic(0);
      expect(container.read(matchingSessionProvider)!.selectedArabicPairId,
          isNull);
    });

    test('correct match marks pair as matched and clears selection', () async {
      // Use fixed words so we can predict pairIds
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'بيت', 'maison'),
      ];
      await container.read(matchingSessionProvider.notifier).startSession(1);
      final notifier = container.read(matchingSessionProvider.notifier);
      final s = container.read(matchingSessionProvider)!;

      // Find the french slot index that corresponds to pairId 0
      final frenchSlot = s.frenchOrder.indexOf(0);

      notifier.tapArabic(0);
      notifier.tapFrench(frenchSlot);

      final after = container.read(matchingSessionProvider)!;
      expect(after.pairs[0].isMatched, isTrue);
      expect(after.matchedCount, 1);
      expect(after.selectedArabicPairId, isNull);
      expect(after.selectedFrenchPairId, isNull);
    });

    test('wrong match triggers flashing state', () async {
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'بيت', 'maison'),
      ];
      await container.read(matchingSessionProvider.notifier).startSession(1);
      final notifier = container.read(matchingSessionProvider.notifier);
      final s = container.read(matchingSessionProvider)!;

      // Find a french slot that does NOT correspond to pairId 0
      final wrongSlot = s.frenchOrder.indexWhere((idx) => idx != 0);

      notifier.tapArabic(0);
      notifier.tapFrench(wrongSlot);

      final after = container.read(matchingSessionProvider)!;
      expect(after.flashingPairIds, isNotEmpty);
      expect(after.selectedArabicPairId, isNull);
      expect(after.selectedFrenchPairId, isNull);
      expect(after.pairs.every((p) => !p.isMatched), isTrue);
    });

    test('flash clears after delay', () async {
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'بيت', 'maison'),
      ];
      await container.read(matchingSessionProvider.notifier).startSession(1);
      final notifier = container.read(matchingSessionProvider.notifier);
      final s = container.read(matchingSessionProvider)!;
      final wrongSlot = s.frenchOrder.indexWhere((idx) => idx != 0);

      notifier.tapArabic(0);
      notifier.tapFrench(wrongSlot);
      expect(
          container.read(matchingSessionProvider)!.flashingPairIds, isNotEmpty);

      await Future.delayed(const Duration(milliseconds: 700));
      expect(
          container.read(matchingSessionProvider)!.flashingPairIds, isEmpty);
    });

    test('matching all pairs sets isCompleted to true', () async {
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'بيت', 'maison'),
      ];
      await container.read(matchingSessionProvider.notifier).startSession(1);
      final notifier = container.read(matchingSessionProvider.notifier);

      // Match all pairs in order
      for (var pairId = 0; pairId < 4; pairId++) {
        final s = container.read(matchingSessionProvider)!;
        final frenchSlot = s.frenchOrder.indexOf(pairId);
        notifier.tapArabic(pairId);
        notifier.tapFrench(frenchSlot);
      }

      expect(container.read(matchingSessionProvider)!.isCompleted, isTrue);
    });

    test('endSession resets state to null', () async {
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'بيت', 'maison'),
      ];
      await container.read(matchingSessionProvider.notifier).startSession(1);
      container.read(matchingSessionProvider.notifier).endSession();
      expect(container.read(matchingSessionProvider), isNull);
    });
  });
}
