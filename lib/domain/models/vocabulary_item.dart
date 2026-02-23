import 'verb_model.dart';
import 'word_model.dart';

sealed class VocabularyItem {
  int get sortOrder;
}

class WordItem extends VocabularyItem {
  WordItem(this.word);
  final WordModel word;

  @override
  int get sortOrder => word.sortOrder;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is WordItem && word == other.word;

  @override
  int get hashCode => word.hashCode;
}

class VerbItem extends VocabularyItem {
  VerbItem(this.verb);
  final VerbModel verb;

  @override
  int get sortOrder => verb.sortOrder;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is VerbItem && verb == other.verb;

  @override
  int get hashCode => verb.hashCode;
}
