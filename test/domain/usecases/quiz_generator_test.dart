import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/verb_model.dart';
import 'package:mufeed_app/domain/models/word_model.dart';
import 'package:mufeed_app/domain/usecases/quiz_generator.dart';

WordModel _word(int id, String arabic, String translationFr) => WordModel(
      id: id,
      lessonId: 1,
      contentType: 'vocab',
      arabic: arabic,
      translationFr: translationFr,
      sortOrder: id,
    );

VerbModel _verb(int id, String masdar, String translationFr) => VerbModel(
      id: id,
      lessonId: 1,
      contentType: 'verb',
      masdar: masdar,
      past: 'past',
      present: 'present',
      imperative: 'imp',
      translationFr: translationFr,
      sortOrder: id,
    );

void main() {
  late QuizGenerator generator;

  setUp(() {
    generator = QuizGenerator(random: Random(42));
  });

  group('QuizGenerator', () {
    test('returns empty list when fewer than 4 items', () {
      final words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
      ];

      final questions =
          generator.generateQuestions(words: words, verbs: []);

      expect(questions, isEmpty);
    });

    test('generates one question per item', () {
      final words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      final questions =
          generator.generateQuestions(words: words, verbs: []);

      expect(questions.length, 4);
    });

    test('correct answer is always present in choices', () {
      final words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
        _word(5, 'كرسي', 'chaise'),
      ];

      final questions =
          generator.generateQuestions(words: words, verbs: []);

      for (final q in questions) {
        expect(q.choices, contains(q.correctAnswer));
      }
    });

    test('each question has exactly 4 choices', () {
      final words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
        _word(5, 'كرسي', 'chaise'),
      ];

      final questions =
          generator.generateQuestions(words: words, verbs: []);

      for (final q in questions) {
        expect(q.choices.length, 4);
      }
    });

    test('no duplicate choices in a question', () {
      final words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
        _word(5, 'كرسي', 'chaise'),
      ];

      final questions =
          generator.generateQuestions(words: words, verbs: []);

      for (final q in questions) {
        expect(q.choices.toSet().length, q.choices.length,
            reason: 'Choices should not have duplicates');
      }
    });

    test('includes both words and verbs', () {
      final words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
      ];
      final verbs = [
        _verb(1, 'كَتَبَ', 'écrire'),
        _verb(2, 'قَرَأَ', 'lire'),
      ];

      final questions =
          generator.generateQuestions(words: words, verbs: verbs);

      expect(questions.length, 4);
      final contentTypes = questions.map((q) => q.contentType).toSet();
      expect(contentTypes, containsAll(['vocab', 'verb']));
    });

    test('preserves item metadata', () {
      final words = [
        _word(10, 'كتاب', 'livre'),
        _word(20, 'قلم', 'stylo'),
        _word(30, 'باب', 'porte'),
        _word(40, 'نافذة', 'fenêtre'),
      ];

      final questions =
          generator.generateQuestions(words: words, verbs: []);

      final itemIds = questions.map((q) => q.itemId).toSet();
      expect(itemIds, containsAll([10, 20, 30, 40]));
    });

    test('questions are shuffled', () {
      final words = List.generate(
        10,
        (i) => _word(i + 1, 'عربي$i', 'traduction$i'),
      );

      final questions1 =
          QuizGenerator(random: Random(1))
              .generateQuestions(words: words, verbs: []);
      final questions2 =
          QuizGenerator(random: Random(2))
              .generateQuestions(words: words, verbs: []);

      final arabics1 = questions1.map((q) => q.arabic).toList();
      final arabics2 = questions2.map((q) => q.arabic).toList();

      // With different seeds, order should differ
      expect(arabics1, isNot(equals(arabics2)));
    });

    test('exact minimum of 4 items works', () {
      final words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      final questions =
          generator.generateQuestions(words: words, verbs: []);

      expect(questions.length, 4);
      for (final q in questions) {
        expect(q.choices.length, 4);
        expect(q.choices, contains(q.correctAnswer));
      }
    });

    test('returns empty when duplicate translations reduce unique pool below 4',
        () {
      final words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'مجلد', 'livre'), // same translation as word 1
        _word(3, 'قلم', 'stylo'),
        _word(4, 'باب', 'porte'),
      ];

      final questions =
          generator.generateQuestions(words: words, verbs: []);

      // 4 items but only 3 unique translations → not enough for distractors
      expect(questions, isEmpty);
    });

    test('choices list is unmodifiable', () {
      final words = [
        _word(1, 'كتاب', 'livre'),
        _word(2, 'قلم', 'stylo'),
        _word(3, 'باب', 'porte'),
        _word(4, 'نافذة', 'fenêtre'),
      ];

      final questions =
          generator.generateQuestions(words: words, verbs: []);

      expect(
        () => questions.first.choices.add('extra'),
        throwsUnsupportedError,
      );
    });
  });
}
