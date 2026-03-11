import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/data/datasources/shared_preferences_source.dart';
import 'package:mufeed_app/domain/models/reviewable_item_model.dart';
import 'package:mufeed_app/domain/models/session_model.dart';
import 'package:mufeed_app/domain/models/user_progress_model.dart';
import 'package:mufeed_app/domain/repositories/progress_repository.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/daily_session_provider.dart';
import 'package:mufeed_app/presentation/providers/preferences_provider.dart';
import 'package:mufeed_app/presentation/providers/srs_provider.dart';
import 'package:mufeed_app/presentation/screens/daily_session_screen.dart';
import 'package:mufeed_app/presentation/widgets/skeleton_loader_widget.dart';
import 'package:mufeed_app/domain/models/daily_activity_model.dart';
import 'package:mufeed_app/domain/models/upcoming_reviews_model.dart';

class FakeProgressRepository implements ProgressRepository {
  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLesson(
          int lessonId) async =>
      [];

  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLessons(List<int> lessonIds) async => [];

  @override
  Future<List<UserProgressModel>> getDueItems() async => [];
  @override
  Future<List<ReviewableItemModel>> getDueReviewableItems() async => [];

  @override
  Future<UserProgressModel?> getProgressForItem(
          int itemId, String contentType) async =>
      null;

  @override
  Future<void> saveProgress(UserProgressModel progress) async {}

  @override
  Future<int> createSession(SessionModel session) async => 1;

  @override
  Future<Map<String, int>> getProgressCountsByState() async => {};

  @override
  Future<Map<String, Map<String, int>>>
      getProgressCountsByStateAndType() async => {};

  @override
  Future<int> getTotalWordCount() async => 0;

  @override
  Future<int> getTotalVerbCount() async => 0;

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

  @override
  Future<List<DailyActivityModel>> getReviewActivity({int days = 14}) async => [];
  @override
  Future<UpcomingReviewsModel> getUpcomingReviews() async =>
      const UpcomingReviewsModel(dueToday: 0, dueTomorrow: 0, dueThisWeek: 0);

  @override
  Future<List<ReviewableItemModel>> getNewWordsForLevel(int levelId, int limit) =>
      Future.value([]);

  @override
  Future<({int lessonId, int totalItems, int masteredCount})>
      getLessonProgressSummary(int lessonId) =>
      Future.value((lessonId: lessonId, totalItems: 0, masteredCount: 0));
  @override
  Future<int> getNewWordsIntroducedTodayCount() => Future.value(0);

}

class FakeSharedPreferencesSource implements SharedPreferencesSource {
  @override
  int getContentVersion() => 0;

  @override
  Future<void> setContentVersion(int version) async {}

  @override
  int? getLastVisitedLessonId() => null;

  @override
  String? getLastVisitedLessonName() => null;

  @override
  String? getLastVisitedLessonRoute() => null;

  @override
  Future<void> setLastVisitedLesson({
    required int lessonId,
    required String lessonName,
    required String route,
  }) async {}

  @override
  int? getFlashcardSessionLessonId() => null;

  @override
  int? getFlashcardSessionIndex() => null;

  @override
  Future<void> saveFlashcardSession({
    required int lessonId,
    required int index,
  }) async {}

  @override
  Future<void> clearFlashcardSession() async {}

  @override
  bool isOnboardingCompleted() => false;

  @override
  Future<void> setOnboardingCompleted(bool completed) async {}

  @override
  String? getLearningMode() => null;

  @override
  Future<void> setLearningMode(String mode) async {}

  @override
  int? getActiveLevelId() => null;

  @override
  Future<void> setActiveLevelId(int levelId) async {}

  @override
  int? getActiveLessonId() => null;

  @override
  Future<void> setActiveLessonId(int lessonId) async {}

  @override
  String? getLocale() => null;

  @override
  Future<void> setLocale(String locale) async {}

  @override
  String? getThemeMode() => null;

  @override
  Future<void> setThemeMode(String mode) async {}

  @override
  bool? getGdprConsent() => null;

  @override
  Future<void> setGdprConsent(bool consent) async {}

  @override
  bool isNotificationEnabled() => false;

  @override
  Future<void> setNotificationEnabled(bool enabled) async {}

  @override
  int getNotificationHour() => 9;

  @override
  Future<void> setNotificationHour(int hour) async {}

  @override
  int getNotificationMinute() => 0;

  @override
  Future<void> setNotificationMinute(int minute) async {}

  @override
  int getNewWordsPerDay() => 5;

  @override
  Future<void> setNewWordsPerDay(int value) async {}

  @override
  Future<void> clearActiveLessonId() async {}
}

Widget _buildApp({List<ReviewableItemModel> dailyItems = const []}) {
  return ProviderScope(
    overrides: [
      dailySessionProvider.overrideWith((ref) async => dailyItems),
      progressRepositoryProvider
          .overrideWithValue(FakeProgressRepository()),
      sharedPreferencesSourceProvider
          .overrideWithValue(FakeSharedPreferencesSource()),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('fr'),
      home: DailySessionScreen(),
    ),
  );
}

void main() {
  group('DailySessionScreen', () {
    testWidgets('shows skeleton loader while loading', (tester) async {
      await tester.pumpWidget(_buildApp());
      // Don't pumpAndSettle — check during loading
      expect(find.byType(SkeletonListLoader), findsOneWidget);
    });

    testWidgets('shows empty state when no items', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(
        find.text('Aucun mot à réviser'),
        findsOneWidget,
      );
    });

    testWidgets('shows close button', (tester) async {
      await tester.pumpWidget(_buildApp());
      // Check during loading state (close button is in appBar)
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}
