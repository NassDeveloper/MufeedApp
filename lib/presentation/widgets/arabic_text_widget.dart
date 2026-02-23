import 'package:flutter/material.dart';

import '../theme/app_typography.dart';

/// Dedicated widget for rendering Arabic text with harakats.
///
/// RULE: ALL Arabic content MUST use this widget — never use Text() directly.
/// Forces RTL direction, Scheherazade New font, and minimum 24sp size.
class ArabicText extends StatelessWidget {
  const ArabicText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = AppTypography.arabicBody.merge(style);

    return Semantics(
      label: text,
      textDirection: TextDirection.rtl,
      child: Text(
        text,
        textDirection: TextDirection.rtl,
        textAlign: textAlign ?? TextAlign.right,
        maxLines: maxLines,
        overflow: overflow,
        style: effectiveStyle,
      ),
    );
  }
}
