import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mufeed_app/data/datasources/shared_preferences_source.dart';
import 'package:mufeed_app/domain/models/lesson_model.dart';
import 'package:mufeed_app/domain/models/lesson_progress_model.dart';
import 'package:mufeed_app/l10n/app_localizations.dart';
import 'package:mufeed_app/presentation/providers/content_provider.dart';
import 'package:mufeed_app/presentation/providers/preferences_provider.dart';
import 'package:mufeed_app/presentation/providers/progress_provider.dart';
import 'package:mufeed_app/presentation/screens/lessons_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LessonsScreen', () {
    testWidgets('shows skeleton loader while loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            lessonsByUnitProvider(1).overrideWith(
              (ref) => Completer<List<LessonModel>>().future,
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: LessonsScreen(levelId: 1, unitId: 1, unitName: 'Unité 1'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('displays lessons when data is loaded', (tester) async {
      final lessons = [
        const LessonModel(
          id: 1,
          unitId: 1,
          number: 1,
          nameFr: 'Les salutations',
          nameEn: 'Greetings',
        ),
        const LessonModel(
          id: 2,
          unitId: 1,
          number: 2,
          nameFr: 'Les chiffres',
          nameEn: 'Numbers',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            lessonsByUnitProvider(1).overrideWith((ref) async => lessons),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: LessonsScreen(levelId: 1, unitId: 1, unitName: 'Unité 1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Les salutations'), findsOneWidget);
      expect(find.text('Les chiffres'), findsOneWidget);
      expect(find.text('Unité 1'), findsOneWidget);
    });

    testWidgets('shows error state with retry button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            lessonsByUnitProvider(1).overrideWith(
              (ref) async => throw Exception('DB error'),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: LessonsScreen(levelId: 1, unitId: 1, unitName: 'Unité 1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Erreur de chargement du contenu'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('lesson cards are interactive with button semantics and chevron',
        (tester) async {
      final lessons = [
        const LessonModel(
          id: 1,
          unitId: 1,
          number: 1,
          nameFr: 'Les salutations',
          nameEn: 'Greetings',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            lessonsByUnitProvider(1).overrideWith((ref) async => lessons),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: LessonsScreen(levelId: 1, unitId: 1, unitName: 'Unité 1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('tapping lesson card navigates to lesson detail',
        (tester) async {
      final lessons = [
        const LessonModel(
          id: 42,
          unitId: 1,
          number: 1,
          nameFr: 'Les salutations',
          nameEn: 'Greetings',
        ),
      ];

      String? pushedRoute;
      final router = GoRouter(
        initialLocation: '/lessons',
        routes: [
          GoRoute(
            path: '/lessons',
            builder: (_, _) => const LessonsScreen(
              levelId: 1,
              unitId: 1,
              unitName: 'Unité 1',
            ),
          ),
          GoRoute(
            path: '/vocabulary/level/:levelId/unit/:unitId/lesson/:lessonId',
            builder: (_, state) {
              pushedRoute = state.uri.toString();
              return const Scaffold(body: Text('Detail'));
            },
          ),
        ],
      );

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            lessonsByUnitProvider(1).overrideWith((ref) async => lessons),
            sharedPreferencesSourceProvider
                .overrideWithValue(SharedPreferencesSource(prefs)),
          ],
          child: MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('fr'),
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Les salutations'));
      await tester.pumpAndSettle();

      expect(pushedRoute, '/vocabulary/level/1/unit/1/lesson/42');
    });

    testWidgets('shows progress indicator when mastered count > 0',
        (tester) async {
      final lessons = [
        const LessonModel(
          id: 1,
          unitId: 1,
          number: 1,
          nameFr: 'Les salutations',
          nameEn: 'Greetings',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            lessonsByUnitProvider(1).overrideWith((ref) async => lessons),
            lessonProgressProvider(1).overrideWith(
              (ref) async => const LessonProgressModel(
                totalItems: 20,
                masteredCount: 12,
              ),
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: LessonsScreen(levelId: 1, unitId: 1, unitName: 'Unité 1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Progress is shown as a circular ring (CircularProgressIndicator) with
      // a non-zero value when mastered count > 0.
      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(progressIndicator.value, greaterThan(0));
    });
  });
}
