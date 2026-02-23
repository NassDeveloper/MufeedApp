import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

Future<void> showErrorReportDialog({
  required BuildContext context,
  required Future<void> Function(String category, String? comment) onSend,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _ErrorReportDialog(onSend: onSend),
  );
}

class _ErrorReportDialog extends StatefulWidget {
  const _ErrorReportDialog({required this.onSend});

  final Future<void> Function(String category, String? comment) onSend;

  @override
  State<_ErrorReportDialog> createState() => _ErrorReportDialogState();
}

class _ErrorReportDialogState extends State<_ErrorReportDialog> {
  String _selectedCategory = 'harakat_error';
  final _commentController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.reportError),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioGroup<String>(
            groupValue: _selectedCategory,
            onChanged: (v) => setState(() => _selectedCategory = v!),
            child: Column(
              children: [
                RadioListTile<String>(
                  title: Text(l10n.reportCategoryHarakat),
                  value: 'harakat_error',
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                RadioListTile<String>(
                  title: Text(l10n.reportCategoryTranslation),
                  value: 'translation_error',
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                RadioListTile<String>(
                  title: Text(l10n.reportCategoryOther),
                  value: 'other',
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: l10n.reportComment,
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _sending ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.reportCancel),
        ),
        FilledButton(
          onPressed: _sending ? null : _send,
          child: _sending
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.reportSend),
        ),
      ],
    );
  }

  Future<void> _send() async {
    setState(() => _sending = true);
    final comment = _commentController.text.trim();
    await widget.onSend(
      _selectedCategory,
      comment.isEmpty ? null : comment,
    );
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.errorReportSent),
      ),
    );
  }
}
