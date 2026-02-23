import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Shows a confirmation dialog before quitting a session.
///
/// Returns `true` if the user confirms they want to quit.
Future<bool> confirmQuitSession(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final result = await showAdaptiveDialog<bool>(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: Text(l10n.confirmQuitTitle),
      content: Text(l10n.confirmQuitMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.confirmQuitStay),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.confirmQuitLeave),
        ),
      ],
    ),
  );
  return result ?? false;
}
