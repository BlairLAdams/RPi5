import os
import subprocess
from pathlib import Path

from dagster import asset, Nothing, OpExecutionContext

@asset(
    name="generate_sf_scada_docs",
    description="Run `dbt docs generate` for the SF SCADA project and log any errors.",
)
def generate_sf_scada_docs_asset(context: OpExecutionContext) -> Nothing:
    # Set project_dir to the analytics folder containing dbt_project.yml
    project_dir = Path(__file__).resolve().parents[2]

    # Build a bash -lc invocation so we source the activate script,
    # pick up all its exports (DBT_USER, DBT_PASS, PGPASSWORD, etc),
    # and then run dbt in one shot.
    activate = os.path.expanduser("~/scr/dagster/venv/bin/activate")
    bash_cmd = f"source {activate} && dbt docs generate"

    context.log.info(f"🔧 Running in bash: {bash_cmd!r} (cwd={project_dir})")

    try:
        proc = subprocess.run(
            bash_cmd,
            cwd=str(project_dir),
            shell=True,
            check=True,
            text=True,
            executable="/bin/bash",
        )
    except subprocess.CalledProcessError as err:
        context.log.error(f"dbt docs failed:\n{err.stderr or err.stdout}")
        raise RuntimeError("❌ dbt docs generate failed; see logs above") from err

    return Nothing()
