import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/vocabulary_item.dart';
import '../../domain/models/word_model.dart';
import '../../domain/models/verb_model.dart';
import '../../l10n/app_localizations.dart';
import '../providers/content_provider.dart';
import '../providers/error_report_provider.dart';
import '../widgets/error_content_widget.dart';
import '../widgets/error_report_dialog_widget.dart';
import '../widgets/skeleton_loader_widget.dart';
import '../widgets/verb_card_widget.dart';
import '../widgets/word_card_widget.dart';

class LessonDetailScreen extends ConsumerWidget {
  const LessonDetailScreen({
    required this.lessonId,
    required this.lessonName,
    super.key,
  });

  final int lessonId;
  final String lessonName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncWords = ref.watch(wordsByLessonProvider(lessonId));
    final asyncVerbs = ref.watch(verbsByLessonProvider(lessonId));

    return Scaffold(
      appBar: AppBar(title: Text(lessonName)),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Semantics(
            label: l10n.quizStart,
            child: FloatingActionButton.small(
              heroTag: 'quiz',
              onPressed: () => context.push('/session/quiz/$lessonId'),
              child: const Icon(Icons.quiz),
            ),
          ),
          const SizedBox(height: 12),
          Semantics(
            label: l10n.flashcardStartSession,
            child: FloatingActionButton.extended(
              heroTag: 'flashcard',
              onPressed: () => context.push('/session/flashcard/$lessonId'),
              icon: const Icon(Icons.style),
              label: Text(l10n.flashcardStartSession),
            ),
          ),
        ],
      ),
      body: asyncWords.when(
        loading: () => const SkeletonListLoader(itemCount: 6),
        error: (_, _) => ErrorContent(
          message: l10n.errorLoadingContent,
          onRetry: () => _invalidateBoth(ref),
          retryLabel: l10n.retry,
        ),
        data: (words) => asyncVerbs.when(
          loading: () => const SkeletonListLoader(itemCount: 6),
          error: (_, _) => ErrorContent(
            message: l10n.errorLoadingContent,
            onRetry: () => _invalidateBoth(ref),
            retryLabel: l10n.retry,
          ),
          data: (verbs) => _buildList(context, ref, l10n, words, verbs),
        ),
      ),
    );
  }

  void _invalidateBoth(WidgetRef ref) {
    ref.invalidate(wordsByLessonProvider(lessonId));
    ref.invalidate(verbsByLessonProvider(lessonId));
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    List<WordModel> words,
    List<VerbModel> verbs,
  ) {
    final items = <VocabularyItem>[
      ...words.map(WordItem.new),
      ...verbs.map(VerbItem.new),
    ]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    if (items.isEmpty) {
      return Center(child: Text(l10n.emptyVocabulary));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) => switch (items[index]) {
        WordItem(:final word) => WordCard(
            word: word,
            onReport: () => _showReport(
              context, ref,
              itemId: word.id,
              contentType: 'vocab',
            ),
          ),
        VerbItem(:final verb) => VerbCard(
            verb: verb,
            onReport: () => _showReport(
              context, ref,
              itemId: verb.id,
              contentType: 'verb',
            ),
          ),
      },
    );
  }

  void _showReport(
    BuildContext context,
    WidgetRef ref, {
    required int itemId,
    required String contentType,
  }) {
    showErrorReportDialog(
      context: context,
      onSend: (category, comment) async {
        await ref.read(errorReportRepositoryProvider).submitReport(
              itemId: itemId,
              contentType: contentType,
              category: category,
              comment: comment,
            );
      },
    );
  }
}
