import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/lesson_model.dart';
import '../../domain/models/lesson_progress_model.dart';
import '../../l10n/app_localizations.dart';
import '../providers/content_provider.dart';
import '../providers/learning_mode_provider.dart';
import '../providers/preferences_provider.dart';
import '../providers/progress_provider.dart';
import '../utils/localized_name.dart';
import '../widgets/error_content_widget.dart';
import '../widgets/neu_card_widget.dart';
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
    final name = lesson.localizedName(locale);
    final asyncProgress = ref.watch(lessonProgressProvider(lesson.id));

    return Semantics(
      button: true,
      label: name,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: NeuCard(
          onTap: onTap,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              asyncProgress.when(
                loading: () =>
                    _ProgressRing(number: lesson.number, progress: null),
                error: (_, _) =>
                    _ProgressRing(number: lesson.number, progress: null),
                data: (progress) =>
                    _ProgressRing(number: lesson.number, progress: progress),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Circular progress ring with lesson number inside.
/// - Empty ring: lesson not started
/// - Colored arc: lesson in progress
/// - Full ring + checkmark: lesson complete
class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.number, required this.progress});

  final int number;
  final LessonProgressModel? progress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pct = (progress != null && progress!.totalItems > 0)
        ? progress!.masteredPercentage
        : 0.0;
    final hasStarted = pct > 0;
    final isComplete = pct >= 1.0;

    final ringColor = isComplete
        ? colorScheme.primary
        : hasStarted
            ? colorScheme.tertiary
            : colorScheme.outlineVariant;

    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle fill
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isComplete
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
          ),
          // Progress arc
          CircularProgressIndicator(
            value: pct,
            strokeWidth: 3.5,
            backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation(ringColor),
            strokeCap: StrokeCap.round,
          ),
          // Center: checkmark if complete, number otherwise
          isComplete
              ? Icon(Icons.check_rounded, size: 22, color: colorScheme.primary)
              : Text(
                  '$number',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
        ],
      ),
    );
  }
}
