import 'package:flutter/material.dart';

/// Neumorphic card — dark mode: raised card with twin outer shadows + violet
/// border accent. Light mode: standard elevated card with subtle shadow.
///
/// Use [onTap] to make the card interactive with an InkWell ripple.
/// Use [clipBehavior] = [Clip.antiAlias] when the card contains an
/// [ExpansionTile] or other widget that needs content clipping.
class NeuCard extends StatelessWidget {
  const NeuCard({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.borderRadius,
    this.onTap,
    this.clipBehavior = Clip.none,
    this.borderSide,
  });

  final Widget child;

  /// Override the card background color.
  final Color? color;

  /// Optional inner padding applied to [child].
  final EdgeInsetsGeometry? padding;

  /// Corner radius. Defaults to [BorderRadius.circular(16)].
  final BorderRadius? borderRadius;

  /// Makes the card tappable with an ink-ripple effect.
  final VoidCallback? onTap;

  /// Clip behavior applied to the card's Material. Use [Clip.antiAlias] when
  /// the card contains expanding children (e.g. ExpansionTile).
  final Clip clipBehavior;

  /// Overrides the default border. When null, a 1 dp subtle primary border is
  /// shown (10 % opacity in dark mode, translucent white in light mode).
  final BorderSide? borderSide;

  // Shadows calibrated for dark navy surface (#1A1A28)
  static const _neuShadowLight = Color(0xFF2E2E20); // warm-tinted highlight
  static const _neuShadowDark = Color(0xFF090908); // near-black depth

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final radius = borderRadius ?? BorderRadius.circular(16);

    final effectiveColor =
        color ?? (isDark ? const Color(0xFF1A1A2E) : colorScheme.surface);

    final effectiveBorder = borderSide ??
        BorderSide(
          color: isDark
              ? colorScheme.primary.withValues(alpha: 0.10)
              : Colors.white.withValues(alpha: 0.75),
        );

    final shape = RoundedRectangleBorder(
      borderRadius: radius,
      side: effectiveBorder,
    );

    Widget content =
        padding != null ? Padding(padding: padding!, child: child) : child;

    if (isDark) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: const [
            BoxShadow(
              color: _neuShadowLight,
              offset: Offset(-4, -4),
              blurRadius: 10,
              spreadRadius: -2,
            ),
            BoxShadow(
              color: _neuShadowDark,
              offset: Offset(4, 4),
              blurRadius: 10,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Material(
          color: effectiveColor,
          shape: shape,
          clipBehavior: clipBehavior,
          child: onTap != null
              ? InkWell(
                  customBorder: shape,
                  onTap: onTap,
                  splashColor: colorScheme.primary.withValues(alpha: 0.12),
                  highlightColor: colorScheme.primary.withValues(alpha: 0.08),
                  child: content,
                )
              : content,
        ),
      );
    }

    // Light mode — simple elevated card
    return Material(
      color: effectiveColor,
      shape: shape,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      clipBehavior: clipBehavior,
      child: onTap != null
          ? InkWell(
              customBorder: shape,
              onTap: onTap,
              splashColor: colorScheme.primary.withValues(alpha: 0.12),
              highlightColor: colorScheme.primary.withValues(alpha: 0.08),
              child: content,
            )
          : content,
    );
  }
}
