# Project Stack

This project showcases a **modular, low-cost data analytics and observability stack** deployed on a **Raspberry Pi 5** running **Pi OS Lite (Bookworm)**. It reflects real-world architecture patterns for **edge analytics** and demonstrates a fully open-source solution for data lineage, transformation, monitoring, and governance.

---

## Components

### Raspberry Pi OS Lite  
A minimal Debian-based distribution selected for its headless, lightweight footprint. It is flashed to a microSD card and accessed via SSH to emulate edge deployment conditions.

### Visual Studio Code (Remote)  
Remote SSH integration with VS Code allows the developer to manage the Pi from a desktop environment. This supports inline Git usage, terminal access, and Python development directly on the target system.

### Git  
All scripts, configurations, and dashboards are tracked in a Git repository. SSH keys manage secure access, enabling rollback, collaboration, and infrastructure versioning.

### Python (venv)  
Used throughout for **ETL scripting**, orchestration, and integration. A dedicated virtual environment (`~/scr/venv`) contains core libraries like `polars`, `sqlalchemy`, and `pint`.

### DuckDB  
Serves as the **OLAP engine** for analytical queries over the silver-tier data. It is optimized for **local, columnar workloads** and integrates seamlessly with Python, dbt, and Metabase. DuckDB enables fast exploration of aggregated sensor and lab data without standing up a full-scale database server, making it ideal for edge deployments and prototype scenarios.

### PostgreSQL  
Serves as the **OLTP data store** for sensor readings, reference tables, and structured logs. Its schema follows the **medallion architecture** (bronze and silver), enabling clear data lineage and progressive refinement.

### PostGIS  
An extension to PostgreSQL that enables advanced **geospatial data support**. PostGIS allows the stack to handle spatial queries, store geometries (points, lines, polygons), and perform GIS-style analytics. It is ideal for modeling field assets, service areas, and location-based events directly within the relational database.
Let me 

### Node Exporter  
Lightweight exporter that exposes live Linux system metrics (CPU, RAM, disk, network) on port `:9100`.

### Prometheus  
Pulls metrics from Node Exporter on a scheduled interval. Stores time-series data used for dashboard visualizations and potential alerting.

### Grafana  
Provides the **visualization layer** for operational metrics. Dashboards track system health and performance using Prometheus data. Layouts and configurations are stored in Git.

### Metabase  
Acts as a **lightweight BI layer** over PostgreSQL’s silver tables. Offers drag-and-drop charting, filtering, and dashboarding capabilities without requiring code—ideal for OLAP exploration.

### dbt (data build tool)  
Manages **SQL-based data transformations**, converting bronze data into tested, normalized silver views. All transformation models are stored in `~/scr/06_dbt`.

### Dagster  
Handles **data orchestration**, asset scheduling, and pipeline observability. Operates via a local webserver on port `3300` and executes ETL pipelines from CSV to PostgreSQL using Python-defined assets.

### MkDocs  
Provides the **governance layer** by serving structured project documentation aligned to DMBOK. It supports:
- Linking technical assets to business glossary terms
- Surfacing metadata (like last updated, version control)
- Improving transparency and knowledge transfer  
MkDocs bridges the gap between engineering outputs and business context.

### NGINX  
Provides a secure reverse proxy for accessing internal services (Grafana, Metabase, Dagster). Supports TLS encryption and optional authentication to simulate real-world access patterns and security posture.