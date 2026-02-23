import 'dart:ui';

import '../../domain/models/lesson_model.dart';
import '../../domain/models/level_model.dart';
import '../../domain/models/unit_model.dart';

extension LevelLocalizedName on LevelModel {
  String localizedName(Locale locale) {
    return switch (locale.languageCode) {
      'en' => nameEn,
      'ar' => nameAr,
      _ => nameFr,
    };
  }
}

extension UnitLocalizedName on UnitModel {
  String localizedName(Locale locale) {
    return switch (locale.languageCode) {
      'en' => nameEn,
      _ => nameFr,
    };
  }
}

extension LessonLocalizedName on LessonModel {
  String localizedName(Locale locale) {
    return switch (locale.languageCode) {
      'en' => nameEn,
      _ => nameFr,
    };
  }

  String? localizedDescription(Locale locale) {
    return switch (locale.languageCode) {
      'en' => descriptionEn,
      _ => descriptionFr,
    };
  }
}
