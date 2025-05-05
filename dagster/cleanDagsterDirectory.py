#!/usr/bin/env python3
# ✅ Filename: cleanDagsterDirectory.py
# 🧼 Purpose: Move unused files/dirs to ~/scr/dagster/_archive for review
# ☑️ Strategy: Safe staging — nothing gets permanently deleted

import os
import shutil

TARGET_DIR = os.path.expanduser("~/scr/dagster")
ARCHIVE_DIR = os.path.join(TARGET_DIR, "_archive")

UNUSED = [
    "assets",
    "bronze_assets.py",
    "bronze_job.py",
    "checkDagsterHealth.sh",
    "initDagsterProject.sh",
    "pyproject.toml",
    "repository.py",
    "senors.py",
    "wq_pipeline",
    "verifyDagsterDirectory.py",
]

def main():
    print("📦 Staging unneeded files...")
    os.makedirs(ARCHIVE_DIR, exist_ok=True)

    for item in UNUSED:
        src = os.path.join(TARGET_DIR, item)
        dst = os.path.join(ARCHIVE_DIR, item)

        if os.path.exists(src):
            print(f"📁 Moving: {item} → _archive/")
            shutil.move(src, dst)
        else:
            print(f"⚠️ Not found (already moved?): {item}")

    print("✅ Cleanup complete. Contents staged in _archive/.")

if __name__ == "__main__":
    main()
