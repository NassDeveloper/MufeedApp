import 'package:flutter/material.dart';

import '../../domain/models/verb_model.dart';
import '../../l10n/app_localizations.dart';
import 'arabic_text_widget.dart';
import 'tts_button_widget.dart';

class VerbCard extends StatelessWidget {
  const VerbCard({
    required this.verb,
    this.onReport,
    super.key,
  });

  final VerbModel verb;
  final VoidCallback? onReport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      label: '${verb.masdar} — ${verb.translationFr}',
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _VerbFormRow(
                    label: l10n.verbFormMasdar,
                    arabic: verb.masdar,
                    trailing: TtsButton(text: verb.masdar),
                  ),
                  const Divider(height: 16),
                  _VerbFormRow(label: l10n.verbFormPast, arabic: verb.past),
                  const Divider(height: 16),
                  _VerbFormRow(
                      label: l10n.verbFormPresent, arabic: verb.present),
                  const Divider(height: 16),
                  _VerbFormRow(
                      label: l10n.verbFormImperative, arabic: verb.imperative),
                  const SizedBox(height: 16),
                  Text(
                    verb.translationFr,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (onReport != null)
              Positioned(
                top: 4,
                right: 4,
                child: Opacity(
                  opacity: 0.6,
                  child: IconButton(
                    icon: const Icon(Icons.flag_outlined, size: 20),
                    onPressed: onReport,
                    tooltip: l10n.reportError,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _VerbFormRow extends StatelessWidget {
  const _VerbFormRow({required this.label, required this.arabic, this.trailing});

  final String label;
  final String arabic;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 160),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ArabicText(
            arabic,
            style: const TextStyle(fontSize: 28),
          ),
        ),
        ?trailing,
      ],
    );
  }
}
