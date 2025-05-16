#!/usr/bin/env python3

import pandas as pd
from sqlalchemy import create_engine
import subprocess
import threading
import itertools
import sys
import time

# Spinner function
def spinner(msg, event):
    for char in itertools.cycle("|/-\\"):
        if event.is_set():
            break
        sys.stdout.write(f"\r{msg} {char}")
        sys.stdout.flush()
        time.sleep(0.1)
    sys.stdout.write("\r✅ Done.                           \n")

# Retrieve password from pass
pg_password = subprocess.check_output(["pass", "dbt/postgres/blair"]).decode("utf-8").strip()

# Build connection string
engine = create_engine(f"postgresql://blair:{pg_password}@localhost:5432/analytics")

# Load CSV
print("📥 Loading SCADA CSV...")
df = pd.read_csv("/home/blair/scr/scripts/bronze_raw/synthetic/SF/scada_tags.csv", parse_dates=["timestamp"])

# Start spinner thread
done_event = threading.Event()
spinner_thread = threading.Thread(target=spinner, args=("📡 Writing to Postgres...", done_event))
spinner_thread.start()

# Load to Postgres
df.to_sql("scada_tags", schema="bronze", con=engine, if_exists="replace", index=False)

# Stop spinner
done_event.set()
spinner_thread.join()

print("✅ Loaded SCADA data to bronze.scada_tags")
