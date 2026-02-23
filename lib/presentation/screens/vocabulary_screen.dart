import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/level_model.dart';
import '../../l10n/app_localizations.dart';
import '../providers/content_provider.dart';
import '../utils/localized_name.dart';
import '../widgets/error_content_widget.dart';
import '../widgets/skeleton_loader_widget.dart';

class VocabularyScreen extends ConsumerWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncLevels = ref.watch(levelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.vocabularyScreenTitle),
            Text(
              l10n.vocabularyScreenSubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
      body: asyncLevels.when(
        loading: () => const SkeletonListLoader(itemCount: 4),
        error: (error, _) => ErrorContent(
          message: l10n.errorLoadingContent,
          onRetry: () => ref.invalidate(levelsProvider),
          retryLabel: l10n.retry,
        ),
        data: (levels) {
          if (levels.isEmpty) {
            return Center(child: Text(l10n.emptyContent));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: levels.length,
            itemBuilder: (context, index) => _LevelCard(level: levels[index]),
          );
        },
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.level});

  final LevelModel level;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    final name = level.localizedName(locale);

    return Semantics(
      button: true,
      label: '$name, ${l10n.unitCount(level.unitCount)}',
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.push(
            '/vocabulary/level/${level.id}',
            extra: name,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Hero(
                  tag: 'level-${level.id}',
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${level.number}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
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
                      const SizedBox(height: 4),
                      Text(
                        l10n.unitCount(level.unitCount),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
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
