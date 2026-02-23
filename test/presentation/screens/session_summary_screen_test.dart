import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/reviewable_item_model.dart';
import 'package:mufeed_app/domain/models/session_model.dart';
import 'package:mufeed_app/domain/models/user_progress_model.dart';
import 'package:mufeed_app/domain/repositories/progress_repository.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/srs_provider.dart';
import 'package:mufeed_app/presentation/screens/session_summary_screen.dart';

class FakeProgressRepository implements ProgressRepository {
  @override
  Future<List<ReviewableItemModel>> getReviewableItemsForLesson(
          int lessonId) async =>
      [];

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

void main() {
  group('SessionSummaryScreen', () {
    Widget buildScreen() {
      return ProviderScope(
        overrides: [
          progressRepositoryProvider
              .overrideWithValue(FakeProgressRepository()),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('fr'),
          home: SessionSummaryScreen(lessonId: 1),
        ),
      );
    }

    testWidgets('displays summary title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Résumé'), findsOneWidget);
    });

    testWidgets('displays items reviewed count', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // When session is null, totalItems = 0
      // The plural form text should be present
      expect(find.textContaining('révisé'), findsOneWidget);
    });

    testWidgets('displays rating labels', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('À revoir'), findsOneWidget);
      expect(find.text('Difficile'), findsOneWidget);
      expect(find.text('Bien'), findsOneWidget);
      expect(find.text('Facile'), findsOneWidget);
    });

    testWidgets('displays action buttons', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Retour à la leçon'), findsOneWidget);
      expect(find.text('Relancer une session'), findsOneWidget);
    });

    testWidgets('displays FilledButton and OutlinedButton', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });
}
