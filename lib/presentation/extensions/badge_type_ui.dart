import 'package:flutter/material.dart';

import '../../domain/models/badge_type.dart';

extension BadgeTypeUi on BadgeType {
  IconData get icon => switch (this) {
        BadgeType.firstWordReviewed => Icons.school,
        BadgeType.words10 => Icons.auto_stories,
        BadgeType.words50 => Icons.menu_book,
        BadgeType.words100 => Icons.workspace_premium,
        BadgeType.words500 => Icons.diamond,
        BadgeType.firstLessonCompleted => Icons.check_circle,
        BadgeType.streak7 => Icons.local_fire_department,
        BadgeType.streak30 => Icons.whatshot,
        BadgeType.streak100 => Icons.stars,
        BadgeType.perfectQuiz => Icons.emoji_events,
      };
}
