#!/usr/bin/env python3
"""Unit tests for verify_harakats.py."""

import json
import os
import tempfile
import unittest

from verify_harakats import (
    HarakatReport,
    check_field,
    count_arabic_letters,
    count_harakat,
    count_alef_variants,
    unicode_analysis,
    verify_words,
    verify_verbs,
    verify_level_dir,
)


class TestCounters(unittest.TestCase):
    def test_count_arabic_letters(self):
        # "كِتَابٌ" — 4 letters: ك ت ا ب
        self.assertEqual(count_arabic_letters("كِتَابٌ"), 4)

    def test_count_arabic_letters_no_arabic(self):
        self.assertEqual(count_arabic_letters("Hello"), 0)

    def test_count_arabic_letters_empty(self):
        self.assertEqual(count_arabic_letters(""), 0)

    def test_count_harakat(self):
        # "كِتَابٌ" — 3 harakats: kasrah, fathah, dammatan
        self.assertEqual(count_harakat("كِتَابٌ"), 3)

    def test_count_harakat_none(self):
        # "كتاب" — no harakats
        self.assertEqual(count_harakat("كتاب"), 0)

    def test_count_alef_variants(self):
        # أ (Alef with Hamza above)
        self.assertEqual(count_alef_variants("أَقْلَامٌ"), 1)

    def test_count_alef_variants_none(self):
        self.assertEqual(count_alef_variants("كِتَابٌ"), 0)


class TestUnicodeAnalysis(unittest.TestCase):
    def test_analysis_output(self):
        result = unicode_analysis("كِ")
        self.assertIn("U+0643", result)  # Kaf
        self.assertIn("HARAKAT", result)  # Kasrah


class TestCheckField(unittest.TestCase):
    def test_word_with_harakats(self):
        r = HarakatReport()
        check_field("كِتَابٌ", "test", 0, "arabic", r)
        self.assertEqual(len(r.errors), 0)

    def test_word_without_harakats(self):
        r = HarakatReport()
        check_field("كتاب", "test", 0, "arabic", r)
        self.assertEqual(len(r.errors), 1)

    def test_empty_field(self):
        r = HarakatReport()
        check_field("", "test", 0, "arabic", r)
        self.assertEqual(len(r.errors), 0)  # empty is skipped

    def test_none_field(self):
        r = HarakatReport()
        check_field(None, "test", 0, "arabic", r)
        self.assertEqual(len(r.errors), 0)  # None is skipped

    def test_non_arabic_text(self):
        r = HarakatReport()
        check_field("Hello", "test", 0, "arabic", r)
        self.assertEqual(len(r.errors), 0)  # non-Arabic is skipped

    def test_low_ratio_warning(self):
        # Word with very few harakats relative to letters
        r = HarakatReport()
        # "كتابة" has 5 letters, add just one harakat
        check_field("كِتابة", "test", 0, "arabic", r)
        # 5 letters, 1 harakat, ratio = 0.2 < 0.3 threshold
        self.assertTrue(len(r.warnings) > 0 or len(r.errors) > 0)


class TestVerifyWords(unittest.TestCase):
    def test_valid_words(self):
        r = HarakatReport()
        words = [
            {"arabic": "كِتَابٌ", "singular": "كِتَابٌ", "plural": "كُتُبٌ"},
        ]
        verify_words(words, r)
        self.assertFalse(r.has_issues)

    def test_word_without_harakat(self):
        r = HarakatReport()
        words = [{"arabic": "كتاب"}]
        verify_words(words, r)
        self.assertTrue(r.has_issues)

    def test_optional_fields_checked(self):
        r = HarakatReport()
        words = [{"arabic": "كِتَابٌ", "plural": "كتب"}]  # plural missing harakats
        verify_words(words, r)
        self.assertTrue(r.has_issues)


class TestVerifyVerbs(unittest.TestCase):
    def test_valid_verbs(self):
        r = HarakatReport()
        verbs = [{
            "masdar": "كِتَابَةٌ", "past": "كَتَبَ",
            "present": "يَكْتُبُ", "imperative": "اُكْتُبْ",
        }]
        verify_verbs(verbs, r)
        self.assertFalse(r.has_issues)

    def test_verb_missing_harakat(self):
        r = HarakatReport()
        verbs = [{
            "masdar": "كتابة", "past": "كَتَبَ",
            "present": "يَكْتُبُ", "imperative": "اُكْتُبْ",
        }]
        verify_verbs(verbs, r)
        self.assertTrue(r.has_issues)

    def test_all_forms_checked(self):
        r = HarakatReport()
        verbs = [{
            "masdar": "كِتَابَةٌ", "past": "كتب",
            "present": "يكتب", "imperative": "اكتب",
        }]
        verify_verbs(verbs, r)
        # Should have 3 issues (past, present, imperative)
        self.assertEqual(len(r.errors), 3)


class TestVerifyLevelDir(unittest.TestCase):
    def test_actual_level_01(self):
        """Test on actual level_01 data."""
        level_dir = os.path.join(
            os.path.dirname(os.path.dirname(os.path.dirname(__file__))),
            "assets", "data", "level_01",
        )
        if os.path.isdir(level_dir):
            report = verify_level_dir(level_dir)
            self.assertFalse(report.has_issues)

    def test_nonexistent_dir(self):
        report = verify_level_dir("/nonexistent/dir")
        # No issues reported for nonexistent dir (just prints error)
        self.assertFalse(report.has_issues)

    def test_with_temp_files(self):
        """Test with temporary files containing words without harakats."""
        with tempfile.TemporaryDirectory() as tmpdir:
            words = [{"arabic": "كتاب", "translation_fr": "Livre"}]
            with open(os.path.join(tmpdir, "words.json"), "w", encoding="utf-8") as f:
                json.dump(words, f, ensure_ascii=False)

            report = verify_level_dir(tmpdir)
            self.assertTrue(report.has_issues)


if __name__ == "__main__":
    unittest.main()
