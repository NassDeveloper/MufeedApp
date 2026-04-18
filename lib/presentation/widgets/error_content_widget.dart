import 'package:flutter/material.dart';

class ErrorContent extends StatelessWidget {
  const ErrorContent({
    required this.message,
    required this.onRetry,
    required this.retryLabel,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      liveRegion: true,
      label: message,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                excludeSemantics: true,
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 56,
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Semantics(
                button: true,
                label: retryLabel,
                child: FilledButton.tonal(
                  onPressed: onRetry,
                  child: Text(retryLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
