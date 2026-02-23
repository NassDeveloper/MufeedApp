import 'package:flutter/material.dart';

import '../../domain/models/word_model.dart';
import '../../l10n/app_localizations.dart';
import 'arabic_text_widget.dart';
import 'tts_button_widget.dart';

class WordCard extends StatelessWidget {
  const WordCard({
    required this.word,
    this.onReport,
    super.key,
  });

  final WordModel word;
  final VoidCallback? onReport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasMetadata = word.singular != null ||
        word.plural != null ||
        word.synonym != null ||
        word.antonym != null;

    return Semantics(
      label: '${word.arabic} — ${word.translationFr}',
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ArabicText(
                          word.arabic,
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TtsButton(text: word.arabic),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    word.translationFr,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (word.grammaticalCategory != null) ...[
                    const SizedBox(height: 12),
                    Center(
                      child: Semantics(
                        label: '${l10n.grammaticalCategory} : ${word.grammaticalCategory!}',
                        child: Chip(
                          label: Text(word.grammaticalCategory!),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                  ],
                  if (hasMetadata) ...[
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    _MetadataSection(word: word, l10n: l10n),
                  ],
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

class _MetadataSection extends StatelessWidget {
  const _MetadataSection({required this.word, required this.l10n});

  final WordModel word;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (word.singular != null || word.plural != null)
          Row(
            children: [
              if (word.singular != null)
                Expanded(
                  child: _MetadataRow(
                    label: l10n.singularLabel,
                    child: ArabicText(word.singular!),
                  ),
                ),
              if (word.plural != null)
                Expanded(
                  child: _MetadataRow(
                    label: l10n.pluralLabel,
                    child: ArabicText(word.plural!),
                  ),
                ),
            ],
          ),
        if (word.synonym != null)
          _MetadataRow(
            label: l10n.synonymLabel,
            child: ArabicText(word.synonym!),
          ),
        if (word.antonym != null)
          _MetadataRow(
            label: l10n.antonymLabel,
            child: ArabicText(word.antonym!),
          ),
      ],
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          Flexible(child: child),
        ],
      ),
    );
  }
}
