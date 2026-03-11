import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../providers/content_provider.dart';
import '../providers/learning_mode_provider.dart';
import '../providers/analytics_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/progress_provider.dart';
import '../utils/localized_name.dart';
import '../widgets/neu_card_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final learningModeAsync = ref.watch(learningModeProvider);
    final levelsAsync = ref.watch(levelsProvider);
    final notifPrefs = ref.watch(notificationPreferencesProvider);
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    final gdprConsent = ref.watch(gdprConsentProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: learningModeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.errorLoadingContent),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => ref.invalidate(learningModeProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (modeState) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            // Active level section
            _SectionHeader(label: l10n.settingsActiveLevel),
            const SizedBox(height: 12),
            levelsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text(l10n.errorLoadingContent),
              data: (levels) => Column(
                children: levels
                    .map(
                      (level) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Semantics(
                          button: true,
                          selected: level.id == modeState.activeLevelId,
                          label: level.localizedName(
                              Localizations.localeOf(context)),
                          excludeSemantics: true,
                          child: NeuCard(
                            borderSide: level.id == modeState.activeLevelId
                                ? BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    width: 2,
                                  )
                                : null,
                            onTap: () => ref
                                .read(learningModeProvider.notifier)
                                .setActiveLevelId(level.id),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    level.localizedName(
                                        Localizations.localeOf(context)),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge,
                                  ),
                                ),
                                if (level.id == modeState.activeLevelId)
                                  Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Learning section
            _SectionHeader(label: l10n.settingsLearningSection),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.settingsNewWordsPerDay),
              subtitle: Text(l10n.settingsNewWordsPerDayDesc),
            ),
            Semantics(
              label: l10n.settingsNewWordsPerDay,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 3, label: Text('3')),
                    ButtonSegment(value: 5, label: Text('5')),
                    ButtonSegment(value: 10, label: Text('10')),
                    ButtonSegment(value: 15, label: Text('15')),
                  ],
                  selected: {ref.watch(newWordsPerDayProvider)},
                  onSelectionChanged: (selected) {
                    ref
                        .read(newWordsPerDayProvider.notifier)
                        .setValue(selected.first);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Notifications section
            _SectionHeader(label: l10n.settingsNotificationsSection),
            const SizedBox(height: 12),
            Semantics(
              toggled: notifPrefs.enabled,
              label: l10n.settingsNotificationsEnabled,
              child: SwitchListTile(
                title: Text(l10n.settingsNotificationsEnabled),
                value: notifPrefs.enabled,
                onChanged: (value) async {
                  final granted = await ref
                      .read(notificationPreferencesProvider.notifier)
                      .setEnabled(value);
                  if (!granted && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.settingsNotificationsPermissionDenied,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            if (notifPrefs.enabled) ...[
              Semantics(
                button: true,
                label: l10n.settingsNotificationsTimeSemanticLabel(
                  notifPrefs.hour,
                  notifPrefs.minute,
                ),
                excludeSemantics: true,
                child: ListTile(
                  title: Text(l10n.settingsNotificationsTime),
                  trailing: Text(
                    '${notifPrefs.hour.toString().padLeft(2, '0')}:${notifPrefs.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: notifPrefs.hour,
                        minute: notifPrefs.minute,
                      ),
                    );
                    if (time != null) {
                      await ref
                          .read(notificationPreferencesProvider.notifier)
                          .setTime(hour: time.hour, minute: time.minute);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  l10n.settingsNotificationsInfo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Language section
            _SectionHeader(label: l10n.settingsLanguageSection),
            const SizedBox(height: 12),
            _OptionCard(
              label: l10n.settingsLanguageFr,
              isSelected: currentLocale.languageCode == 'fr',
              onTap: () => ref
                  .read(localeProvider.notifier)
                  .setLocale(const Locale('fr')),
            ),
            const SizedBox(height: 8),
            _OptionCard(
              label: l10n.settingsLanguageEn,
              isSelected: currentLocale.languageCode == 'en',
              onTap: () => ref
                  .read(localeProvider.notifier)
                  .setLocale(const Locale('en')),
            ),
            const SizedBox(height: 24),

            // Theme section
            _SectionHeader(label: l10n.settingsThemeSection),
            const SizedBox(height: 12),
            _OptionCard(
              label: l10n.settingsThemeSystem,
              icon: Icons.settings_brightness,
              isSelected: currentThemeMode == ThemeMode.system,
              onTap: () => ref
                  .read(themeModeProvider.notifier)
                  .setThemeMode(ThemeMode.system),
            ),
            const SizedBox(height: 8),
            _OptionCard(
              label: l10n.settingsThemeLight,
              icon: Icons.light_mode,
              isSelected: currentThemeMode == ThemeMode.light,
              onTap: () => ref
                  .read(themeModeProvider.notifier)
                  .setThemeMode(ThemeMode.light),
            ),
            const SizedBox(height: 8),
            _OptionCard(
              label: l10n.settingsThemeDark,
              icon: Icons.dark_mode,
              isSelected: currentThemeMode == ThemeMode.dark,
              onTap: () => ref
                  .read(themeModeProvider.notifier)
                  .setThemeMode(ThemeMode.dark),
            ),
            const SizedBox(height: 24),

            // Privacy section
            _SectionHeader(label: l10n.settingsPrivacySection),
            const SizedBox(height: 12),
            Semantics(
              toggled: gdprConsent ?? false,
              label: l10n.settingsPrivacyConsent,
              child: SwitchListTile(
                title: Text(l10n.settingsPrivacyConsent),
                value: gdprConsent ?? false,
                onChanged: (value) => ref
                    .read(gdprConsentProvider.notifier)
                    .setConsent(value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.settingsPrivacyInfo,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Semantics(
              button: true,
              label: l10n.settingsPrivacyPolicyButton,
              child: ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(l10n.settingsPrivacyPolicyButton),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/privacy-policy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Styled section header with a violet accent line.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      excludeSemantics: true,
      child: NeuCard(
        borderSide: isSelected
            ? BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : null,
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
