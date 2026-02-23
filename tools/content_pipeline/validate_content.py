#!/usr/bin/env python3
"""Validate MufeedApp content JSON files (metadata, words, verbs).

Usage:
    python validate_content.py <level_dir>
    python validate_content.py assets/data/level_01

Validates:
- Required fields presence and types
- Arabic text format (valid Unicode Arabic characters)
- Non-empty translations
- No duplicate words within a lesson
- Metadata ↔ words/verbs cross-referencing (all referenced lessons exist)
- Sort order sequential within each lesson

Exit codes:
    0 = all valid
    1 = errors found
"""

import json
import os
import sys
import unicodedata

# Unicode ranges for Arabic script
ARABIC_RANGES = [
    (0x0600, 0x06FF),  # Arabic
    (0x0750, 0x077F),  # Arabic Supplement
    (0x08A0, 0x08FF),  # Arabic Extended-A
    (0xFB50, 0xFDFF),  # Arabic Presentation Forms-A
    (0xFE70, 0xFEFF),  # Arabic Presentation Forms-B
]

HARAKAT_CODEPOINTS = {
    0x064B,  # Fathatan
    0x064C,  # Dammatan
    0x064D,  # Kasratan
    0x064E,  # Fathah
    0x064F,  # Dammah
    0x0650,  # Kasrah
    0x0651,  # Shaddah
    0x0652,  # Sukun
    0x0653,  # Maddah above
    0x0654,  # Hamza above
    0x0655,  # Hamza below
    0x0670,  # Superscript Alef
}

WORD_REQUIRED_FIELDS = {"unit": int, "lesson": int, "arabic": str, "translation_fr": str, "sort_order": int}
WORD_OPTIONAL_FIELDS = {
    "translation_en": str,
    "grammatical_category": str,
    "singular": str,
    "plural": str,
    "synonym": str,
    "antonym": str,
    "example_sentence": str,
}

VERB_REQUIRED_FIELDS = {
    "unit": int,
    "lesson": int,
    "masdar": str,
    "past": str,
    "present": str,
    "imperative": str,
    "translation_fr": str,
    "sort_order": int,
}
VERB_OPTIONAL_FIELDS = {"translation_en": str, "example_sentence": str}

# Unicode bidirectional override characters that should not appear in content
BIDI_OVERRIDES = {
    0x202A,  # Left-to-Right Embedding
    0x202B,  # Right-to-Left Embedding
    0x202C,  # Pop Directional Formatting
    0x202D,  # Left-to-Right Override
    0x202E,  # Right-to-Left Override
    0x2066,  # Left-to-Right Isolate
    0x2067,  # Right-to-Left Isolate
    0x2068,  # First Strong Isolate
    0x2069,  # Pop Directional Isolate
}


class ValidationReport:
    """Collect errors and warnings during validation."""

    def __init__(self):
        self.errors = []
        self.warnings = []

    def error(self, file, index, msg):
        self.errors.append(f"ERROR [{file}#{index}]: {msg}")

    def warning(self, file, index, msg):
        self.warnings.append(f"WARN  [{file}#{index}]: {msg}")

    def error_general(self, msg):
        self.errors.append(f"ERROR: {msg}")

    def warning_general(self, msg):
        self.warnings.append(f"WARN:  {msg}")

    @property
    def has_errors(self):
        return len(self.errors) > 0

    def print_report(self):
        total = len(self.errors) + len(self.warnings)
        print(f"\n{'=' * 60}")
        print(f"VALIDATION REPORT — {len(self.errors)} error(s), {len(self.warnings)} warning(s)")
        print(f"{'=' * 60}")
        if self.errors:
            print("\nERRORS:")
            for e in self.errors:
                print(f"  {e}")
        if self.warnings:
            print("\nWARNINGS:")
            for w in self.warnings:
                print(f"  {w}")
        if total == 0:
            print("\nAll validations passed.")
        print()


def is_arabic_char(ch):
    """Check if a character is in the Arabic Unicode range."""
    cp = ord(ch)
    return any(start <= cp <= end for start, end in ARABIC_RANGES)


def is_arabic_text(text):
    """Check that text contains at least one Arabic letter."""
    return any(
        is_arabic_char(ch) and unicodedata.category(ch).startswith("L")
        for ch in text
    )


def strip_harakat(text):
    """Remove diacritical marks to get base Arabic letters (NFC-normalized)."""
    normalized = unicodedata.normalize("NFC", text)
    return "".join(ch for ch in normalized if ord(ch) not in HARAKAT_CODEPOINTS)


def validate_arabic_field(value, file, index, field_name, report):
    """Validate that a field contains valid Arabic text."""
    if not value or not value.strip():
        report.error(file, index, f"'{field_name}' is empty")
        return False
    if not is_arabic_text(value):
        report.error(file, index, f"'{field_name}' does not contain Arabic characters: {value!r}")
        return False
    # Check for bidirectional override characters
    for ch in value:
        if ord(ch) in BIDI_OVERRIDES:
            report.warning(file, index, f"'{field_name}' contains bidirectional override character U+{ord(ch):04X} ({unicodedata.name(ch, '?')})")
    # Check for non-Arabic, non-harakat, non-space characters
    for ch in value:
        if ch in (" ", "\u200C", "\u200D"):  # space, ZWNJ, ZWJ
            continue
        if is_arabic_char(ch):
            continue
        if ord(ch) in BIDI_OVERRIDES:
            continue  # already warned above
        cat = unicodedata.category(ch)
        if cat.startswith("M"):  # combining marks
            continue
        report.warning(file, index, f"'{field_name}' contains non-Arabic character U+{ord(ch):04X} ({unicodedata.name(ch, '?')}): {value!r}")
    return True


def validate_required_fields(entry, file, index, required, report):
    """Check required fields presence and types."""
    ok = True
    for field, expected_type in required.items():
        if field not in entry:
            report.error(file, index, f"Missing required field '{field}'")
            ok = False
        elif entry[field] is None:
            report.error(file, index, f"Required field '{field}' is null")
            ok = False
        elif not isinstance(entry[field], expected_type):
            report.error(file, index, f"Field '{field}' should be {expected_type.__name__}, got {type(entry[field]).__name__}")
            ok = False
        elif expected_type == str and not entry[field].strip():
            report.error(file, index, f"Required field '{field}' is empty string")
            ok = False
    return ok


def validate_optional_fields(entry, file, index, optional, report):
    """Check optional fields types when present."""
    for field, expected_type in optional.items():
        if field in entry and entry[field] is not None:
            if not isinstance(entry[field], expected_type):
                report.warning(file, index, f"Optional field '{field}' should be {expected_type.__name__}, got {type(entry[field]).__name__}")


def load_json(filepath, report):
    """Load and parse a JSON file. Returns None on error."""
    if not os.path.exists(filepath):
        report.error_general(f"File not found: {filepath}")
        return None
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            return json.load(f)
    except json.JSONDecodeError as e:
        report.error_general(f"Invalid JSON in {filepath}: {e}")
        return None


def validate_metadata(metadata, report):
    """Validate metadata.json structure. Returns set of (unit, lesson) tuples."""
    fname = "metadata.json"
    lessons_declared = set()

    if not isinstance(metadata, dict):
        report.error_general(f"{fname}: root must be an object")
        return lessons_declared

    # Validate level
    level = metadata.get("level")
    if not isinstance(level, dict):
        report.error_general(f"{fname}: missing or invalid 'level' object")
        return lessons_declared

    for field in ("number", "unit_count"):
        if field not in level:
            report.error_general(f"{fname}: level missing '{field}'")
        elif not isinstance(level[field], int):
            report.error_general(f"{fname}: level.{field} must be int")

    for field in ("name_fr", "name_en", "name_ar"):
        if field not in level:
            report.error_general(f"{fname}: level missing '{field}'")
        elif not isinstance(level[field], str) or not level[field].strip():
            report.error_general(f"{fname}: level.{field} must be non-empty string")

    # Validate units
    units = metadata.get("units")
    if not isinstance(units, list):
        report.error_general(f"{fname}: missing or invalid 'units' array")
        return lessons_declared

    declared_unit_count = level.get("unit_count", 0)
    if len(units) != declared_unit_count:
        report.warning_general(f"{fname}: unit_count={declared_unit_count} but {len(units)} units found")

    for ui, unit in enumerate(units):
        if not isinstance(unit, dict):
            report.error(fname, f"unit[{ui}]", "unit must be an object")
            continue

        for field in ("number",):
            if field not in unit:
                report.error(fname, f"unit[{ui}]", f"missing '{field}'")

        for field in ("name_fr", "name_en"):
            if field not in unit:
                report.error(fname, f"unit[{ui}]", f"missing '{field}'")
            elif not isinstance(unit[field], str) or not unit[field].strip():
                report.error(fname, f"unit[{ui}]", f"'{field}' must be non-empty string")

        lessons = unit.get("lessons")
        if not isinstance(lessons, list):
            report.error(fname, f"unit[{ui}]", "missing or invalid 'lessons' array")
            continue

        unit_num = unit.get("number", ui + 1)
        for li, lesson in enumerate(lessons):
            if not isinstance(lesson, dict):
                report.error(fname, f"unit[{ui}].lesson[{li}]", "lesson must be an object")
                continue

            for field in ("number",):
                if field not in lesson:
                    report.error(fname, f"unit[{ui}].lesson[{li}]", f"missing '{field}'")

            for field in ("name_fr", "name_en"):
                if field not in lesson:
                    report.error(fname, f"unit[{ui}].lesson[{li}]", f"missing '{field}'")
                elif not isinstance(lesson[field], str) or not lesson[field].strip():
                    report.error(fname, f"unit[{ui}].lesson[{li}]", f"'{field}' must be non-empty string")

            lesson_num = lesson.get("number", li + 1)
            lessons_declared.add((unit_num, lesson_num))

    return lessons_declared


def validate_words(words, lessons_declared, report):
    """Validate words.json entries."""
    fname = "words.json"

    if not isinstance(words, list):
        report.error_general(f"{fname}: root must be an array")
        return

    seen = {}  # (unit, lesson, arabic_base) -> index for duplicate detection
    lesson_sort_orders = {}  # (unit, lesson) -> set of sort_orders

    for i, word in enumerate(words):
        if not isinstance(word, dict):
            report.error(fname, i, "entry must be an object")
            continue

        # Required fields
        validate_required_fields(word, fname, i, WORD_REQUIRED_FIELDS, report)
        validate_optional_fields(word, fname, i, WORD_OPTIONAL_FIELDS, report)

        # Arabic validation
        arabic = word.get("arabic", "")
        if arabic:
            validate_arabic_field(arabic, fname, i, "arabic", report)

        # Check optional Arabic fields
        for field in ("singular", "plural"):
            val = word.get(field)
            if val and isinstance(val, str):
                validate_arabic_field(val, fname, i, field, report)

        # Cross-reference with metadata
        unit = word.get("unit")
        lesson = word.get("lesson")
        if isinstance(unit, int) and isinstance(lesson, int):
            if lessons_declared and (unit, lesson) not in lessons_declared:
                report.error(fname, i, f"references unit={unit} lesson={lesson} not declared in metadata")

        # Duplicate detection (same arabic base in same lesson)
        if arabic and isinstance(unit, int) and isinstance(lesson, int):
            base = strip_harakat(arabic)
            key = (unit, lesson, base)
            if key in seen:
                report.warning(fname, i, f"possible duplicate of entry #{seen[key]} in unit={unit} lesson={lesson}: {arabic!r}")
            else:
                seen[key] = i

        # Sort order tracking
        sort_order = word.get("sort_order")
        if isinstance(unit, int) and isinstance(lesson, int) and isinstance(sort_order, int):
            lesson_key = (unit, lesson)
            if lesson_key not in lesson_sort_orders:
                lesson_sort_orders[lesson_key] = []
            lesson_sort_orders[lesson_key].append((sort_order, i))

    # Check sort order duplicates and gaps
    for lesson_key, orders in lesson_sort_orders.items():
        orders.sort()
        seen_orders = {}
        for so, idx in orders:
            if so in seen_orders:
                report.warning(fname, idx, f"duplicate sort_order={so} (also at entry #{seen_orders[so]}) in unit={lesson_key[0]} lesson={lesson_key[1]}")
            else:
                seen_orders[so] = idx
        # Check gaps (using unique sort orders only)
        unique_orders = sorted(seen_orders.keys())
        for pos, so in enumerate(unique_orders):
            expected = pos + 1
            if so != expected:
                report.warning(fname, seen_orders[so], f"sort_order gap: expected {expected}, got {so} in unit={lesson_key[0]} lesson={lesson_key[1]}")
                break  # only report first gap


def validate_verbs(verbs, lessons_declared, report):
    """Validate verbs.json entries."""
    fname = "verbs.json"

    if not isinstance(verbs, list):
        report.error_general(f"{fname}: root must be an array")
        return

    seen = {}
    lesson_sort_orders = {}

    for i, verb in enumerate(verbs):
        if not isinstance(verb, dict):
            report.error(fname, i, "entry must be an object")
            continue

        # Required fields
        validate_required_fields(verb, fname, i, VERB_REQUIRED_FIELDS, report)
        validate_optional_fields(verb, fname, i, VERB_OPTIONAL_FIELDS, report)

        # Arabic validation for all verb forms
        for field in ("masdar", "past", "present", "imperative"):
            val = verb.get(field, "")
            if val:
                validate_arabic_field(val, fname, i, field, report)

        # Cross-reference with metadata
        unit = verb.get("unit")
        lesson = verb.get("lesson")
        if isinstance(unit, int) and isinstance(lesson, int):
            if lessons_declared and (unit, lesson) not in lessons_declared:
                report.error(fname, i, f"references unit={unit} lesson={lesson} not declared in metadata")

        # Duplicate detection (same masdar base in same lesson)
        masdar = verb.get("masdar", "")
        if masdar and isinstance(unit, int) and isinstance(lesson, int):
            base = strip_harakat(masdar)
            key = (unit, lesson, base)
            if key in seen:
                report.warning(fname, i, f"possible duplicate of entry #{seen[key]} in unit={unit} lesson={lesson}: {masdar!r}")
            else:
                seen[key] = i

        # Sort order tracking
        sort_order = verb.get("sort_order")
        if isinstance(unit, int) and isinstance(lesson, int) and isinstance(sort_order, int):
            lesson_key = (unit, lesson)
            if lesson_key not in lesson_sort_orders:
                lesson_sort_orders[lesson_key] = []
            lesson_sort_orders[lesson_key].append((sort_order, i))

    # Check sort order duplicates and gaps
    for lesson_key, orders in lesson_sort_orders.items():
        orders.sort()
        seen_orders = {}
        for so, idx in orders:
            if so in seen_orders:
                report.warning(fname, idx, f"duplicate sort_order={so} (also at entry #{seen_orders[so]}) in unit={lesson_key[0]} lesson={lesson_key[1]}")
            else:
                seen_orders[so] = idx
        unique_orders = sorted(seen_orders.keys())
        for pos, so in enumerate(unique_orders):
            expected = pos + 1
            if so != expected:
                report.warning(fname, seen_orders[so], f"sort_order gap: expected {expected}, got {so} in unit={lesson_key[0]} lesson={lesson_key[1]}")
                break


def validate_level_dir(level_dir):
    """Validate all content files in a level directory."""
    report = ValidationReport()

    if not os.path.isdir(level_dir):
        report.error_general(f"Directory not found: {level_dir}")
        report.print_report()
        return report

    # Load and validate metadata
    metadata_path = os.path.join(level_dir, "metadata.json")
    metadata = load_json(metadata_path, report)
    lessons_declared = set()
    if metadata is not None:
        lessons_declared = validate_metadata(metadata, report)

    # Load and validate words
    words_path = os.path.join(level_dir, "words.json")
    words = load_json(words_path, report)
    if words is not None:
        validate_words(words, lessons_declared, report)

    # Load and validate verbs
    verbs_path = os.path.join(level_dir, "verbs.json")
    verbs = load_json(verbs_path, report)
    if verbs is not None:
        validate_verbs(verbs, lessons_declared, report)

    # Cross-check: every lesson in metadata has at least one word or verb
    if words is not None and verbs is not None:
        lessons_with_content = set()
        for w in (words if isinstance(words, list) else []):
            if isinstance(w, dict):
                u, l = w.get("unit"), w.get("lesson")
                if isinstance(u, int) and isinstance(l, int):
                    lessons_with_content.add((u, l))
        for v in (verbs if isinstance(verbs, list) else []):
            if isinstance(v, dict):
                u, l = v.get("unit"), v.get("lesson")
                if isinstance(u, int) and isinstance(l, int):
                    lessons_with_content.add((u, l))

        for ul in lessons_declared:
            if ul not in lessons_with_content:
                report.warning_general(f"Lesson unit={ul[0]} lesson={ul[1]} declared in metadata but has no words or verbs")

    report.print_report()
    return report


def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <level_dir> [level_dir2 ...]")
        print(f"Example: {sys.argv[0]} assets/data/level_01")
        sys.exit(1)

    has_errors = False
    for level_dir in sys.argv[1:]:
        print(f"\nValidating: {level_dir}")
        print("-" * 40)
        report = validate_level_dir(level_dir)
        if report.has_errors:
            has_errors = True

    sys.exit(1 if has_errors else 0)


if __name__ == "__main__":
    main()
