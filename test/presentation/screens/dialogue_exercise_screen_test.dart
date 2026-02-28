import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/dialogue_model.dart';
import 'package:mufeed_app/domain/repositories/dialogue_repository.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/dialogue_provider.dart';
import 'package:mufeed_app/presentation/screens/dialogue_exercise_screen.dart';
import 'package:mufeed_app/presentation/widgets/skeleton_loader_widget.dart';

class FakeDialogueRepository implements DialogueRepository {
  List<DialogueModel> dialogues = [];

  @override
  Future<List<DialogueModel>> getDialoguesByLessonId(int lessonId) async =>
      dialogues;
}

DialogueModel _dialogue() {
  return const DialogueModel(
    id: 1,
    lessonId: 1,
    titleFr: 'Qui est-ce ?',
    turns: [
      DialogueTurn(
        speaker: 'A',
        arabic: 'مَنْ هَذَا ؟',
        translationFr: 'Qui est-ce ?',
      ),
      DialogueTurn(
        speaker: 'B',
        arabic: '___',
        translationFr: "C'est un ingénieur.",
        choices: ['هُوَ مُهَنْدِسٌ.', 'هِيَ مُعَلِّمَةٌ.', 'أَنَا طَبِيبٌ.'],
        correctIndex: 0,
      ),
    ],
  );
}

Widget _buildApp(FakeDialogueRepository repo) => ProviderScope(
      overrides: [
        dialogueRepositoryProvider.overrideWithValue(repo),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: DialogueExerciseScreen(lessonId: 1),
      ),
    );

void main() {
  group('DialogueExerciseScreen', () {
    testWidgets('shows skeleton loader while loading', (tester) async {
      final repo = FakeDialogueRepository();
      await tester.pumpWidget(_buildApp(repo));
      expect(find.byType(SkeletonListLoader), findsOneWidget);
    });

    testWidgets('shows empty state when no dialogues', (tester) async {
      final repo = FakeDialogueRepository();
      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();
      expect(find.text('Aucun dialogue disponible'), findsOneWidget);
    });

    testWidgets('shows dialogue title when session loaded', (tester) async {
      final repo = FakeDialogueRepository()..dialogues = [_dialogue()];
      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();
      expect(find.text('Qui est-ce ?'), findsWidgets);
    });

    testWidgets('shows MCQ choices for blank turn', (tester) async {
      final repo = FakeDialogueRepository()..dialogues = [_dialogue()];
      await tester.pumpWidget(_buildApp(repo));
      await tester.pumpAndSettle();
      expect(find.text('هُوَ مُهَنْدِسٌ.'), findsOneWidget);
      expect(find.text('هِيَ مُعَلِّمَةٌ.'), findsOneWidget);
      expect(find.text('أَنَا طَبِيبٌ.'), findsOneWidget);
    });

    testWidgets('shows close button in app bar', (tester) async {
      final repo = FakeDialogueRepository();
      await tester.pumpWidget(_buildApp(repo));
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}
