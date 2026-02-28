import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/daily_activity_model.dart';
import 'package:mufeed_app/domain/models/progress_stats_model.dart';
import 'package:mufeed_app/domain/models/upcoming_reviews_model.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/badge_provider.dart';
import 'package:mufeed_app/presentation/providers/progress_provider.dart';
import 'package:mufeed_app/presentation/screens/statistics_screen.dart';

void main() {
  group('StatisticsScreen', () {
    testWidgets('shows skeleton loader while loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            progressStatsProvider.overrideWith(
              (ref) => Completer<ProgressStatsModel>().future,
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: StatisticsScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('shows empty state when no sessions completed',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            progressStatsProvider.overrideWith(
              (ref) async => const ProgressStatsModel(
                totalItems: 100,
                newCount: 100,
                learningCount: 0,
                reviewCount: 0,
                relearningCount: 0,
                sessionCount: 0,
                vocabStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
                verbStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
              ),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('révision'), findsOneWidget);
      expect(find.text('Commencer à réviser'), findsOneWidget);
    });

    testWidgets('shows stats when data is available', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            progressStatsProvider.overrideWith(
              (ref) async => const ProgressStatsModel(
                totalItems: 100,
                newCount: 50,
                learningCount: 20,
                reviewCount: 25,
                relearningCount: 5,
                sessionCount: 3,
                vocabStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
                verbStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
              ),
            ),
            allBadgesProvider.overrideWith((ref) async => []),
            recentActivityProvider.overrideWith((ref) async => []),
            upcomingReviewsProvider.overrideWith(
              (ref) async => const UpcomingReviewsModel(
                dueToday: 0,
                dueTomorrow: 0,
                dueThisWeek: 0,
              ),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Vue d\'ensemble'), findsOneWidget);
      expect(find.text('Nouveau'), findsOneWidget);
      expect(find.text('En apprentissage'), findsWidgets);
      expect(find.text('Maîtrisé'), findsWidgets);
      expect(find.text('À revoir'), findsWidgets);
      expect(find.text('50'), findsWidgets);
      expect(find.text('20'), findsWidgets);
      expect(find.text('25'), findsWidgets);
      expect(find.text('5'), findsWidgets);
    });

    testWidgets('shows activity section title when data available',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            progressStatsProvider.overrideWith(
              (ref) async => const ProgressStatsModel(
                totalItems: 100,
                newCount: 50,
                learningCount: 20,
                reviewCount: 25,
                relearningCount: 5,
                sessionCount: 3,
                vocabStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
                verbStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
              ),
            ),
            allBadgesProvider.overrideWith((ref) async => []),
            recentActivityProvider.overrideWith(
              (ref) async => List.generate(
                14,
                (i) => DailyActivityModel(
                  date: DateTime.now().subtract(Duration(days: 13 - i)),
                  count: i,
                ),
              ),
            ),
            upcomingReviewsProvider.overrideWith(
              (ref) async => const UpcomingReviewsModel(
                dueToday: 5,
                dueTomorrow: 3,
                dueThisWeek: 12,
              ),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Activité des 14 derniers jours'), findsOneWidget);
      expect(find.text('Révisions à venir'), findsOneWidget);
      expect(find.text('Aujourd\'hui'), findsOneWidget);
    });

    testWidgets('shows no reviews pending message when all zeros',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            progressStatsProvider.overrideWith(
              (ref) async => const ProgressStatsModel(
                totalItems: 100,
                newCount: 50,
                learningCount: 20,
                reviewCount: 25,
                relearningCount: 5,
                sessionCount: 3,
                vocabStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
                verbStats: ContentTypeStats(totalItems: 0, newCount: 0, learningCount: 0, reviewCount: 0, relearningCount: 0),
              ),
            ),
            allBadgesProvider.overrideWith((ref) async => []),
            recentActivityProvider.overrideWith((ref) async => []),
            upcomingReviewsProvider.overrideWith(
              (ref) async => const UpcomingReviewsModel(
                dueToday: 0,
                dueTomorrow: 0,
                dueThisWeek: 0,
              ),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Aucune révision en attente'),
        200,
      );
      expect(find.text('Aucune révision en attente'), findsOneWidget);
    });

    testWidgets('shows error state with retry button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            progressStatsProvider.overrideWith(
              (ref) async => throw Exception('DB error'),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: StatisticsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Erreur de chargement du contenu'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);
    });
  });
}
