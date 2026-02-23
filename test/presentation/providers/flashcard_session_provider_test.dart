import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/data/datasources/shared_preferences_source.dart';
import 'package:mufeed_app/domain/models/reviewable_item_model.dart';
import 'package:mufeed_app/domain/models/session_model.dart';
import 'package:mufeed_app/domain/models/user_progress_model.dart';
import 'package:mufeed_app/domain/models/streak_model.dart';
import 'package:mufeed_app/domain/repositories/progress_repository.dart';
import 'package:mufeed_app/domain/repositories/streak_repository.dart';
import 'package:mufeed_app/presentation/providers/flashcard_session_provider.dart';
import 'package:mufeed_app/presentation/providers/preferences_provider.dart';
import 'package:mufeed_app/presentation/providers/srs_provider.dart';
import 'package:mufeed_app/presentation/providers/streak_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeProgressRepository implements ProgressRepository {
  List<ReviewableItemModel> items = [];
  List<UserProgressModel> savedProgress = [];
  List<SessionModel> createdSessions = [];

  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLesson(
          int lessonId) async =>
      items;

  @override
  Future<List<UserProgressModel>> getDueItems() async => [];
  @override
  Future<List<ReviewableItemModel>> getDueReviewableItems() async => [];

  @override
  Future<UserProgressModel?> getProgressForItem(
          int itemId, String contentType) async =>
      null;

  @override
  Future<void> saveProgress(UserProgressModel progress) async {
    savedProgress.add(progress);
  }

  @override
  Future<int> createSession(SessionModel session) async {
    createdSessions.add(session);
    return 1;
  }

  @override
  Future<Map<String, int>> getProgressCountsByState() async => {};

  @override
  Future<int> getTotalItemCount() async => 0;

  @override
  Future<int> getSessionCount() async => 0;

  @override
  Future<List<UserProgressModel>> getProgressForLesson(int lessonId) async =>
      [];

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
  Future<DateTime?> getLastActivityDate() async => DateTime.now();
  @override
  Future<void> updateLastActivityDate(DateTime date) async {}
  @override
  Future<void> updateStreak(StreakModel streak) async {}
}

void main() {
  late ProviderContainer container;
  late FakeProgressRepository fakeRepo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    fakeRepo = FakeProgressRepository();
    fakeRepo.items = [
      const ReviewableItemModel(
        itemId: 1,
        contentType: 'vocab',
        arabic: 'كتاب',
        translationFr: 'livre',
        sortOrder: 1,
      ),
      const ReviewableItemModel(
        itemId: 2,
        contentType: 'vocab',
        arabic: 'قلم',
        translationFr: 'stylo',
        sortOrder: 2,
      ),
      const ReviewableItemModel(
        itemId: 3,
        contentType: 'verb',
        arabic: 'كِتَابَة',
        translationFr: 'ecrire',
        sortOrder: 3,
        verbPast: 'كَتَبَ',
        verbPresent: 'يَكْتُبُ',
        verbImperative: 'اُكْتُبْ',
      ),
    ];

    container = ProviderContainer(
      overrides: [
        progressRepositoryProvider.overrideWithValue(fakeRepo),
        sharedPreferencesSourceProvider
            .overrideWithValue(SharedPreferencesSource(prefs)),
        streakRepositoryProvider.overrideWithValue(FakeStreakRepository()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('FlashcardSessionNotifier', () {
    test('initial state is null', () {
      final state = container.read(flashcardSessionProvider);
      expect(state, isNull);
    });

    test('startSession loads items and sets state', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      final state = container.read(flashcardSessionProvider);
      expect(state, isNotNull);
      expect(state!.items, hasLength(3));
      expect(state.currentIndex, 0);
      expect(state.isFlipped, false);
      expect(state.lessonId, 1);
    });

    test('startSession with empty items does not set state', () async {
      fakeRepo.items = [];
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      final state = container.read(flashcardSessionProvider);
      expect(state, isNull);
    });

    test('flipCard toggles isFlipped', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      notifier.flipCard();
      expect(container.read(flashcardSessionProvider)!.isFlipped, true);

      notifier.flipCard();
      expect(container.read(flashcardSessionProvider)!.isFlipped, false);
    });

    test('nextCard advances index and resets flip', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);
      notifier.flipCard();

      notifier.nextCard();
      final state = container.read(flashcardSessionProvider)!;
      expect(state.currentIndex, 1);
      expect(state.isFlipped, false);
    });

    test('nextCard does nothing on last card', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      notifier.goToPage(2);
      notifier.nextCard();
      expect(container.read(flashcardSessionProvider)!.currentIndex, 2);
    });

    test('previousCard goes back and resets flip', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);
      notifier.nextCard();
      notifier.flipCard();

      notifier.previousCard();
      final state = container.read(flashcardSessionProvider)!;
      expect(state.currentIndex, 0);
      expect(state.isFlipped, false);
    });

    test('previousCard does nothing on first card', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      notifier.previousCard();
      expect(container.read(flashcardSessionProvider)!.currentIndex, 0);
    });

    test('goToPage navigates to specific index', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      notifier.goToPage(2);
      expect(container.read(flashcardSessionProvider)!.currentIndex, 2);
      expect(
          container.read(flashcardSessionProvider)!.currentItem.contentType,
          'verb');
    });

    test('goToPage ignores invalid indices', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      notifier.goToPage(-1);
      expect(container.read(flashcardSessionProvider)!.currentIndex, 0);

      notifier.goToPage(99);
      expect(container.read(flashcardSessionProvider)!.currentIndex, 0);
    });

    test('endSession clears state', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      notifier.endSession();
      expect(container.read(flashcardSessionProvider), isNull);
    });

    test('currentItem returns correct item', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      expect(
          container.read(flashcardSessionProvider)!.currentItem.arabic,
          'كتاب');

      notifier.nextCard();
      expect(
          container.read(flashcardSessionProvider)!.currentItem.arabic,
          'قلم');
    });

    test('isFirst and isLast are correct', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      expect(container.read(flashcardSessionProvider)!.isFirst, true);
      expect(container.read(flashcardSessionProvider)!.isLast, false);

      notifier.goToPage(2);
      expect(container.read(flashcardSessionProvider)!.isFirst, false);
      expect(container.read(flashcardSessionProvider)!.isLast, true);
    });

    test('session saves position to SharedPreferences', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);
      notifier.nextCard();

      final prefs = container.read(sharedPreferencesSourceProvider);
      expect(prefs.getFlashcardSessionLessonId(), 1);
      expect(prefs.getFlashcardSessionIndex(), 1);
    });

    test('endSession clears SharedPreferences', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);
      notifier.endSession();

      final prefs = container.read(sharedPreferencesSourceProvider);
      expect(prefs.getFlashcardSessionLessonId(), isNull);
      expect(prefs.getFlashcardSessionIndex(), isNull);
    });

    test('startSession with startIndex resumes at given position', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1, startIndex: 1);

      expect(container.read(flashcardSessionProvider)!.currentIndex, 1);
    });

    test('rateCard saves progress via repository', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      await notifier.rateCard(3);

      expect(fakeRepo.savedProgress, hasLength(1));
      expect(fakeRepo.savedProgress.first.itemId, 1);
      expect(fakeRepo.savedProgress.first.contentType, 'vocab');
    });

    test('rateCard advances to next card', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      await notifier.rateCard(3);

      final state = container.read(flashcardSessionProvider)!;
      expect(state.currentIndex, 1);
      expect(state.isFlipped, false);
    });

    test('rateCard updates rating counts', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      await notifier.rateCard(1);
      await notifier.rateCard(3);

      final state = container.read(flashcardSessionProvider)!;
      expect(state.ratingCounts[1], 1);
      expect(state.ratingCounts[3], 1);
      expect(state.evaluatedCount, 2);
    });

    test('rateCard on last card completes session', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      // Rate all 3 cards
      await notifier.rateCard(4);
      await notifier.rateCard(3);
      await notifier.rateCard(2);

      final state = container.read(flashcardSessionProvider)!;
      expect(state.isCompleted, true);
      expect(state.ratingCounts[4], 1);
      expect(state.ratingCounts[3], 1);
      expect(state.ratingCounts[2], 1);
      expect(state.evaluatedCount, 3);
    });

    test('completed session creates session record', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      await notifier.rateCard(4);
      await notifier.rateCard(3);
      await notifier.rateCard(2);

      expect(fakeRepo.createdSessions, hasLength(1));
      expect(fakeRepo.createdSessions.first.sessionType, 'flashcard');
      expect(fakeRepo.createdSessions.first.itemsReviewed, 3);
      expect(fakeRepo.createdSessions.first.resultsJson, isNotNull);
    });

    test('rateCard does nothing when session is completed', () async {
      final notifier =
          container.read(flashcardSessionProvider.notifier);
      await notifier.startSession(1);

      await notifier.rateCard(4);
      await notifier.rateCard(3);
      await notifier.rateCard(2);

      // Session is now completed, additional rating should be ignored
      await notifier.rateCard(1);
      expect(fakeRepo.savedProgress, hasLength(3));
    });
  });
}
