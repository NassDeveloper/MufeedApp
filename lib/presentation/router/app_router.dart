import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../screens/exercises_screen.dart';
import '../screens/home_screen.dart';
import '../screens/lesson_detail_screen.dart';
import '../screens/lessons_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/units_screen.dart';
import '../screens/flashcard_session_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/quiz_summary_screen.dart';
import '../screens/session_summary_screen.dart';
import '../screens/daily_session_screen.dart';
import '../screens/daily_summary_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/vocabulary_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter({
  required bool Function() isOnboardingCompleted,
}) => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (context, state) {
    final onboardingCompleted = isOnboardingCompleted();
    final isOnboarding = state.matchedLocation == '/onboarding';

    if (!onboardingCompleted && !isOnboarding) return '/onboarding';
    if (onboardingCompleted && isOnboarding) return '/';
    return null;
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/privacy-policy',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: '/session/daily',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DailySessionScreen(),
    ),
    GoRoute(
      path: '/session/daily-summary',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DailySummaryScreen(),
    ),
    GoRoute(
      path: '/session/flashcard/:lessonId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final lessonId = int.parse(state.pathParameters['lessonId']!);
        return FlashcardSessionScreen(lessonId: lessonId);
      },
    ),
    GoRoute(
      path: '/session/quiz/:lessonId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final lessonId = int.parse(state.pathParameters['lessonId']!);
        return QuizScreen(lessonId: lessonId);
      },
    ),
    GoRoute(
      path: '/session/quiz-summary/:lessonId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final lessonId = int.parse(state.pathParameters['lessonId']!);
        return QuizSummaryScreen(lessonId: lessonId);
      },
    ),
    GoRoute(
      path: '/session/summary/:lessonId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final lessonId = int.parse(state.pathParameters['lessonId']!);
        return SessionSummaryScreen(lessonId: lessonId);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/vocabulary',
              builder: (context, state) => const VocabularyScreen(),
              routes: [
                GoRoute(
                  path: 'level/:levelId',
                  builder: (context, state) {
                    final levelId =
                        int.parse(state.pathParameters['levelId']!);
                    final levelName = state.extra as String? ??
                        AppLocalizations.of(context)!.levelTitle(levelId);
                    return UnitsScreen(
                        levelId: levelId, levelName: levelName);
                  },
                  routes: [
                    GoRoute(
                      path: 'unit/:unitId',
                      builder: (context, state) {
                        final unitId =
                            int.parse(state.pathParameters['unitId']!);
                        final levelId =
                            int.parse(state.pathParameters['levelId']!);
                        final unitName = state.extra as String? ??
                            AppLocalizations.of(context)!.unitTitle(unitId);
                        return LessonsScreen(
                            levelId: levelId,
                            unitId: unitId,
                            unitName: unitName);
                      },
                      routes: [
                        GoRoute(
                          path: 'lesson/:lessonId',
                          builder: (context, state) {
                            final lessonId = int.parse(
                                state.pathParameters['lessonId']!);
                            final lessonName = state.extra as String? ??
                                AppLocalizations.of(context)!
                                    .lessonTitle(lessonId);
                            return LessonDetailScreen(
                              lessonId: lessonId,
                              lessonName: lessonName,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/exercises',
              builder: (context, state) => const ExercisesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/statistics',
              builder: (context, state) => const StatisticsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 1024;
    final l10n = AppLocalizations.of(context)!;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onTap,
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home),
                  label: Text(l10n.tabHome),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.menu_book_outlined),
                  selectedIcon: const Icon(Icons.menu_book),
                  label: Text(l10n.tabVocabulary),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.quiz_outlined),
                  selectedIcon: const Icon(Icons.quiz),
                  label: Text(l10n.tabExercises),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.bar_chart_outlined),
                  selectedIcon: const Icon(Icons.bar_chart),
                  label: Text(l10n.tabStatistics),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l10n.tabVocabulary,
          ),
          NavigationDestination(
            icon: const Icon(Icons.quiz_outlined),
            selectedIcon: const Icon(Icons.quiz),
            label: l10n.tabExercises,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: l10n.tabStatistics,
          ),
        ],
      ),
    );
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
