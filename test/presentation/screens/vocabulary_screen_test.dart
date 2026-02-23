import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/level_model.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/content_provider.dart';
import 'package:mufeed_app/presentation/screens/vocabulary_screen.dart';

void main() {
  group('VocabularyScreen', () {
    testWidgets('shows skeleton loader while loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            levelsProvider.overrideWith(
              (ref) => Completer<List<LevelModel>>().future,
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: Scaffold(body: VocabularyScreen()),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('displays levels when data is loaded', (tester) async {
      final levels = [
        const LevelModel(
          id: 1,
          number: 1,
          nameFr: 'Niveau 1',
          nameEn: 'Level 1',
          nameAr: 'المستوى الأول',
          unitCount: 3,
        ),
        const LevelModel(
          id: 2,
          number: 2,
          nameFr: 'Niveau 2',
          nameEn: 'Level 2',
          nameAr: 'المستوى الثاني',
          unitCount: 4,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            levelsProvider.overrideWith((ref) async => levels),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: Scaffold(body: VocabularyScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Niveau 1'), findsOneWidget);
      expect(find.text('Niveau 2'), findsOneWidget);
      expect(find.text('3 unités'), findsOneWidget);
      expect(find.text('4 unités'), findsOneWidget);
    });

    testWidgets('displays singular unit count correctly', (tester) async {
      final levels = [
        const LevelModel(
          id: 1,
          number: 1,
          nameFr: 'Niveau 1',
          nameEn: 'Level 1',
          nameAr: 'المستوى الأول',
          unitCount: 1,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            levelsProvider.overrideWith((ref) async => levels),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: Scaffold(body: VocabularyScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1 unité'), findsOneWidget);
    });

    testWidgets('displays localized names based on locale', (tester) async {
      final levels = [
        const LevelModel(
          id: 1,
          number: 1,
          nameFr: 'Les bases',
          nameEn: 'The basics',
          nameAr: 'الأساسيات',
          unitCount: 2,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            levelsProvider.overrideWith((ref) async => levels),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('en'),
            home: Scaffold(body: VocabularyScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('The basics'), findsOneWidget);
    });

    testWidgets('shows error state with retry button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            levelsProvider.overrideWith(
              (ref) async => throw Exception('DB error'),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: Scaffold(body: VocabularyScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Erreur de chargement du contenu'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });
}
