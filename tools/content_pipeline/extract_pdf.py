#!/usr/bin/env python3
"""Extract vocabulary from Centre Al-Furqan PDF into MufeedApp JSON format.

Usage:
    python extract_pdf.py <pdf_file> <output_dir> [--level N]

    python extract_pdf.py book_level_02.pdf assets/data/level_02 --level 2

This script extracts Arabic vocabulary (words and verbs) from PDF files
and outputs them in the MufeedApp JSON format:
  - metadata.json (level, units, lessons structure)
  - words.json (vocabulary entries)
  - verbs.json (verb conjugation entries)

The extracted content will likely need manual review and correction before
integration into the app. Use validate_content.py and verify_harakats.py
to validate after extraction.

Dependencies:
    pip install -r requirements.txt
    (pdfplumber)

Exit codes:
    0 = extraction successful
    1 = error
"""

import json
import os
import re
import sys
import unicodedata

try:
    import pdfplumber
except ImportError:
    print("ERROR: pdfplumber is required. Install with:")
    print("  pip install pdfplumber")
    print("  or: pip install -r tools/content_pipeline/requirements.txt")
    sys.exit(1)


# Arabic Unicode ranges
ARABIC_LETTER_RANGE = [(0x0621, 0x064A), (0x066E, 0x06D3)]
HARAKAT_RANGE = [(0x064B, 0x065F), (0x0670, 0x0670)]


def is_arabic_letter(ch):
    """Check if character is an Arabic letter."""
    cp = ord(ch)
    return any(start <= cp <= end for start, end in ARABIC_LETTER_RANGE)


def is_harakat(ch):
    """Check if character is a harakat."""
    cp = ord(ch)
    return any(start <= cp <= end for start, end in HARAKAT_RANGE)


def contains_arabic(text):
    """Check if text contains Arabic characters."""
    return any(is_arabic_letter(ch) for ch in text)


def extract_arabic_segments(text):
    """Extract Arabic text segments from a mixed line."""
    segments = []
    current = []
    for ch in text:
        if is_arabic_letter(ch) or is_harakat(ch) or ch in (" ", "\u200C", "\u200D"):
            current.append(ch)
        elif unicodedata.category(ch).startswith("M"):
            current.append(ch)
        else:
            if current:
                seg = "".join(current).strip()
                if seg and contains_arabic(seg):
                    segments.append(seg)
                current = []
            # Collect non-Arabic segment separately
    if current:
        seg = "".join(current).strip()
        if seg and contains_arabic(seg):
            segments.append(seg)
    return segments


def extract_french_segments(text):
    """Extract French/Latin text segments from a mixed line."""
    segments = []
    current = []
    for ch in text:
        if is_arabic_letter(ch) or is_harakat(ch):
            if current:
                seg = "".join(current).strip()
                if seg:
                    segments.append(seg)
                current = []
        else:
            cp = ord(ch)
            if cp < 0x0600 or cp > 0x08FF:
                current.append(ch)
    if current:
        seg = "".join(current).strip()
        if seg:
            segments.append(seg)
    return segments


def extract_text_from_pdf(pdf_path):
    """Extract all text from a PDF file, preserving Arabic."""
    pages_text = []
    with pdfplumber.open(pdf_path) as pdf:
        for page in pdf.pages:
            text = page.extract_text()
            if text:
                pages_text.append(text)
    return pages_text


def parse_vocabulary_lines(pages_text):
    """Parse extracted text into raw vocabulary entries.

    This is a heuristic parser that attempts to identify word entries.
    The output will need manual review.
    """
    entries = []

    for page_num, page_text in enumerate(pages_text, 1):
        lines = page_text.split("\n")

        for line in lines:
            line = line.strip()
            if not line:
                continue

            # Skip header/footer lines (numbers only, page numbers, etc.)
            if re.match(r"^\d+$", line):
                continue

            # Look for lines containing both Arabic and French text
            arabic_segs = extract_arabic_segments(line)
            french_segs = extract_french_segments(line)

            if arabic_segs and french_segs:
                # Filter out very short French segments (likely numbers or noise)
                french_segs = [s for s in french_segs if len(s) > 1]
                if french_segs:
                    entries.append({
                        "arabic_segments": arabic_segs,
                        "french_segments": french_segs,
                        "page": page_num,
                        "raw_line": line,
                    })

    return entries


def classify_entry(entry):
    """Attempt to classify an entry as word or verb.

    Verb entries typically have 4 Arabic forms (masdar, past, present, imperative).
    Word entries have 1-2 Arabic forms (base, possibly plural).
    """
    arabic_count = len(entry["arabic_segments"])

    if arabic_count >= 4:
        return "verb"
    else:
        return "word"


def build_word_entry(entry, unit, lesson, sort_order):
    """Build a word JSON entry from raw data."""
    arabic_segs = entry["arabic_segments"]
    french_segs = entry["french_segments"]

    result = {
        "unit": unit,
        "lesson": lesson,
        "arabic": arabic_segs[0] if arabic_segs else "",
        "translation_fr": french_segs[0] if french_segs else "",
        "sort_order": sort_order,
    }

    # If multiple Arabic segments, second might be plural
    if len(arabic_segs) >= 2:
        result["singular"] = arabic_segs[0]
        result["plural"] = arabic_segs[1]

    # Try to detect grammatical category from French text
    full_french = " ".join(french_segs).lower()
    if any(kw in full_french for kw in ("nom", "n.m", "n.f", "subst")):
        result["grammatical_category"] = "nom"
    elif any(kw in full_french for kw in ("adj", "adjectif")):
        result["grammatical_category"] = "adjectif"
    elif any(kw in full_french for kw in ("adv", "adverbe")):
        result["grammatical_category"] = "adverbe"
    elif any(kw in full_french for kw in ("prep", "préposition", "preposition")):
        result["grammatical_category"] = "préposition"

    return result


def build_verb_entry(entry, unit, lesson, sort_order):
    """Build a verb JSON entry from raw data."""
    arabic_segs = entry["arabic_segments"]
    french_segs = entry["french_segments"]

    # Verb forms order: masdar, past, present, imperative
    result = {
        "unit": unit,
        "lesson": lesson,
        "masdar": arabic_segs[0] if len(arabic_segs) > 0 else "",
        "past": arabic_segs[1] if len(arabic_segs) > 1 else "",
        "present": arabic_segs[2] if len(arabic_segs) > 2 else "",
        "imperative": arabic_segs[3] if len(arabic_segs) > 3 else "",
        "translation_fr": french_segs[0] if french_segs else "",
        "sort_order": sort_order,
    }

    return result


def extract_to_json(pdf_path, output_dir, level_number):
    """Main extraction pipeline: PDF -> JSON files."""

    print(f"Extracting from: {pdf_path}")
    print(f"Output directory: {output_dir}")
    print(f"Level number: {level_number}")
    print()

    # Extract text from PDF
    pages_text = extract_text_from_pdf(pdf_path)
    print(f"Extracted text from {len(pages_text)} pages")

    # Parse vocabulary entries
    raw_entries = parse_vocabulary_lines(pages_text)
    print(f"Found {len(raw_entries)} potential vocabulary entries")

    if not raw_entries:
        print("WARNING: No vocabulary entries found. The PDF format may not be supported.")
        print("Manual extraction may be required.")
        return

    # Classify entries
    words_raw = []
    verbs_raw = []
    for entry in raw_entries:
        entry_type = classify_entry(entry)
        if entry_type == "verb":
            verbs_raw.append(entry)
        else:
            words_raw.append(entry)

    print(f"Classified: {len(words_raw)} words, {len(verbs_raw)} verbs")

    # Build JSON entries (default: all in unit 1, lesson 1 for words, lesson 2 for verbs)
    # User will need to manually organize into correct units/lessons
    words = []
    for i, entry in enumerate(words_raw, 1):
        words.append(build_word_entry(entry, unit=1, lesson=1, sort_order=i))

    verbs = []
    for i, entry in enumerate(verbs_raw, 1):
        verbs.append(build_verb_entry(entry, unit=1, lesson=2, sort_order=i))

    # Build metadata skeleton
    lessons = []
    if words:
        lessons.append({
            "number": 1,
            "name_fr": f"Leçon 1 - Vocabulaire",
            "name_en": f"Lesson 1 - Vocabulary",
        })
    if verbs:
        lessons.append({
            "number": 2,
            "name_fr": f"Leçon 2 - Les verbes",
            "name_en": f"Lesson 2 - Verbs",
        })

    metadata = {
        "level": {
            "number": level_number,
            "name_fr": f"Niveau {level_number}",
            "name_en": f"Level {level_number}",
            "name_ar": f"المستوى {level_number}",
            "unit_count": 1,
        },
        "units": [
            {
                "number": 1,
                "name_fr": f"Unité 1",
                "name_en": f"Unit 1",
                "lessons": lessons,
            }
        ],
    }

    # Create output directory
    os.makedirs(output_dir, exist_ok=True)

    # Write files
    metadata_path = os.path.join(output_dir, "metadata.json")
    with open(metadata_path, "w", encoding="utf-8") as f:
        json.dump(metadata, f, ensure_ascii=False, indent=2)
    print(f"\nWrote: {metadata_path}")

    words_path = os.path.join(output_dir, "words.json")
    with open(words_path, "w", encoding="utf-8") as f:
        json.dump(words, f, ensure_ascii=False, indent=2)
    print(f"Wrote: {words_path} ({len(words)} entries)")

    verbs_path = os.path.join(output_dir, "verbs.json")
    with open(verbs_path, "w", encoding="utf-8") as f:
        json.dump(verbs, f, ensure_ascii=False, indent=2)
    print(f"Wrote: {verbs_path} ({len(verbs)} entries)")

    # Summary
    print(f"\n{'=' * 50}")
    print(f"EXTRACTION SUMMARY")
    print(f"{'=' * 50}")
    print(f"Words extracted: {len(words)}")
    print(f"Verbs extracted: {len(verbs)}")
    print()
    print("IMPORTANT: The extracted content needs manual review!")
    print("Next steps:")
    print(f"  1. Review and correct the JSON files in {output_dir}/")
    print(f"  2. Organize words/verbs into correct units and lessons")
    print(f"  3. Run: python validate_content.py {output_dir}")
    print(f"  4. Run: python verify_harakats.py {output_dir}")
    print(f"  5. Fix any issues and re-validate")


def main():
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <pdf_file> <output_dir> [--level N]")
        print(f"Example: {sys.argv[0]} book_level_02.pdf assets/data/level_02 --level 2")
        sys.exit(1)

    pdf_path = sys.argv[1]
    output_dir = sys.argv[2]
    level_number = 1

    # Parse --level argument
    if "--level" in sys.argv:
        idx = sys.argv.index("--level")
        if idx + 1 < len(sys.argv):
            try:
                level_number = int(sys.argv[idx + 1])
            except ValueError:
                print(f"ERROR: --level must be an integer, got: {sys.argv[idx + 1]}")
                sys.exit(1)

    if not os.path.isfile(pdf_path):
        print(f"ERROR: PDF file not found: {pdf_path}")
        sys.exit(1)

    extract_to_json(pdf_path, output_dir, level_number)


if __name__ == "__main__":
    main()
