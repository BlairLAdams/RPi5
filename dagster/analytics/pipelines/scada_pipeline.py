from dagster import op, job, In, Out, Nothing
import subprocess
import os

def get_pg_password():
    return subprocess.check_output(["pass", "dbt/postgres/blair"]).decode().strip()

@op(out=Out(Nothing))
def generate_csv_sf_scada():
    subprocess.run([
        "python", "/home/blair/scr/scripts/sf/generate_csv_sf_scada.py"
    ], check=True)

@op(ins={"start_after": In(Nothing)}, out=Out(Nothing))
def csv2bronze_sf_scada():
    pg_password = get_pg_password()
    subprocess.run(
        ["python", "/home/blair/scr/scripts/sf/csv2bronze_sf_scada.py"],
        check=True,
        env={**os.environ, "PGPASSWORD": pg_password}
    )

@op(ins={"start_after": In(Nothing)}, out=Out(Nothing))
def bronze2silver_sf_scada():
    pg_password = get_pg_password()
    sql_file = "/home/blair/scr/scripts/sf/bronze2silver_sf_scada.sql"
    cmd = f'PGPASSWORD="{pg_password}" psql -U blair -d analytics -f {sql_file}'
    subprocess.run(cmd, shell=True, check=True, env=os.environ)

# @job
# def scada_pipeline():
#    step1 = generate_csv_sf_scada()
#    step2 = csv2bronze_sf_scada(start_after=step1)
#    bronze2silver_sf_scada(start_after=step2)

@op(ins={"start_after": In(Nothing)}, out=Out(Nothing))
def silver2gold_sf_scada():
    pg_password = os.getenv("DBT_PASSWORD") or "fallbackpassword"
    sql_file = "/home/blair/scr/scripts/sf/silver2gold_sf_scada.sql"
    cmd = f'PGPASSWORD="{pg_password}" psql -U blair -d analytics -f {sql_file}'
    subprocess.run(cmd, shell=True, check=True, env=os.environ)

@job
def scada_pipeline():
    step1 = generate_csv_sf_scada()
    step2 = csv2bronze_sf_scada(start_after=step1)
    step3 = bronze2silver_sf_scada(start_after=step2)
    silver2gold_sf_scada(start_after=step3)