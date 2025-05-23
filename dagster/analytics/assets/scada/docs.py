import os
import subprocess
from pathlib import Path

from dagster import asset, Nothing, OpExecutionContext

@asset(
    name="generate_sf_scada_docs",
    description="Run `dbt docs generate` for the SF SCADA project and log any errors.",
)
def generate_sf_scada_docs_asset(context: OpExecutionContext) -> Nothing:
    project_dir = Path(__file__).resolve().parent.parent

    # Build a bash -lc invocation so we source the activate script,
    # pick up all its exports (DBT_USER, DBT_PASS, PGPASSWORD, etc),
    # and then run dbt in one shot.
    activate = os.path.expanduser("~/scr/dagster/venv/bin/activate")
    bash_cmd = f"source {activate} && dbt docs generate"

    context.log.info(f"🔧 Running in bash: {bash_cmd!r} (cwd={project_dir})")

    try:
        # shell=True + executable="/bin/bash" + -lc will:
        #  1) load a login shell (so it reads your venv activate)
        #  2) run the compound command
        proc = subprocess.run(
            bash_cmd,
            cwd=str(project_dir),
            shell=True,
            check=True,
            text=True,
            executable="/bin/bash",
        )
        # dbt prints to stdout/stderr directly; if you need logs you can
        # remove capture or read proc.stdout / proc.stderr here.
    except subprocess.CalledProcessError as err:
        # Log what dbt spat out, then surface the failure
        context.log.error(f"dbt docs failed:\n{err.stderr or err.stdout}")
        raise RuntimeError("❌ dbt docs generate failed; see logs above") from err

    return Nothing()
