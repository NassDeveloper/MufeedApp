#!/usr/bin/env python3
"""Unit tests for validate_content.py."""

import json
import os
import tempfile
import unittest

from validate_content import (
    ValidationReport,
    is_arabic_char,
    is_arabic_text,
    strip_harakat,
    validate_level_dir,
    validate_metadata,
    validate_words,
    validate_verbs,
    validate_required_fields,
)


class TestHelpers(unittest.TestCase):
    def test_is_arabic_char_arabic(self):
        self.assertTrue(is_arabic_char("ك"))
        self.assertTrue(is_arabic_char("ب"))

    def test_is_arabic_char_latin(self):
        self.assertFalse(is_arabic_char("A"))
        self.assertFalse(is_arabic_char("z"))

    def test_is_arabic_char_harakat(self):
        # Harakats are in Arabic range
        self.assertTrue(is_arabic_char("\u064E"))  # Fathah

    def test_is_arabic_text_with_arabic(self):
        self.assertTrue(is_arabic_text("كِتَابٌ"))

    def test_is_arabic_text_without_arabic(self):
        self.assertFalse(is_arabic_text("Livre"))
        self.assertFalse(is_arabic_text(""))

    def test_strip_harakat(self):
        # "كِتَابٌ" should become "كتاب"
        result = strip_harakat("كِتَابٌ")
        self.assertNotIn("\u064E", result)  # no fathah
        self.assertNotIn("\u0650", result)  # no kasrah
        self.assertNotIn("\u064C", result)  # no dammatan

    def test_strip_harakat_no_change(self):
        result = strip_harakat("كتاب")
        self.assertEqual(result, "كتاب")


class TestValidationReport(unittest.TestCase):
    def test_no_errors(self):
        r = ValidationReport()
        self.assertFalse(r.has_errors)

    def test_with_error(self):
        r = ValidationReport()
        r.error("file", 0, "test error")
        self.assertTrue(r.has_errors)

    def test_warnings_no_errors(self):
        r = ValidationReport()
        r.warning("file", 0, "test warning")
        self.assertFalse(r.has_errors)
        self.assertEqual(len(r.warnings), 1)


class TestValidateRequiredFields(unittest.TestCase):
    def test_all_present(self):
        r = ValidationReport()
        entry = {"unit": 1, "lesson": 1, "arabic": "كِتَابٌ", "translation_fr": "Livre", "sort_order": 1}
        required = {"unit": int, "lesson": int, "arabic": str, "translation_fr": str, "sort_order": int}
        self.assertTrue(validate_required_fields(entry, "test", 0, required, r))
        self.assertFalse(r.has_errors)

    def test_missing_field(self):
        r = ValidationReport()
        entry = {"unit": 1}
        required = {"unit": int, "lesson": int}
        self.assertFalse(validate_required_fields(entry, "test", 0, required, r))
        self.assertTrue(r.has_errors)

    def test_null_field(self):
        r = ValidationReport()
        entry = {"unit": 1, "lesson": None}
        required = {"unit": int, "lesson": int}
        self.assertFalse(validate_required_fields(entry, "test", 0, required, r))

    def test_wrong_type(self):
        r = ValidationReport()
        entry = {"unit": "not_int", "lesson": 1}
        required = {"unit": int, "lesson": int}
        self.assertFalse(validate_required_fields(entry, "test", 0, required, r))

    def test_empty_string(self):
        r = ValidationReport()
        entry = {"name": "  "}
        required = {"name": str}
        self.assertFalse(validate_required_fields(entry, "test", 0, required, r))


class TestValidateMetadata(unittest.TestCase):
    def _make_metadata(self, **overrides):
        base = {
            "level": {
                "number": 1,
                "name_fr": "Niveau 1",
                "name_en": "Level 1",
                "name_ar": "المستوى الأول",
                "unit_count": 1,
            },
            "units": [
                {
                    "number": 1,
                    "name_fr": "Unité 1",
                    "name_en": "Unit 1",
                    "lessons": [
                        {"number": 1, "name_fr": "Leçon 1", "name_en": "Lesson 1"},
                    ],
                }
            ],
        }
        base.update(overrides)
        return base

    def test_valid_metadata(self):
        r = ValidationReport()
        lessons = validate_metadata(self._make_metadata(), r)
        self.assertFalse(r.has_errors)
        self.assertEqual(lessons, {(1, 1)})

    def test_missing_level(self):
        r = ValidationReport()
        validate_metadata({"units": []}, r)
        self.assertTrue(r.has_errors)

    def test_unit_count_mismatch(self):
        r = ValidationReport()
        meta = self._make_metadata()
        meta["level"]["unit_count"] = 5
        validate_metadata(meta, r)
        self.assertTrue(len(r.warnings) > 0)

    def test_missing_lesson_name(self):
        r = ValidationReport()
        meta = self._make_metadata()
        del meta["units"][0]["lessons"][0]["name_fr"]
        validate_metadata(meta, r)
        self.assertTrue(r.has_errors)


class TestValidateWords(unittest.TestCase):
    def test_valid_words(self):
        r = ValidationReport()
        words = [
            {"unit": 1, "lesson": 1, "arabic": "كِتَابٌ", "translation_fr": "Livre", "sort_order": 1},
            {"unit": 1, "lesson": 1, "arabic": "قَلَمٌ", "translation_fr": "Stylo", "sort_order": 2},
        ]
        validate_words(words, {(1, 1)}, r)
        self.assertFalse(r.has_errors)

    def test_missing_arabic(self):
        r = ValidationReport()
        words = [{"unit": 1, "lesson": 1, "translation_fr": "Livre", "sort_order": 1}]
        validate_words(words, {(1, 1)}, r)
        self.assertTrue(r.has_errors)

    def test_lesson_not_in_metadata(self):
        r = ValidationReport()
        words = [{"unit": 1, "lesson": 99, "arabic": "كِتَابٌ", "translation_fr": "Livre", "sort_order": 1}]
        validate_words(words, {(1, 1)}, r)
        self.assertTrue(r.has_errors)

    def test_duplicate_word(self):
        r = ValidationReport()
        words = [
            {"unit": 1, "lesson": 1, "arabic": "كِتَابٌ", "translation_fr": "Livre", "sort_order": 1},
            {"unit": 1, "lesson": 1, "arabic": "كِتَابٌ", "translation_fr": "Livre", "sort_order": 2},
        ]
        validate_words(words, {(1, 1)}, r)
        # Should produce a warning for duplicate
        self.assertTrue(len(r.warnings) > 0)

    def test_sort_order_gap(self):
        r = ValidationReport()
        words = [
            {"unit": 1, "lesson": 1, "arabic": "كِتَابٌ", "translation_fr": "Livre", "sort_order": 1},
            {"unit": 1, "lesson": 1, "arabic": "قَلَمٌ", "translation_fr": "Stylo", "sort_order": 3},
        ]
        validate_words(words, {(1, 1)}, r)
        self.assertTrue(len(r.warnings) > 0)

    def test_non_arabic_in_arabic_field(self):
        r = ValidationReport()
        words = [{"unit": 1, "lesson": 1, "arabic": "Livre", "translation_fr": "Livre", "sort_order": 1}]
        validate_words(words, {(1, 1)}, r)
        self.assertTrue(r.has_errors)


class TestValidateVerbs(unittest.TestCase):
    def test_valid_verbs(self):
        r = ValidationReport()
        verbs = [{
            "unit": 1, "lesson": 2,
            "masdar": "كِتَابَةٌ", "past": "كَتَبَ", "present": "يَكْتُبُ", "imperative": "اُكْتُبْ",
            "translation_fr": "Écrire", "sort_order": 1,
        }]
        validate_verbs(verbs, {(1, 2)}, r)
        self.assertFalse(r.has_errors)

    def test_missing_verb_form(self):
        r = ValidationReport()
        verbs = [{
            "unit": 1, "lesson": 2,
            "masdar": "كِتَابَةٌ", "past": "كَتَبَ",
            # missing present and imperative
            "translation_fr": "Écrire", "sort_order": 1,
        }]
        validate_verbs(verbs, {(1, 2)}, r)
        self.assertTrue(r.has_errors)


class TestValidateLevelDir(unittest.TestCase):
    def test_valid_level_dir(self):
        """Test validation on actual level_01 data."""
        level_dir = os.path.join(
            os.path.dirname(os.path.dirname(os.path.dirname(__file__))),
            "assets", "data", "level_01",
        )
        if os.path.isdir(level_dir):
            report = validate_level_dir(level_dir)
            self.assertFalse(report.has_errors)

    def test_nonexistent_dir(self):
        report = validate_level_dir("/nonexistent/dir")
        self.assertTrue(report.has_errors)

    def test_with_temp_valid_files(self):
        """Test validation with temporary valid files."""
        with tempfile.TemporaryDirectory() as tmpdir:
            metadata = {
                "level": {"number": 1, "name_fr": "N1", "name_en": "L1", "name_ar": "م1", "unit_count": 1},
                "units": [{"number": 1, "name_fr": "U1", "name_en": "U1",
                           "lessons": [{"number": 1, "name_fr": "L1", "name_en": "L1"}]}],
            }
            words = [{"unit": 1, "lesson": 1, "arabic": "كِتَابٌ", "translation_fr": "Livre", "sort_order": 1}]
            verbs = []

            with open(os.path.join(tmpdir, "metadata.json"), "w", encoding="utf-8") as f:
                json.dump(metadata, f, ensure_ascii=False)
            with open(os.path.join(tmpdir, "words.json"), "w", encoding="utf-8") as f:
                json.dump(words, f, ensure_ascii=False)
            with open(os.path.join(tmpdir, "verbs.json"), "w", encoding="utf-8") as f:
                json.dump(verbs, f, ensure_ascii=False)

            report = validate_level_dir(tmpdir)
            self.assertFalse(report.has_errors)

    def test_with_temp_invalid_files(self):
        """Test validation catches errors in temporary files."""
        with tempfile.TemporaryDirectory() as tmpdir:
            metadata = {
                "level": {"number": 1, "name_fr": "N1", "name_en": "L1", "name_ar": "م1", "unit_count": 1},
                "units": [{"number": 1, "name_fr": "U1", "name_en": "U1",
                           "lessons": [{"number": 1, "name_fr": "L1", "name_en": "L1"}]}],
            }
            # Missing required field 'arabic'
            words = [{"unit": 1, "lesson": 1, "translation_fr": "Livre", "sort_order": 1}]
            verbs = []

            with open(os.path.join(tmpdir, "metadata.json"), "w", encoding="utf-8") as f:
                json.dump(metadata, f, ensure_ascii=False)
            with open(os.path.join(tmpdir, "words.json"), "w", encoding="utf-8") as f:
                json.dump(words, f, ensure_ascii=False)
            with open(os.path.join(tmpdir, "verbs.json"), "w", encoding="utf-8") as f:
                json.dump(verbs, f, ensure_ascii=False)

            report = validate_level_dir(tmpdir)
            self.assertTrue(report.has_errors)


if __name__ == "__main__":
    unittest.main()
