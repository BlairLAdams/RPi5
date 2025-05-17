# Modern Analytics Stack Comparisons
## A Platform-Agnostic View of the Data Ecosystem

This document compares the core components of modern analytics stacks across four major ecosystems:

- **On-Prem / Open Source**
- **Amazon Web Services (AWS)**
- **Google Cloud Platform (GCP)**
- **Microsoft Azure**

Each layer highlights tools for **data ingestion, processing, storage, transformation, orchestration, governance, observability, and visualization**.

---

### Storage & Data Layers

| Category               | On-Prem / Open Source        | AWS                      | GCP                         | Azure                          |
|------------------------|------------------------------|---------------------------|------------------------------|-------------------------------|
| **Data Lake Storage**  | HDFS, MinIO, Apache Ozone    | Amazon S3                 | Google Cloud Storage         | Azure Data Lake Storage Gen2  |
| **Object Storage**     | Ceph, MinIO                  | Amazon S3                 | GCS                          | Azure Blob Storage            |
| **Data Warehouse / OLAP** | ClickHouse, DuckDB, Druid | Redshift, Athena          | BigQuery                     | Synapse Analytics             |
| **Lakehouse Query Layer** | Trino, Presto, Dremio     | Athena, Redshift Spectrum | BigQuery (federated), Dremio | Synapse Serverless, ADX       |
| **Relational DB (OLTP)** | PostgreSQL, MySQL, MariaDB | RDS, Aurora               | Cloud SQL, AlloyDB           | Azure SQL DB, PostgreSQL      |

---

### Ingestion & Data Movement

| Category                  | On-Prem / Open Source      | AWS                        | GCP                           | Azure                          |
|---------------------------|----------------------------|-----------------------------|--------------------------------|-------------------------------|
| **Stream Ingestion**      | Apache Kafka, Redpanda     | Kinesis Data Streams        | Pub/Sub                        | Azure Event Hubs              |
| **Batch Ingestion / ETL** | Airbyte, Nifi, Singer      | AWS Glue, Data Pipeline     | Cloud Dataflow, Composer       | Data Factory, Synapse Pipelines |
| **Streaming Processing**  | Apache Flink, Kafka Streams| Kinesis Analytics, MSK+Flink| Dataflow (Apache Beam)         | Azure Stream Analytics        |

---

### Orchestration & Transformation

| Category                       | On-Prem / Open Source      | AWS                          | GCP                           | Azure                           |
|--------------------------------|-----------------------------|-------------------------------|--------------------------------|----------------------------------|
| **Orchestration**              | Airflow, Dagster            | MWAA, Step Functions          | Composer (Managed Airflow)     | Data Factory, Synapse Pipelines |
| **Data Transformation (ELT)**  | dbt-core                    | dbt Cloud on ECS, Glue, Lambda| dbt Cloud on BigQuery          | dbt Cloud on Synapse or SQL DB  |

---

### Metadata, Lineage & Governance

| Category             | On-Prem / Open Source        | AWS                          | GCP                      | Azure                        |
|----------------------|------------------------------|-------------------------------|---------------------------|------------------------------|
| **Metadata Catalog** | Amundsen, DataHub, OpenMetadata | Glue Data Catalog         | Google Data Catalog       | Microsoft Purview            |
| **Data Lineage**     | Marquez, OpenLineage         | Glue + OpenLineage            | Catalog + Lineage Preview | Purview + Lineage API        |
| **Access Control**   | OPA, Keycloak                | IAM, Lake Formation           | IAM, VPC-SC               | Azure AD, RBAC               |
| **Governance Tools** | Apache Ranger, Vault, OPA    | Lake Formation, Macie         | Dataplex, DLP             | Purview, Defender for Cloud  |

---

### Visualization & BI

| Category             | On-Prem / Open Source        | AWS               | GCP                    | Azure        |
|----------------------|------------------------------|--------------------|------------------------|--------------|
| **BI Tools**         | Superset, Metabase, Redash   | QuickSight         | Looker, Data Studio    | Power BI     |

---

### ML & AI Integration

| Category             | On-Prem / Open Source        | AWS                    | GCP                      | Azure              |
|----------------------|------------------------------|-------------------------|---------------------------|---------------------|
| **ML Integration**   | MLflow, Kubeflow, JupyterHub | SageMaker, EMR Notebooks| Vertex AI, Colab, AI Platform | Azure ML, Synapse ML |

---

### Observability & Data Quality

| Category                  | Example Tools                                         |
|---------------------------|-------------------------------------------------------|
| **Data Validation**       | Great Expectations, dbt tests, Soda SQL              |
| **Pipeline Monitoring**   | Airflow UI, Dagster UI, Prefect Cloud                |
| **Data Drift & Anomalies**| Monte Carlo, Databand, Bigeye, OpenMetadata alerts   |
| **Logging & Metrics**     | Prometheus, ELK Stack, CloudWatch, Azure Monitor     |

---

### Common Use Case Mappings

| Use Case                              | Example Stack                                             |
|---------------------------------------|------------------------------------------------------------|
| Lightweight, portable analytics       | DuckDB + dbt-core + Superset                              |
| Serverless analytics with ML          | BigQuery + Vertex AI + Looker                             |
| High-governance enterprise BI         | Synapse + Purview + Power BI                              |
| Real-time analytics with pipelines    | Kafka + Flink + ClickHouse or Redshift                    |
| Data mesh with semantic governance    | dbt Cloud + OpenMetadata + domain-specific BI             |

---

### References

- [https://www.getdbt.com](https://www.getdbt.com) – dbt transformation framework  
- [https://openmetadata.io](https://openmetadata.io) – Open-source metadata and governance  
- [https://aws.amazon.com/lake-formation/](https://aws.amazon.com/lake-formation/) – AWS governance & security  
- [https://cloud.google.com/dataplex](https://cloud.google.com/dataplex) – GCP metadata and data mesh  
- [https://azure.microsoft.com/en-us/services/purview/](https://azure.microsoft.com/en-us/services/purview/) – Microsoft Purview governance platform