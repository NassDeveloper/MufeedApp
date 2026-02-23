import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/animation_constants.dart';
import '../../domain/models/badge_type.dart';
import '../../l10n/app_localizations.dart';
import '../extensions/badge_type_ui.dart';

class BadgeCelebrationOverlay extends StatefulWidget {
  const BadgeCelebrationOverlay({
    super.key,
    required this.badgeType,
    required this.onDismiss,
  });

  final BadgeType badgeType;
  final VoidCallback onDismiss;

  @override
  State<BadgeCelebrationOverlay> createState() =>
      _BadgeCelebrationOverlayState();
}

class _BadgeCelebrationOverlayState extends State<BadgeCelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AnimationConstants.badgeCelebrationDuration,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: AnimationConstants.badgeCelebrationCurve,
    );
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    HapticFeedback.mediumImpact();
    _controller.forward();

    _autoDismissTimer = Timer(
      AnimationConstants.badgeCelebrationDisplayDuration,
      () {
        if (mounted) widget.onDismiss();
      },
    );
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final label = widget.badgeType.label(l10n);

    return Semantics(
      liveRegion: true,
      label: '${l10n.badgeCelebrationTitle} $label',
      child: GestureDetector(
        onTap: widget.onDismiss,
        behavior: HitTestBehavior.opaque,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Container(
            color: Colors.black54,
            child: Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 40,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.primaryContainer,
                          ),
                          child: Icon(
                            widget.badgeType.icon,
                            size: 40,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.badgeCelebrationTitle,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          label,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.badgeType.description(l10n),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Semantics(
                          button: true,
                          label: l10n.badgeContinue,
                          child: FilledButton(
                            onPressed: widget.onDismiss,
                            child: Text(l10n.badgeContinue),
                          ),
                        ),
                      ],
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

/// Shows the badge celebration overlay for each newly unlocked badge.
///
/// Calls [onBadgeDisplayed] for each badge after its overlay is dismissed,
/// so the caller can mark it as displayed in the database.
void showBadgeCelebrations(
  BuildContext context,
  List<BadgeType> newBadges, {
  void Function(BadgeType)? onBadgeDisplayed,
}) {
  if (newBadges.isEmpty) return;

  final overlay = Overlay.of(context);

  void showNext(int index) {
    if (index >= newBadges.length) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => BadgeCelebrationOverlay(
        badgeType: newBadges[index],
        onDismiss: () {
          entry.remove();
          onBadgeDisplayed?.call(newBadges[index]);
          showNext(index + 1);
        },
      ),
    );
    overlay.insert(entry);
  }

  showNext(0);
}
