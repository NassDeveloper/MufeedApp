import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/level_model.dart';
import '../../domain/models/unit_model.dart';
import '../../l10n/app_localizations.dart';
import '../providers/content_provider.dart';
import '../providers/dialogue_provider.dart';
import '../providers/progress_provider.dart';
import '../utils/localized_name.dart';
import '../widgets/error_content_widget.dart';
import '../widgets/skeleton_loader_widget.dart';

class ExercisesScreen extends ConsumerWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncLevels = ref.watch(levelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.exercisesScreenTitle),
            Text(
              l10n.exercisesScreenSubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
      body: asyncLevels.when(
        loading: () => const SkeletonListLoader(itemCount: 4),
        error: (_, _) => ErrorContent(
          message: l10n.errorLoadingContent,
          onRetry: () => ref.invalidate(levelsProvider),
          retryLabel: l10n.retry,
        ),
        data: (levels) {
          if (levels.isEmpty) {
            return Center(child: Text(l10n.emptyContent));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: levels
                .map((level) => _LevelExpansionTile(level: level))
                .toList(),
          );
        },
      ),
    );
  }
}

class _LevelExpansionTile extends ConsumerWidget {
  const _LevelExpansionTile({required this.level});

  final LevelModel level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final name = level.localizedName(locale);
    final asyncUnits = ref.watch(unitsByLevelProvider(level.id));
    final progressAsync = ref.watch(levelProgressProvider(level.id));

    String subtitleText = l10n.unitCount(level.unitCount);
    progressAsync.whenData((p) {
      if (p.totalItems > 0) {
        subtitleText = l10n.levelProgressLabel(p.masteredItems, p.totalItems);
      }
    });

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            '${level.number}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        title: Text(name, style: Theme.of(context).textTheme.titleSmall),
        subtitle: Text(
          subtitleText,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
        children: [
          asyncUnits.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
            error: (_, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.errorLoadingContent),
            ),
            data: (units) => Column(
              children: units
                  .map((unit) => _UnitLessonsSection(
                        unit: unit,
                        levelId: level.id,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnitLessonsSection extends ConsumerWidget {
  const _UnitLessonsSection({required this.unit, required this.levelId});

  final UnitModel unit;
  final int levelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    final unitName = unit.localizedName(locale);
    final asyncLessons = ref.watch(lessonsByUnitProvider(unit.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  unitName,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.style_outlined,
                  size: 18,
                  color: colorScheme.primary,
                ),
                tooltip: AppLocalizations.of(context)!.flashcardStartSession,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                onPressed: () => GoRouter.of(context)
                    .push('/session/flashcard/unit/${unit.id}'),
              ),
            ],
          ),
        ),
        asyncLessons.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (lessons) => Column(
            children: lessons.map((lesson) {
              final lessonName = lesson.localizedName(locale);
              return _LessonCard(
                lessonId: lesson.id,
                lessonName: lessonName,
              );
            }).toList(),
          ),
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}

class _LessonCard extends ConsumerWidget {
  const _LessonCard({
    required this.lessonId,
    required this.lessonName,
  });

  final int lessonId;
  final String lessonName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final progressAsync = ref.watch(lessonProgressProvider(lessonId));

    String? badgeText;
    progressAsync.whenData((p) {
      if (p.totalItems > 0) {
        badgeText = '${p.masteredCount}/${p.totalItems}';
      }
    });

    return Semantics(
      button: true,
      label: lessonName,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        title: Text(
          lessonName,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badgeText != null) ...[
              Text(
                badgeText!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(width: 4),
            ],
            Icon(
              Icons.chevron_right,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => _LessonActivitiesSheet(
            lessonId: lessonId,
            lessonName: lessonName,
          ),
        ),
      ),
    );
  }
}

class _LessonActivitiesSheet extends ConsumerWidget {
  const _LessonActivitiesSheet({
    required this.lessonId,
    required this.lessonName,
  });

  final int lessonId;
  final String lessonName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final progressAsync = ref.watch(lessonProgressProvider(lessonId));

    final asyncExercises = ref.watch(exercisesByLessonProvider(lessonId));
    final hasExercises = asyncExercises.value?.isNotEmpty ?? false;
    final asyncVerbs = ref.watch(verbsByLessonProvider(lessonId));
    final hasVerbs = (asyncVerbs.value?.length ?? 0) >= 2;
    final asyncWords = ref.watch(wordsByLessonProvider(lessonId));
    final totalItems =
        (asyncWords.value?.length ?? 0) + (asyncVerbs.value?.length ?? 0);
    final hasEnoughForMatching = totalItems >= 4;
    final hasEnoughForListening = totalItems >= 4;
    final asyncDialogues = ref.watch(dialoguesByLessonProvider(lessonId));
    final hasDialogues = asyncDialogues.value?.isNotEmpty ?? false;

    String progressSubtitle = '';
    progressAsync.whenData((p) {
      progressSubtitle =
          l10n.lessonActivitiesProgress(p.masteredCount, p.totalItems);
    });

    void navigate(String route) {
      final router = GoRouter.of(context);
      Navigator.of(context).pop();
      router.push(route);
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lessonName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (progressSubtitle.isNotEmpty)
                  Text(
                    progressSubtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
              ],
            ),
          ),
          const Divider(height: 16),
          // Activities list
          Expanded(
            child: ListView(
              controller: scrollController,
              children: [
                // Flashcards (always)
                ListTile(
                  leading:
                      Icon(Icons.style_outlined, color: colorScheme.primary),
                  title: Text(l10n.activityFlashcards),
                  trailing: const Icon(Icons.chevron_right, size: 18),
                  onTap: () => navigate('/session/flashcard/$lessonId'),
                ),
                // Phrases (conditional)
                if (hasExercises)
                  ListTile(
                    leading: Icon(Icons.edit_note_outlined,
                        color: colorScheme.primary),
                    title: Text(l10n.activityPhrases),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () =>
                        navigate('/session/sentence-exercise/$lessonId'),
                  ),
                // Verb table (conditional)
                if (hasVerbs)
                  ListTile(
                    leading: Icon(Icons.table_rows_outlined,
                        color: colorScheme.primary),
                    title: Text(l10n.activityVerbTable),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => navigate('/session/verb-table/$lessonId'),
                  ),
                // Matching (conditional)
                if (hasEnoughForMatching)
                  ListTile(
                    leading:
                        Icon(Icons.link_outlined, color: colorScheme.primary),
                    title: Text(l10n.activityMatching),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => navigate('/session/matching/$lessonId'),
                  ),
                // Word ordering (conditional)
                if (hasExercises)
                  ListTile(
                    leading:
                        Icon(Icons.sort_outlined, color: colorScheme.primary),
                    title: Text(l10n.activityWordOrdering),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () =>
                        navigate('/session/word-ordering/$lessonId'),
                  ),
                // Listening (conditional)
                if (hasEnoughForListening)
                  ListTile(
                    leading: Icon(Icons.hearing_outlined,
                        color: colorScheme.primary),
                    title: Text(l10n.activityListening),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => navigate('/session/listening/$lessonId'),
                  ),
                // Dialogue (conditional)
                if (hasDialogues)
                  ListTile(
                    leading: Icon(Icons.chat_bubble_outline,
                        color: colorScheme.primary),
                    title: Text(l10n.activityDialogue),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => navigate('/session/dialogue/$lessonId'),
                  ),
                // Quiz (always)
                ListTile(
                  leading:
                      Icon(Icons.quiz_outlined, color: colorScheme.primary),
                  title: Text(l10n.activityQuiz),
                  trailing: const Icon(Icons.chevron_right, size: 18),
                  onTap: () => navigate('/session/quiz/$lessonId'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
