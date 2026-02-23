#!/usr/bin/env python3
"""Check MufeedApp bundle asset sizes to ensure < 50 MB limit (NFR18).

Usage:
    python check_bundle_size.py [project_root]
    python check_bundle_size.py /path/to/MufeedApp

If no project root is given, uses the parent of tools/content_pipeline/.

Exit codes:
    0 = under 50 MB limit
    1 = over limit or error
"""

import os
import sys

MAX_BUNDLE_SIZE_MB = 50


def get_dir_size(path):
    """Calculate total size of a directory in bytes (no symlink following)."""
    total = 0
    if not os.path.isdir(path):
        return 0
    for dirpath, _dirnames, filenames in os.walk(path, followlinks=False):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            if os.path.islink(fp):
                continue
            try:
                if os.path.isfile(fp):
                    total += os.path.getsize(fp)
            except OSError:
                pass
    return total


def format_size(size_bytes):
    """Format bytes to human-readable string."""
    if size_bytes < 1024:
        return f"{size_bytes} B"
    elif size_bytes < 1024 * 1024:
        return f"{size_bytes / 1024:.1f} KB"
    else:
        return f"{size_bytes / (1024 * 1024):.2f} MB"


def check_bundle_size(project_root):
    """Check asset sizes and generate report."""
    assets_dir = os.path.join(project_root, "assets")

    if not os.path.isdir(assets_dir):
        print(f"ERROR: assets/ directory not found at {assets_dir}")
        return False

    print(f"Bundle Size Report — {project_root}")
    print("=" * 60)

    total_size = 0

    # Check data/ directory (content JSON files)
    data_dir = os.path.join(assets_dir, "data")
    if os.path.isdir(data_dir):
        print("\nContent Data (assets/data/):")
        print("-" * 40)

        level_sizes = []
        for entry in sorted(os.listdir(data_dir)):
            level_path = os.path.join(data_dir, entry)
            if os.path.isdir(level_path):
                level_size = get_dir_size(level_path)
                level_sizes.append((entry, level_size))
                print(f"  {entry}: {format_size(level_size)}")

        data_total = sum(s for _, s in level_sizes)
        total_size += data_total
        print(f"  {'Total data':30s} {format_size(data_total)}")

    # Check fonts/ directory
    fonts_dir = os.path.join(assets_dir, "fonts")
    if os.path.isdir(fonts_dir):
        print("\nFonts (assets/fonts/):")
        print("-" * 40)

        font_sizes = []
        for entry in sorted(os.listdir(fonts_dir)):
            font_path = os.path.join(fonts_dir, entry)
            if os.path.isfile(font_path):
                font_size = os.path.getsize(font_path)
                font_sizes.append((entry, font_size))
                print(f"  {entry}: {format_size(font_size)}")

        fonts_total = sum(s for _, s in font_sizes)
        total_size += fonts_total
        print(f"  {'Total fonts':30s} {format_size(fonts_total)}")

    # Check other asset directories
    other_size = 0
    for entry in sorted(os.listdir(assets_dir)):
        entry_path = os.path.join(assets_dir, entry)
        if entry in ("data", "fonts"):
            continue
        if os.path.isdir(entry_path):
            dir_size = get_dir_size(entry_path)
            if dir_size > 0:
                print(f"\nOther (assets/{entry}/): {format_size(dir_size)}")
                other_size += dir_size
        elif os.path.isfile(entry_path):
            file_size = os.path.getsize(entry_path)
            other_size += file_size

    total_size += other_size

    # Summary
    print(f"\n{'=' * 60}")
    print(f"TOTAL ASSET SIZE: {format_size(total_size)}")
    limit_bytes = MAX_BUNDLE_SIZE_MB * 1024 * 1024
    remaining = limit_bytes - total_size
    print(f"LIMIT: {MAX_BUNDLE_SIZE_MB} MB")
    print(f"REMAINING: {format_size(remaining)}")

    if total_size > limit_bytes:
        print(f"\nFAILED: Assets exceed {MAX_BUNDLE_SIZE_MB} MB limit!")
        return False
    else:
        print(f"\nPASSED: Assets within {MAX_BUNDLE_SIZE_MB} MB limit.")
        return True


def main():
    if len(sys.argv) > 1:
        project_root = sys.argv[1]
    else:
        # Default: two levels up from tools/content_pipeline/
        project_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

    if not os.path.isdir(project_root):
        print(f"ERROR: Project root not found: {project_root}")
        sys.exit(1)

    ok = check_bundle_size(project_root)
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
