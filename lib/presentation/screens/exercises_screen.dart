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
import '../widgets/neu_card_widget.dart';
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

class _LevelExpansionTile extends ConsumerStatefulWidget {
  const _LevelExpansionTile({required this.level});

  final LevelModel level;

  @override
  ConsumerState<_LevelExpansionTile> createState() =>
      _LevelExpansionTileState();
}

class _LevelExpansionTileState extends ConsumerState<_LevelExpansionTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final name = widget.level.localizedName(locale);
    final asyncUnits = ref.watch(unitsByLevelProvider(widget.level.id));
    final progressAsync = ref.watch(levelProgressProvider(widget.level.id));

    String subtitleText = l10n.unitCount(widget.level.unitCount);
    progressAsync.whenData((p) {
      if (p.totalItems > 0) {
        subtitleText =
            l10n.levelProgressLabel(p.masteredItems, p.totalItems);
      }
    });

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeuCard(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Header — layout identique à _LevelCard du vocabulaire
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  colorScheme.primary.withValues(alpha: 0.55),
                                  colorScheme.primaryContainer
                                      .withValues(alpha: 0.40),
                                ]
                              : [
                                  colorScheme.primaryContainer,
                                  colorScheme.primaryContainer,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${widget.level.number}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: isDark
                                  ? colorScheme.primary
                                  : colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitleText,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Contenu expandable
            if (_expanded)
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
                            levelId: widget.level.id,
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
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
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 4),
          child: Row(
            children: [
              // Violet accent dot
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
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
              return _LessonRow(
                lessonId: lesson.id,
                lessonName: lessonName,
              );
            }).toList(),
          ),
        ),
        Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}

class _LessonRow extends ConsumerWidget {
  const _LessonRow({
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
    double? progressPct;
    progressAsync.whenData((p) {
      if (p.totalItems > 0) {
        badgeText = '${p.masteredCount}/${p.totalItems}';
        progressPct = p.masteredCount / p.totalItems;
      }
    });

    return Semantics(
      button: true,
      label: lessonName,
      child: InkWell(
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF13131F)
              : null,
          builder: (_) => _LessonActivitiesSheet(
            lessonId: lessonId,
            lessonName: lessonName,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  lessonName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              if (badgeText != null) ...[
                // Progress bar + text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      badgeText!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: progressPct == 1.0
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                            fontWeight: progressPct == 1.0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      width: 48,
                      child: LinearProgressIndicator(
                        value: progressPct,
                        minHeight: 2,
                        borderRadius: BorderRadius.circular(1),
                        color: progressPct == 1.0
                            ? colorScheme.primary
                            : colorScheme.tertiary,
                        backgroundColor:
                            colorScheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
    double? progressPct;
    progressAsync.whenData((p) {
      progressSubtitle =
          l10n.lessonActivitiesProgress(p.masteredCount, p.totalItems);
      if (p.totalItems > 0) {
        progressPct = p.masteredCount / p.totalItems;
      }
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
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? colorScheme.primary.withValues(alpha: 0.4)
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lessonName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (progressSubtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          progressSubtitle,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                        ),
                      ),
                      if (progressPct != null)
                        SizedBox(
                          width: 80,
                          child: LinearProgressIndicator(
                            value: progressPct,
                            minHeight: 3,
                            borderRadius: BorderRadius.circular(2),
                            color: progressPct == 1.0
                                ? colorScheme.primary
                                : colorScheme.tertiary,
                            backgroundColor: colorScheme.outlineVariant
                                .withValues(alpha: 0.3),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          // Activities list
          Expanded(
            child: ListView(
              controller: scrollController,
              children: [
                _ActivityTile(
                  icon: Icons.style_outlined,
                  label: l10n.activityFlashcards,
                  onTap: () => navigate('/session/flashcard/$lessonId'),
                ),
                if (hasExercises)
                  _ActivityTile(
                    icon: Icons.edit_note_outlined,
                    label: l10n.activityPhrases,
                    onTap: () =>
                        navigate('/session/sentence-exercise/$lessonId'),
                  ),
                if (hasVerbs)
                  _ActivityTile(
                    icon: Icons.table_rows_outlined,
                    label: l10n.activityVerbTable,
                    onTap: () => navigate('/session/verb-table/$lessonId'),
                  ),
                if (hasEnoughForMatching)
                  _ActivityTile(
                    icon: Icons.link_outlined,
                    label: l10n.activityMatching,
                    onTap: () => navigate('/session/matching/$lessonId'),
                  ),
                if (hasExercises)
                  _ActivityTile(
                    icon: Icons.sort_outlined,
                    label: l10n.activityWordOrdering,
                    onTap: () =>
                        navigate('/session/word-ordering/$lessonId'),
                  ),
                if (hasEnoughForListening)
                  _ActivityTile(
                    icon: Icons.hearing_outlined,
                    label: l10n.activityListening,
                    onTap: () => navigate('/session/listening/$lessonId'),
                  ),
                if (hasDialogues)
                  _ActivityTile(
                    icon: Icons.chat_bubble_outline,
                    label: l10n.activityDialogue,
                    onTap: () => navigate('/session/dialogue/$lessonId'),
                  ),
                _ActivityTile(
                  icon: Icons.quiz_outlined,
                  label: l10n.activityQuiz,
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

/// A single activity row in the bottom sheet.
class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: colorScheme.primary),
      ),
      title: Text(label),
      trailing: Icon(
        Icons.chevron_right,
        size: 18,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
