import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/progress_stats_model.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
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
      expect(find.text('En apprentissage'), findsOneWidget);
      expect(find.text('Maîtrisé'), findsOneWidget);
      expect(find.text('À revoir'), findsOneWidget);
      expect(find.text('50'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
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
