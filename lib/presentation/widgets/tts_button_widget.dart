import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/animation_constants.dart';
import '../../l10n/app_localizations.dart';
import '../providers/tts_provider.dart';

class TtsButton extends ConsumerWidget {
  const TtsButton({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final ttsState = ref.watch(ttsProvider);
    final isPlayingThis =
        ttsState.status == TtsStatus.playing && ttsState.currentText == text;
    final isError = ttsState.status == TtsStatus.error;

    final icon = isPlayingThis
        ? Icons.stop
        : isError
            ? Icons.volume_off
            : Icons.volume_up;

    return Semantics(
      label: l10n.ttsButtonSemanticLabel(text),
      button: true,
      excludeSemantics: true,
      child: IconButton(
        icon: AnimatedSwitcher(
          duration: AnimationConstants.ttsIconTransitionDuration,
          child: Icon(
            icon,
            key: ValueKey(icon),
            color: isError
                ? Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.4)
                : null,
          ),
        ),
        tooltip: isError ? l10n.ttsUnavailable : l10n.ttsButtonTooltip,
        onPressed: isError
            ? null
            : () {
                final notifier = ref.read(ttsProvider.notifier);
                if (isPlayingThis) {
                  notifier.stop();
                } else {
                  notifier.speak(text);
                }
              },
      ),
    );
  }
}
