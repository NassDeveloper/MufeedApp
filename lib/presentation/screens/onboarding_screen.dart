import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/animation_constants.dart';
import '../../domain/models/level_model.dart';
import '../../l10n/app_localizations.dart';
import '../providers/content_provider.dart';
import '../providers/mini_session_provider.dart';
import '../providers/onboarding_provider.dart';
import '../utils/localized_name.dart';
import '../widgets/arabic_text_widget.dart';
import '../widgets/error_content_widget.dart';
import '../widgets/skeleton_loader_widget.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: AnimationConstants.onboardingPageDuration,
      curve: AnimationConstants.onboardingPageCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen<OnboardingState>(onboardingProvider, (previous, next) {
      if (previous != null && previous.currentPage != next.currentPage) {
        _goToPage(next.currentPage);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  _WelcomePage(),
                  _LevelPage(),
                  _MiniSessionPage(),
                  _ConsentPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  if (state.currentPage > 0)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Semantics(
                        button: true,
                        label: l10n.onboardingPrevious,
                        child: TextButton.icon(
                          onPressed: () => ref
                              .read(onboardingProvider.notifier)
                              .previousPage(),
                          icon: const Icon(Icons.arrow_back, size: 18),
                          label: Text(l10n.onboardingPrevious),
                        ),
                      ),
                    ),
                  Semantics(
                    label: l10n.onboardingSemanticPage(
                      state.currentPage + 1,
                      OnboardingState.totalPages,
                    ),
                    excludeSemantics: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        OnboardingState.totalPages,
                        (index) => _PageDot(isActive: index == state.currentPage),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageDot extends StatelessWidget {
  const _PageDot({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _WelcomePage extends ConsumerWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(
            Icons.menu_book,
            size: 96,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            l10n.onboardingWelcomeTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingWelcomeSubtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () =>
                  ref.read(onboardingProvider.notifier).nextPage(),
              child: Text(l10n.onboardingStart),
            ),
          ),
        ],
      ),
    );
  }
}


class _LevelPage extends ConsumerWidget {
  const _LevelPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingProvider);
    final asyncLevels = ref.watch(levelsProvider);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            l10n.onboardingLevelTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingLevelSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: asyncLevels.when(
              loading: () => const SkeletonListLoader(itemCount: 5),
              error: (_, _) => ErrorContent(
                message: l10n.errorLoadingContent,
                onRetry: () => ref.invalidate(levelsProvider),
                retryLabel: l10n.retry,
              ),
              data: (levels) => ListView.builder(
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  final level = levels[index];
                  final locale = Localizations.localeOf(context);
                  final name = level.localizedName(locale);
                  final isSelected = state.selectedLevelId == level.id;

                  return Semantics(
                    button: true,
                    selected: isSelected,
                    label: l10n.onboardingSemanticLevel(
                      name,
                      l10n.unitCount(level.unitCount),
                    ),
                    excludeSemantics: true,
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: isSelected
                            ? BorderSide(
                                color:
                                    Theme.of(context).colorScheme.primary,
                                width: 2,
                              )
                            : BorderSide.none,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => ref
                            .read(onboardingProvider.notifier)
                            .setSelectedLevel(level.id),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${level.number}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge,
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: state.canProceed
                  ? () =>
                      ref.read(onboardingProvider.notifier).nextPage()
                  : null,
              child: Text(l10n.onboardingNext),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniSessionPage extends ConsumerWidget {
  const _MiniSessionPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncWords = ref.watch(miniSessionWordsProvider);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            l10n.onboardingMiniSessionTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingMiniSessionSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: asyncWords.when(
              loading: () => const SkeletonListLoader(itemCount: 3),
              error: (_, _) => ErrorContent(
                message: l10n.errorLoadingContent,
                onRetry: () => ref.invalidate(miniSessionWordsProvider),
                retryLabel: l10n.retry,
              ),
              data: (words) => ListView.separated(
                itemCount: words.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final word = words[index];
                  return Semantics(
                    label: '${word.arabic} : ${word.translationFr}',
                    excludeSemantics: true,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            ArabicText(
                              word.arabic,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              word.translationFr,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () =>
                  ref.read(onboardingProvider.notifier).nextPage(),
              child: Text(l10n.onboardingNext),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsentPage extends ConsumerStatefulWidget {
  const _ConsentPage();

  @override
  ConsumerState<_ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends ConsumerState<_ConsentPage>
    with SingleTickerProviderStateMixin {
  bool _showCelebration = false;
  late AnimationController _celebrationController;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _celebrationController,
        curve: Curves.elasticOut,
      ),
    );
    _opacityAnim = CurvedAnimation(
      parent: _celebrationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  Future<void> _complete(bool consent) async {
    ref.read(onboardingProvider.notifier).setGdprConsent(consent);
    try {
      await ref.read(onboardingProvider.notifier).completeOnboarding();
      if (!mounted) return;
      setState(() => _showCelebration = true);
      _celebrationController.forward();
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      if (mounted) context.go('/');
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorLoadingContent)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(onboardingProvider);
    final asyncLevels = ref.watch(levelsProvider);

    if (_showCelebration) {
      return Center(
        child: FadeTransition(
          opacity: _opacityAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 96,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.onboardingWelcomeTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _ConsentRecap(state: state, asyncLevels: asyncLevels, l10n: l10n),
                  const SizedBox(height: 24),
                  Icon(
                    Icons.privacy_tip_outlined,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.onboardingConsentTitle,
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.onboardingConsentDescription,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.push('/privacy-policy'),
                    child: Text(l10n.onboardingConsentViewPolicy),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _complete(true),
              child: Text(l10n.onboardingConsentAccept),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _complete(false),
              child: Text(l10n.onboardingConsentRefuse),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsentRecap extends StatelessWidget {
  const _ConsentRecap({
    required this.state,
    required this.asyncLevels,
    required this.l10n,
  });

  final OnboardingState state;
  final AsyncValue<List<LevelModel>> asyncLevels;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    String? levelName;
    if (asyncLevels case AsyncData(:final value)) {
      try {
        final level = value.firstWhere((l) => l.id == state.selectedLevelId);
        levelName = Localizations.localeOf(context).languageCode == 'fr'
            ? level.nameFr
            : level.nameEn;
      } catch (_) {
        levelName = null;
      }
    }

    if (levelName == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          l10n.onboardingConsentRecapLevel(levelName),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
