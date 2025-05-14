#!/usr/bin/env python3
# qa_bronze_lake_merced.py

"""
Quality Assurance Script for Bronze Synthetic Data (Lake Merced)
Updated with correct file paths and schema mappings.

⚙️ Requires: polars >= 0.20
"""

import polars as pl
from pathlib import Path

# ✅ Corrected base directory
DATA_DIR = Path.home() / "scr/scripts/bronze_raw/synthetic/SF"

FILES = {
    "scada": DATA_DIR / "scada_tags.csv",
    "cmms": DATA_DIR / "cmms_work_orders.csv",
    "lims": DATA_DIR / "lims_samples.csv",
    "registry": DATA_DIR / "asset_registry.csv"
}

def profile(df: pl.DataFrame, name: str):
    print(f"\n📌 {name.upper()} — {len(df):,} rows")
    print(df.head(3))
    print(df.schema)
    print(df.describe())

def check_dates(df: pl.DataFrame, date_field: str, name: str):
    if date_field in df.columns:
        min_date = df[date_field].min()
        max_date = df[date_field].max()
        print(f"📅 {name}: {date_field} range = {min_date} → {max_date}")
    else:
        print(f"⚠️  {name} is missing expected field: {date_field}")

# 🚦 Load datasets
scada = pl.read_csv(FILES["scada"], try_parse_dates=True)
cmms = pl.read_csv(FILES["cmms"], try_parse_dates=True)
lims = pl.read_csv(FILES["lims"], try_parse_dates=True)
registry = pl.read_csv(FILES["registry"], try_parse_dates=True)

# 🧾 Basic stats
profile(scada, "scada_tags")
profile(cmms, "cmms_work_orders")
profile(lims, "lims_samples")
profile(registry, "asset_registry")

# 🕓 Timestamps
check_dates(scada, "timestamp", "scada_tags")
check_dates(cmms, "opened_date", "cmms_work_orders")
check_dates(cmms, "closed_date", "cmms_work_orders")
check_dates(lims, "sample_time", "lims_samples")

# 🔗 Asset matching
scada_assets = scada["tag_name"].unique().to_list()
cmms_assets = cmms["asset_id"].unique().to_list()

# Lookup LIMS site_code → asset_id from registry
lims_sites = lims["site_code"].unique().to_list()
site_to_asset = dict(zip(registry["site_code"], registry["asset_id"]))
mapped_lims_assets = [site_to_asset.get(site) for site in lims_sites if site in site_to_asset]

registered_assets = registry["asset_id"].unique().to_list()

unregistered_cmms = sorted(set(cmms_assets) - set(registered_assets))
unregistered_lims = sorted(set(mapped_lims_assets) - set(registered_assets))

print(f"\n🔗 Unmatched CMMS asset_ids: {unregistered_cmms or '✅ All matched'}")
print(f"🔗 Unmatched LIMS asset_ids: {unregistered_lims or '✅ All matched'}")

# 📈 Value stats
if "value" in lims.columns:
    print("\n🧪 LIMS result stats:")
    print(lims["value"].describe())

if "value" in scada.columns:
    print("\n🧮 SCADA tag value stats:")
    print(scada["value"].describe())

print("\n✅ Bronze QA complete.")
