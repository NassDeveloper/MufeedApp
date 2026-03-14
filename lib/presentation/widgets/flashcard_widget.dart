import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/animation_constants.dart';
import '../../domain/models/reviewable_item_model.dart';
import '../../l10n/app_localizations.dart';
import '../providers/tts_provider.dart';
import 'arabic_text_widget.dart';
import 'tts_button_widget.dart';

class FlashcardWidget extends StatefulWidget {
  const FlashcardWidget({
    required this.item,
    required this.isFlipped,
    required this.onFlip,
    super.key,
  });

  final ReviewableItemModel item;
  final bool isFlipped;
  final VoidCallback onFlip;

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationConstants.flipDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: AnimationConstants.flipCurve,
    );
    _controller.addListener(_updateSide);
    if (widget.isFlipped) {
      _controller.value = 1.0;
      _showFront = false;
    }
  }

  void _updateSide() {
    final showFront = _animation.value < 0.5;
    if (_showFront != showFront) {
      setState(() => _showFront = showFront);
    }
  }

  @override
  void didUpdateWidget(FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    if (widget.item != oldWidget.item) {
      _controller.reset();
      _showFront = true;
      // AC #5: stop TTS when changing cards
      ProviderScope.containerOf(context).read(ttsProvider.notifier).stop();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateSide);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      label: _showFront ? l10n.flashcardFront : l10n.flashcardBack,
      onTap: widget.onFlip,
      child: GestureDetector(
        onTap: () {
          widget.onFlip();
          if (!widget.isFlipped) {
            // ignore: deprecated_member_use
            SemanticsService.announce(
              l10n.flashcardSemanticFlipped,
              TextDirection.ltr,
            );
          }
        },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            final angle = _animation.value * pi;
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle);

            return Transform(
              alignment: Alignment.center,
              transform: transform,
              child: _showFront
                  ? _buildFront(context)
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(pi),
                      child: _buildBack(context),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFront(BuildContext context) {
    final theme = Theme.of(context);
    // For verbs, show the past tense form on the front (not masdar which is
    // studied later). Fall back to arabic (masdar) only if verbPast is absent.
    final frontArabic = widget.item.isVerb
        ? (widget.item.verbPast ?? widget.item.arabic)
        : widget.item.arabic;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ArabicText(
                  frontArabic,
                  style: TextStyle(
                    fontSize: 32,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.flashcardTapToFlip,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: TtsButton(text: frontArabic),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        child: widget.item.isVerb
            ? _buildVerbBack(context, theme)
            : _buildVocabBack(context, theme),
      ),
    );
  }

  Widget _buildVocabBack(BuildContext context, ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.item.translationFr,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVerbBack(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final labelStyle = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.item.translationFr,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _verbFormRow(l10n.verbFormMasdar, widget.item.arabic, labelStyle),
        if (widget.item.verbPast != null)
          _verbFormRow(l10n.verbFormPast, widget.item.verbPast!, labelStyle),
        if (widget.item.verbPresent != null)
          _verbFormRow(
              l10n.verbFormPresent, widget.item.verbPresent!, labelStyle),
        if (widget.item.verbImperative != null)
          _verbFormRow(
              l10n.verbFormImperative, widget.item.verbImperative!, labelStyle),
      ],
    );
  }

  Widget _verbFormRow(String label, String arabic, TextStyle? labelStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: labelStyle),
          ),
          Expanded(
            child: ArabicText(arabic, style: const TextStyle(fontSize: 24)),
          ),
          TtsButton(text: arabic),
        ],
      ),
    );
  }
}
