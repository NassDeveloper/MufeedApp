import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/animation_constants.dart';
import '../../domain/models/verb_model.dart';
import '../../domain/models/word_model.dart';
import '../providers/content_provider.dart';

const int _kMinPairs = 4;
const int _kMaxPairs = 6;

@immutable
class MatchingPair {
  const MatchingPair({
    required this.pairId,
    required this.itemId,
    required this.contentType,
    required this.arabic,
    required this.french,
    this.isMatched = false,
  });

  final int pairId;
  final int itemId;
  final String contentType;
  final String arabic;
  final String french;
  final bool isMatched;

  MatchingPair copyWith({bool? isMatched}) => MatchingPair(
        pairId: pairId,
        itemId: itemId,
        contentType: contentType,
        arabic: arabic,
        french: french,
        isMatched: isMatched ?? this.isMatched,
      );
}

@immutable
class MatchingSessionState {
  const MatchingSessionState({
    required this.pairs,
    required this.frenchOrder,
    required this.startedAt,
    required this.lessonId,
    this.selectedArabicPairId,
    this.selectedFrenchPairId,
    this.flashingPairIds = const {},
    this.isCompleted = false,
  });

  /// Source truth for pairs. arabicCards = pairs in order.
  final List<MatchingPair> pairs;

  /// frenchOrder[i] = index in [pairs] for the i-th French card slot.
  final List<int> frenchOrder;

  final DateTime startedAt;
  final int lessonId;

  /// pairId of the currently selected Arabic card (null = none).
  final int? selectedArabicPairId;

  /// pairId of the currently selected French card (null = none).
  final int? selectedFrenchPairId;

  /// pairIds currently flashing red after a wrong match attempt.
  final Set<int> flashingPairIds;

  final bool isCompleted;

  int get totalPairs => pairs.length;
  int get matchedCount => pairs.where((p) => p.isMatched).length;

  MatchingSessionState copyWith({
    List<MatchingPair>? pairs,
    List<int>? frenchOrder,
    int? lessonId,
    DateTime? startedAt,
    Object? selectedArabicPairId = _sentinel,
    Object? selectedFrenchPairId = _sentinel,
    Set<int>? flashingPairIds,
    bool? isCompleted,
  }) {
    return MatchingSessionState(
      pairs: pairs ?? this.pairs,
      frenchOrder: frenchOrder ?? this.frenchOrder,
      lessonId: lessonId ?? this.lessonId,
      startedAt: startedAt ?? this.startedAt,
      selectedArabicPairId: selectedArabicPairId == _sentinel
          ? this.selectedArabicPairId
          : selectedArabicPairId as int?,
      selectedFrenchPairId: selectedFrenchPairId == _sentinel
          ? this.selectedFrenchPairId
          : selectedFrenchPairId as int?,
      flashingPairIds: flashingPairIds ?? this.flashingPairIds,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// Sentinel object for nullable copyWith fields
const _sentinel = Object();

class MatchingSessionNotifier extends Notifier<MatchingSessionState?> {
  Timer? _flashTimer;

  @override
  MatchingSessionState? build() => null;

  /// Loads words + verbs for [lessonId], samples up to [_kMaxPairs] items,
  /// and builds the initial session state.
  /// Sets state to null if fewer than [_kMinPairs] items are available.
  Future<void> startSession(int lessonId) async {
    final repo = ref.read(contentRepositoryProvider);
    final results = await Future.wait([
      repo.getWordsByLessonId(lessonId),
      repo.getVerbsByLessonId(lessonId),
    ]);
    final words = results[0] as List<WordModel>;
    final verbs = results[1] as List<VerbModel>;

    final allPairs = <MatchingPair>[];
    for (final w in words) {
      allPairs.add(MatchingPair(
        pairId: allPairs.length,
        itemId: w.id,
        contentType: 'vocab',
        arabic: w.arabic,
        french: w.translationFr,
      ));
    }
    for (final v in verbs) {
      allPairs.add(MatchingPair(
        pairId: allPairs.length,
        itemId: v.id,
        contentType: 'verb',
        // Show past tense on Arabic side (consistent with flashcards)
        arabic: v.past,
        french: v.translationFr,
      ));
    }

    if (allPairs.length < _kMinPairs) {
      state = null;
      return;
    }

    // Random sample capped at _kMaxPairs
    final rng = Random();
    final selected = List<MatchingPair>.from(allPairs)..shuffle(rng);
    final capped = selected.take(_kMaxPairs).toList();

    // Re-assign contiguous pairIds
    final pairs = [
      for (var i = 0; i < capped.length; i++)
        MatchingPair(
          pairId: i,
          itemId: capped[i].itemId,
          contentType: capped[i].contentType,
          arabic: capped[i].arabic,
          french: capped[i].french,
        ),
    ];

    final frenchOrder = List.generate(pairs.length, (i) => i)..shuffle(rng);

    state = MatchingSessionState(
      pairs: List.unmodifiable(pairs),
      frenchOrder: List.unmodifiable(frenchOrder),
      startedAt: DateTime.now(),
      lessonId: lessonId,
    );
  }

  /// Called when the user taps an Arabic card with [pairId].
  void tapArabic(int pairId) {
    if (state == null) return;
    final s = state!;
    final pair = s.pairs[pairId];
    if (pair.isMatched || s.flashingPairIds.isNotEmpty) return;

    // Toggle selection
    if (s.selectedArabicPairId == pairId) {
      state = s.copyWith(selectedArabicPairId: null);
      return;
    }

    state = s.copyWith(selectedArabicPairId: pairId);
    _tryMatch();
  }

  /// Called when the user taps a French card at [frenchSlotIndex].
  void tapFrench(int frenchSlotIndex) {
    if (state == null) return;
    final s = state!;
    final pairId = s.frenchOrder[frenchSlotIndex];
    if (s.pairs[pairId].isMatched || s.flashingPairIds.isNotEmpty) return;

    // Toggle selection
    if (s.selectedFrenchPairId == pairId) {
      state = s.copyWith(selectedFrenchPairId: null);
      return;
    }

    state = s.copyWith(selectedFrenchPairId: pairId);
    _tryMatch();
  }

  void _tryMatch() {
    final s = state;
    if (s == null) return;
    final arabicId = s.selectedArabicPairId;
    final frenchId = s.selectedFrenchPairId;
    if (arabicId == null || frenchId == null) return;

    if (arabicId == frenchId) {
      // Correct match
      final newPairs = [
        for (final p in s.pairs)
          if (p.pairId == arabicId) p.copyWith(isMatched: true) else p,
      ];
      final completed =
          newPairs.every((p) => p.isMatched);
      state = s.copyWith(
        pairs: List.unmodifiable(newPairs),
        selectedArabicPairId: null,
        selectedFrenchPairId: null,
        isCompleted: completed,
      );
    } else {
      // Wrong match — flash both cards red
      state = s.copyWith(
        flashingPairIds: {arabicId, frenchId},
        selectedArabicPairId: null,
        selectedFrenchPairId: null,
      );
      _flashTimer?.cancel();
      _flashTimer = Timer(
        AnimationConstants.matchingFlashDuration,
        _clearFlash,
      );
    }
  }

  void _clearFlash() {
    if (!ref.mounted) return;
    if (state == null) return;
    state = state!.copyWith(flashingPairIds: {});
  }

  void endSession() {
    _flashTimer?.cancel();
    state = null;
  }
}

final matchingSessionProvider =
    NotifierProvider<MatchingSessionNotifier, MatchingSessionState?>(() {
  return MatchingSessionNotifier();
});
