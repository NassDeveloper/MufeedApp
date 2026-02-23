import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/srs_constants.dart';
import '../../l10n/app_localizations.dart';

class EvaluationGrid extends StatelessWidget {
  const EvaluationGrid({required this.onRating, super.key});

  final ValueChanged<int> onRating;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _RatingButton(
                  label: l10n.ratingAgain,
                  color: AppColors.ratingAgain,
                  rating: SrsConstants.ratingAgain,
                  onTap: onRating,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _RatingButton(
                  label: l10n.ratingHard,
                  color: AppColors.ratingHard,
                  rating: SrsConstants.ratingHard,
                  onTap: onRating,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _RatingButton(
                  label: l10n.ratingGood,
                  color: AppColors.ratingGood,
                  rating: SrsConstants.ratingGood,
                  onTap: onRating,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _RatingButton(
                  label: l10n.ratingEasy,
                  color: AppColors.ratingEasy,
                  rating: SrsConstants.ratingEasy,
                  onTap: onRating,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  const _RatingButton({
    required this.label,
    required this.color,
    required this.rating,
    required this.onTap,
  });

  final String label;
  final Color color;
  final int rating;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label ($rating)',
      button: true,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            HapticFeedback.lightImpact();
            onTap(rating);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
