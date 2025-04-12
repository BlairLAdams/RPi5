#!/usr/bin/env python3
# ✅ Filename: verifyDagsterDirectory.py
# 🧹 Purpose: Identify unexpected files in ~/scr/07_dagster
# 📁 Expected: Clean Dagster directory with approved files only

import os

EXPECTED_FILES = {
    "__init__.py",
    "bronze_file_sensor.py",
    "checkBronzeTables.py",
    "dagster.yaml",
    "loadBronzeTables.py",
    "setupDagster.sh",
    "setupDagsterService.sh",
}

TARGET_DIR = os.path.expanduser("~/scr/07_dagster")

def main():
    print(f"🔍 Verifying contents of: {TARGET_DIR}")
    found_files = set(os.listdir(TARGET_DIR))
    unexpected = found_files - EXPECTED_FILES
    missing = EXPECTED_FILES - found_files

    if unexpected:
        print("⚠️ Unexpected files or directories:")
        for f in sorted(unexpected):
            print(f" - {f}")
    else:
        print("✅ No unexpected files found.")

    if missing:
        print("❌ Missing expected files:")
        for f in sorted(missing):
            print(f" - {f}")
    else:
        print("✅ All expected files present.")

if __name__ == "__main__":
    main()
