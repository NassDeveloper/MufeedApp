import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/datasources/content_importer.dart';
import 'data/database/app_database.dart';
import 'data/datasources/json_content_loader.dart';
import 'data/datasources/shared_preferences_source.dart';
import 'data/repositories/content_repository_impl.dart';
import 'data/repositories/error_report_repository_impl.dart';
import 'data/repositories/progress_repository_impl.dart';
import 'data/repositories/badge_repository_impl.dart';
import 'data/repositories/streak_repository_impl.dart';
import 'data/services/analytics_service_impl.dart';
import 'data/services/notification_service_impl.dart';
import 'presentation/providers/analytics_provider.dart';
import 'presentation/providers/badge_provider.dart';
import 'presentation/providers/content_provider.dart';
import 'presentation/providers/database_provider.dart';
import 'presentation/providers/error_report_provider.dart';
import 'presentation/providers/notification_provider.dart';
import 'presentation/providers/preferences_provider.dart';
import 'presentation/providers/srs_provider.dart';
import 'presentation/providers/streak_provider.dart';
import 'presentation/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final database = AppDatabase();
  final prefsSource = SharedPreferencesSource(prefs);
  final jsonLoader = JsonContentLoader();

  final importer = ContentImporter(
    database: database,
    jsonLoader: jsonLoader,
    prefsSource: prefsSource,
  );

  try {
    await importer.importIfNeeded();
  } catch (e) {
    debugPrint('Content import failed: $e');
  }

  final notificationService = NotificationServiceImpl();
  try {
    await notificationService.initialize();
  } catch (e) {
    debugPrint('Notification init failed: $e');
  }

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        contentRepositoryProvider.overrideWithValue(
          ContentRepositoryImpl(database.contentDao),
        ),
        errorReportRepositoryProvider.overrideWithValue(
          ErrorReportRepositoryImpl(database),
        ),
        sharedPreferencesSourceProvider.overrideWithValue(prefsSource),
        progressRepositoryProvider.overrideWithValue(
          ProgressRepositoryImpl(database.progressDao),
        ),
        streakRepositoryProvider.overrideWithValue(
          StreakRepositoryImpl(database.streakDao),
        ),
        badgeRepositoryProvider.overrideWithValue(
          BadgeRepositoryImpl(database.badgeDao),
        ),
        notificationServiceProvider.overrideWithValue(notificationService),
        analyticsServiceProvider.overrideWithValue(AnalyticsServiceImpl()),
      ],
      child: MufeedApp(
        router: createAppRouter(
          isOnboardingCompleted: prefsSource.isOnboardingCompleted,
        ),
      ),
    ),
  );
}
