import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/lesson_model.dart';
import '../../l10n/app_localizations.dart';
import '../providers/content_provider.dart';
import '../providers/learning_mode_provider.dart';
import '../providers/preferences_provider.dart';
import '../providers/progress_provider.dart';
import '../utils/localized_name.dart';
import '../widgets/error_content_widget.dart';
import '../widgets/skeleton_loader_widget.dart';

class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({
    required this.levelId,
    required this.unitId,
    required this.unitName,
    super.key,
  });

  final int levelId;
  final int unitId;
  final String unitName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncLessons = ref.watch(lessonsByUnitProvider(unitId));

    return Scaffold(
      appBar: AppBar(title: Text(unitName)),
      body: asyncLessons.when(
        loading: () => const SkeletonListLoader(itemCount: 4),
        error: (error, _) => ErrorContent(
          message: l10n.errorLoadingContent,
          onRetry: () => ref.invalidate(lessonsByUnitProvider(unitId)),
          retryLabel: l10n.retry,
        ),
        data: (lessons) {
          if (lessons.isEmpty) {
            return Center(child: Text(l10n.emptyContent));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lessons.length,
            itemBuilder: (context, index) => _LessonCard(
              lesson: lessons[index],
              onTap: () {
                final locale = Localizations.localeOf(context);
                final name = lessons[index].localizedName(locale);
                final route =
                    '/vocabulary/level/$levelId/unit/$unitId/lesson/${lessons[index].id}';
                ref.read(sharedPreferencesSourceProvider).setLastVisitedLesson(
                      lessonId: lessons[index].id,
                      lessonName: name,
                      route: route,
                    );
                ref
                    .read(learningModeProvider.notifier)
                    .setActiveLessonId(lessons[index].id);
                context.push(route, extra: name);
              },
            ),
          );
        },
      ),
    );
  }
}

class _LessonCard extends ConsumerWidget {
  const _LessonCard({required this.lesson, required this.onTap});

  final LessonModel lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final name = lesson.localizedName(locale);
    final asyncProgress = ref.watch(lessonProgressProvider(lesson.id));

    return Semantics(
      button: true,
      label: name,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${lesson.number}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: colorScheme.onTertiaryContainer,
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
                      asyncProgress.when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                        data: (progress) {
                          if (progress.masteredCount == 0) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              l10n.statsLessonProgress(
                                progress.masteredCount,
                                progress.totalItems,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
