import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/models/verb_table_row.dart';
import '../../l10n/app_localizations.dart';
import '../providers/error_report_provider.dart';
import '../providers/verb_table_session_provider.dart';
import '../utils/confirm_quit_session.dart';
import '../widgets/error_report_dialog_widget.dart';
import '../widgets/fade_in_widget.dart';
import '../widgets/skeleton_loader_widget.dart';

class VerbTableExerciseScreen extends ConsumerStatefulWidget {
  const VerbTableExerciseScreen({required this.lessonId, super.key});

  final int lessonId;

  @override
  ConsumerState<VerbTableExerciseScreen> createState() =>
      _VerbTableExerciseScreenState();
}

class _VerbTableExerciseScreenState
    extends ConsumerState<VerbTableExerciseScreen> {
  bool _isLoading = true;
  bool _hasVerbs = true;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  Future<void> _startSession() async {
    final notifier = ref.read(verbTableSessionProvider.notifier);
    await notifier.startSession(widget.lessonId);
    if (!mounted) return;

    final state = ref.read(verbTableSessionProvider);
    setState(() {
      _isLoading = false;
      _hasVerbs = state != null;
    });
  }

  void _onCellTapped(int rowIndex, VerbForm form) {
    final state = ref.read(verbTableSessionProvider);
    if (state == null || state.isCompleted) return;

    final row = state.rows[rowIndex];
    final cell = row.cellForForm(form);
    if (!cell.isPending || cell.choices == null) return;

    _showChoiceBottomSheet(rowIndex, form, cell);
  }

  void _showChoiceBottomSheet(
    int rowIndex,
    VerbForm form,
    VerbCellState cell,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _formLabel(form),
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        color: Theme.of(ctx).colorScheme.primary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ...cell.choices!.map((choice) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FilledButton.tonal(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _submitAnswer(rowIndex, form, choice);
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          choice,
                          style:
                              Theme.of(ctx).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitAnswer(int rowIndex, VerbForm form, String answer) {
    final notifier = ref.read(verbTableSessionProvider.notifier);
    notifier.submitAnswer(rowIndex, form, answer);

    final state = ref.read(verbTableSessionProvider);
    if (state == null) return;

    final cell = state.rows[rowIndex].cellForForm(form);
    if (cell.isCorrect == true) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  void _showReport(BuildContext context, WidgetRef ref) {
    showErrorReportDialog(
      context: context,
      onSend: (category, comment) async {
        await ref.read(errorReportRepositoryProvider).submitReport(
              itemId: widget.lessonId,
              contentType: 'verb_table',
              category: category,
              comment: comment,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.verbTableTitle),
        ),
        body: const FadeIn(child: SkeletonListLoader(itemCount: 4)),
      );
    }

    if (!_hasVerbs) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.verbTableTitle),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.table_chart_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.verbTableEmpty,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.quizEmptyAction),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final state = ref.watch(verbTableSessionProvider);
    if (state == null) return const SizedBox.shrink();

    if (state.isCompleted) {
      return _CompletedView(
        correct: state.correctCount,
        total: state.totalHidden,
        l10n: l10n,
        onRestart: () {
          setState(() => _isLoading = true);
          _startSession();
        },
        onClose: () {
          ref.read(verbTableSessionProvider.notifier).endSession();
          context.pop();
        },
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await confirmQuitSession(context)) {
          ref.read(verbTableSessionProvider.notifier).endSession();
          if (context.mounted) context.pop();
        }
      },
      child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            if (await confirmQuitSession(context)) {
              ref.read(verbTableSessionProvider.notifier).endSession();
              if (context.mounted) context.pop();
            }
          },
        ),
        title: Text(l10n.verbTableTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            tooltip: l10n.reportError,
            onPressed: () => _showReport(context, ref),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: state.totalHidden > 0
                ? state.revealedCount / state.totalHidden
                : 0,
          ),
        ),
      ),
      body: Column(
        children: [
          // Score bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.verbTableScore(state.correctCount, state.totalHidden),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                Text(
                  l10n.verbTableTapToGuess,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          // Table
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: _VerbTable(
                  rows: state.rows,
                  onCellTapped: _onCellTapped,
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  String _formLabel(VerbForm form) {
    final l10n = AppLocalizations.of(context)!;
    switch (form) {
      case VerbForm.masdar:
        return l10n.verbFormMasdar;
      case VerbForm.past:
        return l10n.verbFormPast;
      case VerbForm.present:
        return l10n.verbFormPresent;
      case VerbForm.imperative:
        return l10n.verbFormImperative;
    }
  }
}

class _VerbTable extends StatelessWidget {
  const _VerbTable({
    required this.rows,
    required this.onCellTapped,
  });

  final List<VerbTableRow> rows;
  final void Function(int rowIndex, VerbForm form) onCellTapped;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Table(
      border: TableBorder.all(
        color: colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      defaultColumnWidth: const FixedColumnWidth(110),
      columnWidths: const {
        4: FixedColumnWidth(100), // Translation
      },
      children: [
        // Header row
        TableRow(
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          children: [
            _headerCell(context, 'المصدر'),
            _headerCell(context, 'الأمر'),
            _headerCell(context, 'المضارع'),
            _headerCell(context, 'الماضي'),
            _headerCell(context, l10n.verbTableTranslation),
          ],
        ),
        // Data rows
        for (var i = 0; i < rows.length; i++)
          TableRow(
            decoration: BoxDecoration(
              color: i.isEven
                  ? null
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ),
            children: [
              _verbCell(context, rows[i].masdar, i, VerbForm.masdar),
              _verbCell(context, rows[i].imperative, i, VerbForm.imperative),
              _verbCell(context, rows[i].present, i, VerbForm.present),
              _verbCell(context, rows[i].past, i, VerbForm.past),
              _translationCell(context, rows[i].translationFr),
            ],
          ),
      ],
    );
  }

  Widget _headerCell(BuildContext context, String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _translationCell(BuildContext context, String text) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _verbCell(
    BuildContext context,
    VerbCellState cell,
    int rowIndex,
    VerbForm form,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    // Visible cell (not hidden)
    if (!cell.isHidden) {
      return TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              cell.value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    // Revealed cell (already answered)
    if (cell.isRevealed) {
      final bgColor = cell.isCorrect!
          ? AppColors.ratingEasy.withValues(alpha: 0.15)
          : AppColors.ratingAgain.withValues(alpha: 0.15);
      final textColor = cell.isCorrect!
          ? AppColors.ratingEasy
          : colorScheme.onSurface;

      return TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          color: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  cell.value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (!cell.isCorrect!)
                const Icon(Icons.close, size: 14, color: AppColors.ratingAgain),
            ],
          ),
        ),
      );
    }

    // Hidden cell (pending) — tappable "?" with pulse
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: InkWell(
        onTap: () => onCellTapped(rowIndex, form),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: _PulsingQuestionMark(colorScheme: colorScheme),
        ),
      ),
    );
  }
}

class _PulsingQuestionMark extends StatefulWidget {
  const _PulsingQuestionMark({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  State<_PulsingQuestionMark> createState() => _PulsingQuestionMarkState();
}

class _PulsingQuestionMarkState extends State<_PulsingQuestionMark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        decoration: BoxDecoration(
          color: widget.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(
          '?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: widget.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _CompletedView extends StatelessWidget {
  const _CompletedView({
    required this.correct,
    required this.total,
    required this.l10n,
    required this.onRestart,
    required this.onClose,
  });

  final int correct;
  final int total;
  final AppLocalizations l10n;
  final VoidCallback onRestart;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final percent = total > 0 ? (correct / total * 100).round() : 0;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose,
        ),
        title: Text(l10n.verbTableTitle),
      ),
      body: FadeIn(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  percent >= 80 ? Icons.emoji_events : Icons.school,
                  size: 64,
                  color: percent >= 80
                      ? AppColors.ratingEasy
                      : colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.verbTableCompleted,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  '$correct / $total',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$percent%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: onRestart,
                  child: Text(l10n.quizSummaryRestart),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: onClose,
                  child: Text(l10n.quizEmptyAction),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
