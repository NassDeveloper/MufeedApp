import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/dialogue_model.dart';
import 'package:mufeed_app/domain/repositories/dialogue_repository.dart';
import 'package:mufeed_app/presentation/providers/dialogue_provider.dart';
import 'package:mufeed_app/presentation/providers/dialogue_session_provider.dart';

class FakeDialogueRepository implements DialogueRepository {
  List<DialogueModel> dialogues = [];

  @override
  Future<List<DialogueModel>> getDialoguesByLessonId(int lessonId) async =>
      dialogues;
}

/// A dialogue with one blank turn (turn index 1).
DialogueModel _dialogue({int id = 1, String title = 'Test'}) {
  return DialogueModel(
    id: id,
    lessonId: 1,
    titleFr: title,
    turns: const [
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

ProviderContainer _container(FakeDialogueRepository repo) =>
    ProviderContainer(overrides: [
      dialogueRepositoryProvider.overrideWithValue(repo),
    ]);

void main() {
  group('DialogueSessionNotifier', () {
    test('initial state is null', () {
      final container = _container(FakeDialogueRepository());
      expect(container.read(dialogueSessionProvider), isNull);
    });

    test('startSession with empty list leaves state null', () async {
      final repo = FakeDialogueRepository();
      final container = _container(repo);
      await container
          .read(dialogueSessionProvider.notifier)
          .startSession(1);
      expect(container.read(dialogueSessionProvider), isNull);
    });

    test('startSession with dialogues sets state', () async {
      final repo = FakeDialogueRepository()..dialogues = [_dialogue()];
      final container = _container(repo);
      await container
          .read(dialogueSessionProvider.notifier)
          .startSession(1);
      final state = container.read(dialogueSessionProvider);
      expect(state, isNotNull);
      expect(state!.currentIndex, 0);
      expect(state.answers, isEmpty);
      expect(state.isCompleted, isFalse);
    });

    test('startSession caps at _kMaxDialogues (3)', () async {
      final repo = FakeDialogueRepository()
        ..dialogues = [
          _dialogue(id: 1),
          _dialogue(id: 2),
          _dialogue(id: 3),
          _dialogue(id: 4),
          _dialogue(id: 5),
        ];
      final container = _container(repo);
      await container
          .read(dialogueSessionProvider.notifier)
          .startSession(1);
      expect(container.read(dialogueSessionProvider)!.totalDialogues,
          lessThanOrEqualTo(3));
    });

    test('selectAnswer records answer', () async {
      final repo = FakeDialogueRepository()..dialogues = [_dialogue()];
      final container = _container(repo);
      await container
          .read(dialogueSessionProvider.notifier)
          .startSession(1);
      container
          .read(dialogueSessionProvider.notifier)
          .selectAnswer(1, 0);
      final state = container.read(dialogueSessionProvider)!;
      expect(state.answers[1], 0);
    });

    test('selectAnswer is ignored if turn already answered', () async {
      final repo = FakeDialogueRepository()..dialogues = [_dialogue()];
      final container = _container(repo);
      await container
          .read(dialogueSessionProvider.notifier)
          .startSession(1);
      container
          .read(dialogueSessionProvider.notifier)
          .selectAnswer(1, 0);
      container
          .read(dialogueSessionProvider.notifier)
          .selectAnswer(1, 2); // attempt to overwrite
      expect(container.read(dialogueSessionProvider)!.answers[1], 0);
    });

    test('isTurnCorrect returns null for non-blank turns', () async {
      final repo = FakeDialogueRepository()..dialogues = [_dialogue()];
      final container = _container(repo);
      await container
          .read(dialogueSessionProvider.notifier)
          .startSession(1);
      expect(
          container.read(dialogueSessionProvider)!.isTurnCorrect(0), isNull);
    });

    test('isTurnCorrect returns null when blank not yet answered', () async {
      final repo = FakeDialogueRepository()..dialogues = [_dialogue()];
      final container = _container(repo);
      await container
          .read(dialogueSessionProvider.notifier)
          .startSession(1);
      expect(
          container.read(dialogueSessionProvider)!.isTurnCorrect(1), isNull);
    });

    test('isTurnCorrect returns true when correct answer given', () async {
      final repo = FakeDialogueRepository()..dialogues = [_dialogue()];
      final container = _container(repo);
      await container
          .read(dialogueSessionProvider.notifier)
          .startSession(1);
      container
          .read(dialogueSessionProvider.notifier)
          .selectAnswer(1, 0); // correct_index = 0
      expect(
          container.read(dialogueSessionProvider)!.isTurnCorrect(1), isTrue);
    });

    test('isTurnCorrect returns false when wrong answer given', () async {
      final repo = FakeDialogueRepository()..dialogues = [_dialogue()];
      final container = _container(repo);
      await container
          .read(dialogueSessionProvider.notifier)
          .startSession(1);
      container
          .read(dialogueSessionProvider.notifier)
          .selectAnswer(1, 2); // wrong
      expect(
          container.read(dialogueSessionProvider)!.isTurnCorrect(1), isFalse);
    });

    test('allBlanksAnswered is false before answering', () async {
      final repo = FakeDialogueRepository()..dialogues = [_dialogue()];
      final container = _container(repo);
      await container
          .read(dialogueSessionProvider.notifier)
          .startSession(1);
      expect(
          container.read(dialogueSessionProvider)!.allBlanksAnswered, isFalse);
    });

    test('allBlanksAnswered is true after answering blank', () async {
      final repo = FakeDialogueRepository()..dialogues = [_dialogue()];
      final container = _container(repo);
      await container
          .read(dialogueSessionProvider.notifier)
          .startSession(1);
      container
          .read(dialogueSessionProvider.notifier)
          .selectAnswer(1, 0);
      expect(
          container.read(dialogueSessionProvider)!.allBlanksAnswered, isTrue);
    });

    test('nextDialogue advances to next dialogue and resets answers', () async {
      final repo = FakeDialogueRepository()
        ..dialogues = [_dialogue(id: 1), _dialogue(id: 2)];
      final container = _container(repo);
      await container
          .read(dialogueSessionProvider.notifier)
          .startSession(1);
      container
          .read(dialogueSessionProvider.notifier)
          .selectAnswer(1, 0);
      container.read(dialogueSessionProvider.notifier).nextDialogue();
      final state = container.read(dialogueSessionProvider)!;
      expect(state.currentIndex, 1);
      expect(state.answers, isEmpty);
      expect(state.isCompleted, isFalse);
    });

    test('nextDialogue on last dialogue sets isCompleted', () async {
      final repo = FakeDialogueRepository()..dialogues = [_dialogue()];
      final container = _container(repo);
      await container
          .read(dialogueSessionProvider.notifier)
          .startSession(1);
      container.read(dialogueSessionProvider.notifier).nextDialogue();
      expect(
          container.read(dialogueSessionProvider)!.isCompleted, isTrue);
    });

    test('endSession resets state to null', () async {
      final repo = FakeDialogueRepository()..dialogues = [_dialogue()];
      final container = _container(repo);
      await container
          .read(dialogueSessionProvider.notifier)
          .startSession(1);
      container.read(dialogueSessionProvider.notifier).endSession();
      expect(container.read(dialogueSessionProvider), isNull);
    });
  });
}
