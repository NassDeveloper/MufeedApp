import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/lesson_model.dart';
import 'package:mufeed_app/domain/models/level_model.dart';
import 'package:mufeed_app/domain/models/unit_model.dart';
import 'package:mufeed_app/domain/models/verb_model.dart';
import 'package:mufeed_app/domain/models/word_model.dart';
import 'package:mufeed_app/domain/repositories/content_repository.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/content_provider.dart';
import 'package:mufeed_app/presentation/screens/quiz_screen.dart';
import 'package:mufeed_app/presentation/widgets/arabic_text_widget.dart';
import 'package:mufeed_app/presentation/widgets/quiz_option_widget.dart';
import 'package:mufeed_app/presentation/widgets/skeleton_loader_widget.dart';

class FakeContentRepository implements ContentRepository {
  List<WordModel> words = [];
  List<VerbModel> verbs = [];
  bool shouldThrow = false;

  @override
  Future<List<WordModel>> getWordsByLessonId(int lessonId) async {
    if (shouldThrow) throw Exception('Database error');
    return words;
  }

  @override
  Future<List<VerbModel>> getVerbsByLessonId(int lessonId) async {
    if (shouldThrow) throw Exception('Database error');
    return verbs;
  }

  @override
  Future<List<LevelModel>> getAllLevels() async => [];

  @override
  Future<List<UnitModel>> getUnitsByLevelId(int levelId) async => [];

  @override
  Future<List<LessonModel>> getLessonsByUnitId(int unitId) async => [];

  @override
  Future<List<LessonModel>> getLessonsByLevelId(int levelId) async => [];
}

WordModel _word(int id, String arabic, String translationFr) => WordModel(
      id: id,
      lessonId: 1,
      contentType: 'vocab',
      arabic: arabic,
      translationFr: translationFr,
      sortOrder: id,
    );

Widget _buildApp(FakeContentRepository repo) {
  return ProviderScope(
    overrides: [
      contentRepositoryProvider.overrideWithValue(repo),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('fr'),
      home: QuizScreen(lessonId: 1),
    ),
  );
}

void main() {
  group('QuizScreen', () {
    testWidgets('shows skeleton loader while loading', (tester) async {
      final repo = FakeContentRepository();
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      await tester.pumpWidget(_buildApp(repo));
      // Don't pumpAndSettle — check during loading
      expect(find.byType(SkeletonListLoader), findsOneWidget);
    });

    testWidgets('shows empty state when fewer than 4 items', (tester) async {
      final repo = FakeContentRepository();
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
      ];

      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      expect(find.text('Aucun exercice disponible'), findsOneWidget);
      expect(
        find.text(
            'Cette leçon nécessite au minimum 4 mots pour lancer un QCM'),
        findsOneWidget,
      );
    });

    testWidgets('shows error state when loading fails', (tester) async {
      final repo = FakeContentRepository();
      repo.shouldThrow = true;

      await tester.pumpWidget(_buildApp(repo));
      // Multiple pumps: first triggers the async start, next ones let the Future complete
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Erreur de chargement du contenu'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);
    });

    testWidgets('shows quiz question with ArabicText and 4 options',
        (tester) async {
      final repo = FakeContentRepository();
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      // Should have ArabicText for the question
      expect(find.byType(ArabicText), findsOneWidget);
      // Should have 4 options
      expect(find.byType(QuizOptionWidget), findsNWidgets(4));
    });

    testWidgets('shows progress in app bar', (tester) async {
      final repo = FakeContentRepository();
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      expect(find.text('Question 1 / 4'), findsOneWidget);
    });

    testWidgets('shows close button with tooltip', (tester) async {
      final repo = FakeContentRepository();
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
      final iconButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.close),
      );
      expect(iconButton.tooltip, isNotNull);
    });

    testWidgets('shows tap to continue after incorrect answer',
        (tester) async {
      final repo = FakeContentRepository();
      repo.words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();

      // Find a wrong option and tap it
      final options = tester.widgetList<QuizOptionWidget>(
        find.byType(QuizOptionWidget),
      );
      // Find the ArabicText to know the current question
      final arabicText = tester.widget<ArabicText>(find.byType(ArabicText));
      final currentArabic = arabicText.text;

      // The correct answer maps to: كتاب->livre, قلم->stylo, باب->porte, نافذة->fenêtre
      final correctMap = {
        'كتاب': 'livre',
        'قلم': 'stylo',
        'باب': 'porte',
        'نافذة': 'fenêtre',
      };
      final correctAnswer = correctMap[currentArabic]!;

      // Find a wrong option
      final wrongOption =
          options.firstWhere((o) => o.text != correctAnswer);

      await tester.tap(find.text(wrongOption.text));
      await tester.pump();
      // Pump through the delayed second haptic feedback
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.text('Appuyez pour continuer'), findsOneWidget);
    });
  });
}
