import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/level_model.dart';
import '../../domain/models/unit_model.dart';
import '../../l10n/app_localizations.dart';
import '../providers/content_provider.dart';
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
            children:
                levels.map((level) => _LevelExpansionTile(level: level)).toList(),
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
          l10n.unitCount(level.unitCount),
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

class _LessonExerciseRow extends ConsumerWidget {
  const _LessonExerciseRow({
    required this.lessonId,
    required this.lessonName,
  });

  final int lessonId;
  final String lessonName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncExercises = ref.watch(exercisesByLessonProvider(lessonId));
    final hasExercises =
        asyncExercises.value?.isNotEmpty ?? false;
    final asyncVerbs = ref.watch(verbsByLessonProvider(lessonId));
    final hasVerbs = (asyncVerbs.value?.length ?? 0) >= 2;

    final buttonStyle = FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        lessonName,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Wrap(
        spacing: 6,
        runSpacing: 4,
        alignment: WrapAlignment.end,
        children: [
          if (hasExercises)
            FilledButton.tonal(
              onPressed: () => context
                  .push('/session/sentence-exercise/$lessonId'),
              style: buttonStyle,
              child: Text(
                l10n.sentenceExerciseButton,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          if (hasVerbs)
            FilledButton.tonal(
              onPressed: () => context
                  .push('/session/verb-table/$lessonId'),
              style: buttonStyle,
              child: Text(
                l10n.verbTableButton,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          FilledButton.tonal(
            onPressed: () =>
                context.push('/session/quiz/$lessonId'),
            style: buttonStyle,
            child: Text(
              l10n.quizTitle,
              style: Theme.of(context).textTheme.labelSmall,
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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            unitName,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        asyncLessons.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (lessons) => Column(
            children: lessons.map((lesson) {
              final lessonName = lesson.localizedName(locale);
              return _LessonExerciseRow(
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
