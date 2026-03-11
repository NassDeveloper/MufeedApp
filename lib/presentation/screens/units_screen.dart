import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/unit_model.dart';
import '../../l10n/app_localizations.dart';
import '../providers/content_provider.dart';
import '../utils/localized_name.dart';
import '../widgets/error_content_widget.dart';
import '../widgets/neu_card_widget.dart';
import '../widgets/skeleton_loader_widget.dart';

class UnitsScreen extends ConsumerWidget {
  const UnitsScreen({
    required this.levelId,
    required this.levelName,
    super.key,
  });

  final int levelId;
  final String levelName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncUnits = ref.watch(unitsByLevelProvider(levelId));

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'level-$levelId',
          child: Material(
            color: Colors.transparent,
            child: Text(
              levelName,
              style: Theme.of(context).appBarTheme.titleTextStyle ??
                  Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
      body: asyncUnits.when(
        loading: () => const SkeletonListLoader(itemCount: 4),
        error: (error, _) => ErrorContent(
          message: l10n.errorLoadingContent,
          onRetry: () => ref.invalidate(unitsByLevelProvider(levelId)),
          retryLabel: l10n.retry,
        ),
        data: (units) {
          if (units.isEmpty) {
            return Center(child: Text(l10n.emptyContent));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: units.length,
            itemBuilder: (context, index) => _UnitCard(
              unit: units[index],
              levelId: levelId,
            ),
          );
        },
      ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  const _UnitCard({required this.unit, required this.levelId});

  final UnitModel unit;
  final int levelId;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = unit.localizedName(locale);

    return Semantics(
      button: true,
      label: name,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: NeuCard(
          onTap: () => context.push(
            '/vocabulary/level/$levelId/unit/${unit.id}',
            extra: name,
          ),
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
                  '${unit.number}',
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
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
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
    );
  }
}
