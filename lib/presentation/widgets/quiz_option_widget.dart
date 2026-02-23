import 'package:flutter/material.dart';

import '../../core/constants/animation_constants.dart';

enum QuizOptionState { idle, correct, incorrect, revealed }

class QuizOptionWidget extends StatefulWidget {
  const QuizOptionWidget({
    required this.text,
    required this.optionState,
    required this.onTap,
    required this.semanticIndex,
    super.key,
  });

  final String text;
  final QuizOptionState optionState;
  final VoidCallback? onTap;
  final int semanticIndex;

  @override
  State<QuizOptionWidget> createState() => _QuizOptionWidgetState();
}

class _QuizOptionWidgetState extends State<QuizOptionWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: AnimationConstants.buttonFeedbackDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: AnimationConstants.buttonFeedbackCurve,
      ),
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(QuizOptionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.optionState == QuizOptionState.idle &&
        (widget.optionState == QuizOptionState.correct ||
            widget.optionState == QuizOptionState.revealed)) {
      _bounceController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  Color _backgroundColor(ColorScheme colorScheme) {
    switch (widget.optionState) {
      case QuizOptionState.idle:
        return colorScheme.surfaceContainerHighest;
      case QuizOptionState.correct:
      case QuizOptionState.revealed:
        return const Color(0xFF4CAF50);
      case QuizOptionState.incorrect:
        return const Color(0xFFEF5350);
    }
  }

  Color _textColor(ColorScheme colorScheme) {
    switch (widget.optionState) {
      case QuizOptionState.idle:
        return colorScheme.onSurface;
      case QuizOptionState.correct:
      case QuizOptionState.incorrect:
      case QuizOptionState.revealed:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = _backgroundColor(colorScheme);

    return Semantics(
      button: true,
      label: widget.text,
      child: ScaleTransition(
        scale: _bounceAnimation,
        child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: AnimationConstants.quizOptionColorDuration,
          curve: AnimationConstants.quizOptionColorCurve,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.onTap,
              onTapDown: widget.onTap != null
                  ? (_) => _scaleController.forward()
                  : null,
              onTapUp: widget.onTap != null
                  ? (_) => _scaleController.reverse()
                  : null,
              onTapCancel: widget.onTap != null
                  ? () => _scaleController.reverse()
                  : null,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Center(
                  child: Text(
                    widget.text,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _textColor(colorScheme),
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
        ),
      ),
    );
  }
}
