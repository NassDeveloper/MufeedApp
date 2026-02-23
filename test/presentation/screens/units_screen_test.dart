import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufeed_app/domain/models/unit_model.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/content_provider.dart';
import 'package:mufeed_app/presentation/screens/units_screen.dart';

void main() {
  group('UnitsScreen', () {
    testWidgets('shows skeleton loader while loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            unitsByLevelProvider(1).overrideWith(
              (ref) => Completer<List<UnitModel>>().future,
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: UnitsScreen(levelId: 1, levelName: 'Niveau 1'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('displays units when data is loaded', (tester) async {
      final units = [
        const UnitModel(
          id: 1,
          levelId: 1,
          number: 1,
          nameFr: 'Unité 1',
          nameEn: 'Unit 1',
        ),
        const UnitModel(
          id: 2,
          levelId: 1,
          number: 2,
          nameFr: 'Unité 2',
          nameEn: 'Unit 2',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            unitsByLevelProvider(1).overrideWith((ref) async => units),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: UnitsScreen(levelId: 1, levelName: 'Niveau 1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Unité 1'), findsOneWidget);
      expect(find.text('Unité 2'), findsOneWidget);
      expect(find.text('Niveau 1'), findsOneWidget);
    });

    testWidgets('shows error state with retry button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            unitsByLevelProvider(1).overrideWith(
              (ref) async => throw Exception('DB error'),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: UnitsScreen(levelId: 1, levelName: 'Niveau 1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Erreur de chargement du contenu'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('displays localized names based on locale', (tester) async {
      final units = [
        const UnitModel(
          id: 1,
          levelId: 1,
          number: 1,
          nameFr: 'Les bases',
          nameEn: 'The basics',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            unitsByLevelProvider(1).overrideWith((ref) async => units),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('en'),
            home: UnitsScreen(levelId: 1, levelName: 'Level 1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('The basics'), findsOneWidget);
    });
  });
}
