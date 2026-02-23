import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyPolicyTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PolicySection(
            title: l10n.privacyPolicySectionData,
            content: l10n.privacyPolicyContentData,
          ),
          _PolicySection(
            title: l10n.privacyPolicySectionAnalytics,
            content: l10n.privacyPolicyContentAnalytics,
          ),
          _PolicySection(
            title: l10n.privacyPolicySectionStorage,
            content: l10n.privacyPolicyContentStorage,
          ),
          _PolicySection(
            title: l10n.privacyPolicySectionRights,
            content: l10n.privacyPolicyContentRights,
          ),
          _PolicySection(
            title: l10n.privacyPolicySectionContact,
            content: l10n.privacyPolicyContentContact,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.privacyPolicyLastUpdated,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  const _PolicySection({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
