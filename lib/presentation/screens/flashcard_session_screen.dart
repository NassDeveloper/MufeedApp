import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/animation_constants.dart';
import '../../l10n/app_localizations.dart';
import '../providers/flashcard_session_provider.dart';
import '../utils/confirm_quit_session.dart';
import '../providers/preferences_provider.dart';
import '../widgets/evaluation_grid_widget.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/skeleton_loader_widget.dart';

class FlashcardSessionScreen extends ConsumerStatefulWidget {
  const FlashcardSessionScreen({required this.lessonId, super.key});

  final int lessonId;

  @override
  ConsumerState<FlashcardSessionScreen> createState() =>
      _FlashcardSessionScreenState();
}

class _FlashcardSessionScreenState
    extends ConsumerState<FlashcardSessionScreen> {
  late PageController _pageController;
  late FocusNode _focusNode;
  bool _isLoading = true;
  bool _isRating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _focusNode = FocusNode();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = ref.read(sharedPreferencesSourceProvider);
    final savedLessonId = prefs.getFlashcardSessionLessonId();
    final savedIndex = prefs.getFlashcardSessionIndex();

    int startIndex = 0;

    if (savedLessonId == widget.lessonId && savedIndex != null && mounted) {
      final shouldResume = await _showResumeDialog();
      if (shouldResume == true) {
        startIndex = savedIndex;
      }
    }

    final notifier = ref.read(flashcardSessionProvider.notifier);
    await notifier.startSession(widget.lessonId, startIndex: startIndex);

    if (mounted) {
      if (startIndex > 0) {
        _pageController.jumpToPage(startIndex);
      }
      setState(() => _isLoading = false);
      _focusNode.requestFocus();
    }
  }

  Future<bool?> _showResumeDialog() {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.flashcardResumeSession),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.flashcardResumeNo),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.flashcardResumeYes),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFlip() {
    ref.read(flashcardSessionProvider.notifier).flipCard();
  }

  void _onPageChanged(int index) {
    ref.read(flashcardSessionProvider.notifier).goToPage(index);
  }

  Future<void> _endSession() async {
    if (await confirmQuitSession(context)) {
      ref.read(flashcardSessionProvider.notifier).endSession();
      if (mounted) context.pop();
    }
  }

  Future<void> _onRating(int rating) async {
    if (_isRating) return;
    _isRating = true;

    try {
      final session = ref.read(flashcardSessionProvider);
      final wasLast = session?.isLast ?? false;

      final notifier = ref.read(flashcardSessionProvider.notifier);
      await notifier.rateCard(rating);

      final newSession = ref.read(flashcardSessionProvider);
      if (newSession != null && newSession.isCompleted) {
        if (mounted) {
          context.pushReplacement(
            '/session/summary/${widget.lessonId}',
          );
        }
      } else if (!wasLast) {
        _pageController.nextPage(
          duration: AnimationConstants.cardTransitionDuration,
          curve: AnimationConstants.flipCurve,
        );
      }
    } finally {
      _isRating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(flashcardSessionProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: Semantics(
            label: l10n.flashcardEndSession,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        body: const SkeletonListLoader(itemCount: 1),
      );
    }

    if (session == null || session.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(child: Text(l10n.flashcardEmpty)),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _endSession();
      },
      child: KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (event) => _handleKeyEvent(event, session),
      child: Scaffold(
        appBar: AppBar(
          leading: Semantics(
            label: l10n.flashcardEndSession,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: _endSession,
            ),
          ),
          title: Text(
            l10n.flashcardProgress(
              session.currentIndex + 1,
              session.totalItems,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Semantics(
                  label: l10n.flashcardSemanticCard(
                    session.currentIndex + 1,
                    session.totalItems,
                  ),
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: session.totalItems,
                    itemBuilder: (context, index) {
                      final item = session.items[index];
                      final isCurrentCard = index == session.currentIndex;
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: FlashcardWidget(
                          item: item,
                          isFlipped: isCurrentCard && session.isFlipped,
                          onFlip: isCurrentCard ? _onFlip : () {},
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (session.isFlipped)
                EvaluationGrid(onRating: (r) => _onRating(r)),
            ],
          ),
        ),
      ),
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event, FlashcardSessionState _) {
    if (event is! KeyDownEvent) return;

    // Read fresh state to avoid stale snapshot
    final session = ref.read(flashcardSessionProvider);
    if (session == null) return;

    final notifier = ref.read(flashcardSessionProvider.notifier);

    // Rating keys 1-4 when card is flipped
    if (session.isFlipped) {
      if (event.logicalKey == LogicalKeyboardKey.digit1) {
        _onRating(1);
        return;
      } else if (event.logicalKey == LogicalKeyboardKey.digit2) {
        _onRating(2);
        return;
      } else if (event.logicalKey == LogicalKeyboardKey.digit3) {
        _onRating(3);
        return;
      } else if (event.logicalKey == LogicalKeyboardKey.digit4) {
        _onRating(4);
        return;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.space) {
      notifier.flipCard();
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (!session.isLast) {
        notifier.nextCard();
        _pageController.nextPage(
          duration: AnimationConstants.cardTransitionDuration,
          curve: AnimationConstants.flipCurve,
        );
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (!session.isFirst) {
        notifier.previousCard();
        _pageController.previousPage(
          duration: AnimationConstants.cardTransitionDuration,
          curve: AnimationConstants.flipCurve,
        );
      }
    }
  }
}
