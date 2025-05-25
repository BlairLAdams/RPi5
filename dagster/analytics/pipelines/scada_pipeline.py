from dagster import op, job, In, Out, Nothing
import subprocess
import os
from pathlib import Path

def get_pg_password():
    return subprocess.check_output(["pass", "dbt/postgres/blair"]).decode().strip()

# Base directory for ETL
base_dir = Path(__file__).resolve().parents[2] / "etl" / "sf_synthetic"
code_dir = base_dir / "scripts"
sql_dir = base_dir / "sql"

@op(out=Out(Nothing))
def generate_csv_sf_scada():
    script_path = code_dir / "generate_csv_sf_scada.py"
    subprocess.run(
        ["python", str(script_path)],
        check=True
    )

@op(ins={"start_after": In(Nothing)}, out=Out(Nothing))
def csv2bronze_sf_scada():
    pg_password = get_pg_password()
    script_path = code_dir / "csv2bronze_sf_scada.py"
    subprocess.run(
        ["python", str(script_path)],
        check=True,
        env={**os.environ, "PGPASSWORD": pg_password}
    )

@op(ins={"start_after": In(Nothing)}, out=Out(Nothing))
def bronze2silver_sf_scada():
    pg_password = get_pg_password()
    sql_file = sql_dir / "bronze2silver_sf_scada.sql"
    cmd = f'PGPASSWORD="{pg_password}" psql -U blair -d analytics -f "{sql_file}"'
    subprocess.run(cmd, shell=True, check=True, env=os.environ)

@op(ins={"start_after": In(Nothing)}, out=Out(Nothing))
def silver2gold_sf_scada():
    # Use the same password retrieval as other steps
    pg_password = get_pg_password()
    sql_file = sql_dir / "silver2gold_sf_scada.sql"
    cmd = f'PGPASSWORD="{pg_password}" psql -U blair -d analytics -f "{sql_file}"'
    subprocess.run(cmd, shell=True, check=True, env=os.environ)

@job
def scada_pipeline():
    step1 = generate_csv_sf_scada()
    step2 = csv2bronze_sf_scada(start_after=step1)
    step3 = bronze2silver_sf_scada(start_after=step2)
    silver2gold_sf_scada(start_after=step3)
