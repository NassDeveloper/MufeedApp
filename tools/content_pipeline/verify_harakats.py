#!/usr/bin/env python3
"""Verify Arabic harakats (diacritical marks) in MufeedApp content.

Usage:
    python verify_harakats.py <level_dir>
    python verify_harakats.py assets/data/level_01

Checks:
- Words/verbs with NO harakats at all
- Words/verbs with potentially INCOMPLETE harakats (low diacritics-to-letter ratio)
- Per-character Unicode analysis for flagged words

Exit codes:
    0 = all words have harakats
    1 = issues found
"""

import json
import os
import sys
import unicodedata

# Arabic harakat (diacritical marks) — comprehensive set
HARAKAT = {
    0x064B: "Fathatan (ً)",
    0x064C: "Dammatan (ٌ)",
    0x064D: "Kasratan (ٍ)",
    0x064E: "Fathah (َ)",
    0x064F: "Dammah (ُ)",
    0x0650: "Kasrah (ِ)",
    0x0651: "Shaddah (ّ)",
    0x0652: "Sukun (ْ)",
    0x0653: "Maddah above",
    0x0654: "Hamza above",
    0x0655: "Hamza below",
    0x0656: "Subscript Alef",
    0x0657: "Inverted Damma",
    0x0658: "Mark Noon Ghunna",
    0x0659: "Zwarakay",
    0x065A: "Vowel Sign Small V Above",
    0x065B: "Vowel Sign Inverted Small V Above",
    0x065C: "Vowel Sign Dot Below",
    0x065D: "Reversed Damma",
    0x065E: "Fatha with Two Dots",
    0x065F: "Wavy Hamza Below",
    0x0670: "Superscript Alef (ٰ)",
}

# Alef with built-in marks (don't need separate harakat)
ALEF_VARIANTS = {
    0x0622,  # Alef with Madda above (آ)
    0x0623,  # Alef with Hamza above (أ)
    0x0625,  # Alef with Hamza below (إ)
}

# Minimum ratio of harakats per letter to consider "complete"
# Most Arabic words have roughly 1 harakat per letter (sometimes less due to alef, lam-alef, etc.)
MIN_HARAKAT_RATIO = 0.3  # warning threshold — below this is suspicious
MISSING_THRESHOLD = 0.0  # error — zero harakats


def count_arabic_letters(text):
    """Count actual Arabic letters (excluding harakats and non-letter chars)."""
    count = 0
    for ch in text:
        cp = ord(ch)
        if cp in HARAKAT:
            continue
        if ch in (" ", "\u200C", "\u200D"):
            continue
        cat = unicodedata.category(ch)
        if cat.startswith("L") and 0x0600 <= cp <= 0x08FF:
            count += 1
        elif cat.startswith("L") and 0xFB50 <= cp <= 0xFEFF:
            count += 1
    return count


def count_harakat(text):
    """Count harakats in text."""
    return sum(1 for ch in text if ord(ch) in HARAKAT)


def count_alef_variants(text):
    """Count alef variants that have built-in marks."""
    return sum(1 for ch in text if ord(ch) in ALEF_VARIANTS)


def unicode_analysis(text):
    """Return per-character Unicode analysis string."""
    parts = []
    for ch in text:
        cp = ord(ch)
        name = unicodedata.name(ch, f"U+{cp:04X}")
        if cp in HARAKAT:
            parts.append(f"  [{ch}] U+{cp:04X} {name} (HARAKAT)")
        elif ch == " ":
            parts.append(f"  [ ] U+0020 SPACE")
        else:
            parts.append(f"  [{ch}] U+{cp:04X} {name}")
    return "\n".join(parts)


class HarakatReport:
    """Collect harakats verification results."""

    def __init__(self):
        self.errors = []    # no harakats at all
        self.warnings = []  # low ratio

    def error(self, file, index, field, text, letters, harakats):
        self.errors.append({
            "file": file,
            "index": index,
            "field": field,
            "text": text,
            "letters": letters,
            "harakats": harakats,
        })

    def warning(self, file, index, field, text, letters, harakats, ratio):
        self.warnings.append({
            "file": file,
            "index": index,
            "field": field,
            "text": text,
            "letters": letters,
            "harakats": harakats,
            "ratio": ratio,
        })

    @property
    def has_issues(self):
        return len(self.errors) > 0 or len(self.warnings) > 0

    def print_report(self, verbose=False):
        print(f"\n{'=' * 60}")
        print(f"HARAKATS VERIFICATION — {len(self.errors)} error(s), {len(self.warnings)} warning(s)")
        print(f"{'=' * 60}")

        if self.errors:
            print("\nMISSING HARAKATS (no diacritics at all):")
            for e in self.errors:
                print(f"  [{e['file']}#{e['index']}] {e['field']}: {e['text']!r}")
                print(f"    Letters: {e['letters']}, Harakats: {e['harakats']}")
                if verbose:
                    print(f"    Unicode analysis:")
                    print(unicode_analysis(e["text"]))

        if self.warnings:
            print("\nINCOMPLETE HARAKATS (low diacritics-to-letter ratio):")
            for w in self.warnings:
                print(f"  [{w['file']}#{w['index']}] {w['field']}: {w['text']!r}")
                print(f"    Letters: {w['letters']}, Harakats: {w['harakats']}, Ratio: {w['ratio']:.2f}")
                if verbose:
                    print(f"    Unicode analysis:")
                    print(unicode_analysis(w["text"]))

        if not self.has_issues:
            print("\nAll Arabic text has harakats.")
        print()


def check_field(text, file, index, field, report):
    """Check a single Arabic field for harakats."""
    if not text or not isinstance(text, str):
        return

    letters = count_arabic_letters(text)
    harakats = count_harakat(text)
    alef_variants = count_alef_variants(text)

    if letters == 0:
        return  # not Arabic text

    # Effective letters that need harakats (subtract alef variants)
    effective = max(letters - alef_variants, 1)

    if harakats == 0:
        report.error(file, index, field, text, letters, harakats)
    else:
        ratio = harakats / effective
        if ratio < MIN_HARAKAT_RATIO:
            report.warning(file, index, field, text, letters, harakats, ratio)


def verify_words(words, report):
    """Check harakats in words.json entries."""
    if not isinstance(words, list):
        return

    for i, word in enumerate(words):
        if not isinstance(word, dict):
            continue
        check_field(word.get("arabic"), "words.json", i, "arabic", report)
        # Also check optional Arabic fields
        for field in ("singular", "plural"):
            check_field(word.get(field), "words.json", i, field, report)


def verify_verbs(verbs, report):
    """Check harakats in verbs.json entries."""
    if not isinstance(verbs, list):
        return

    for i, verb in enumerate(verbs):
        if not isinstance(verb, dict):
            continue
        for field in ("masdar", "past", "present", "imperative"):
            check_field(verb.get(field), "verbs.json", i, field, report)


def verify_level_dir(level_dir, verbose=False):
    """Verify harakats in all content files of a level directory."""
    report = HarakatReport()

    if not os.path.isdir(level_dir):
        print(f"ERROR: Directory not found: {level_dir}")
        return report

    # Words
    words_path = os.path.join(level_dir, "words.json")
    if os.path.exists(words_path):
        try:
            with open(words_path, "r", encoding="utf-8") as f:
                words = json.load(f)
            verify_words(words, report)
        except json.JSONDecodeError as e:
            print(f"ERROR: Invalid JSON in {words_path}: {e}")

    # Verbs
    verbs_path = os.path.join(level_dir, "verbs.json")
    if os.path.exists(verbs_path):
        try:
            with open(verbs_path, "r", encoding="utf-8") as f:
                verbs = json.load(f)
            verify_verbs(verbs, report)
        except json.JSONDecodeError as e:
            print(f"ERROR: Invalid JSON in {verbs_path}: {e}")

    report.print_report(verbose=verbose)
    return report


def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} [-v] <level_dir> [level_dir2 ...]")
        print(f"  -v  Verbose mode: show Unicode analysis for flagged words")
        print(f"Example: {sys.argv[0]} assets/data/level_01")
        sys.exit(1)

    verbose = "-v" in sys.argv
    dirs = [a for a in sys.argv[1:] if a != "-v"]

    has_issues = False
    for level_dir in dirs:
        print(f"\nVerifying harakats: {level_dir}")
        print("-" * 40)
        report = verify_level_dir(level_dir, verbose=verbose)
        if report.has_issues:
            has_issues = True

    sys.exit(1 if has_issues else 0)


if __name__ == "__main__":
    main()
