# AI/ML Design Guidelines for Medallion Architecture

This guide defines key design principles, implementation techniques, and rationale for embedding machine learning and analytics workflows into a **Medallion Architecture** using tools such as **PostgreSQL, dbt, Dagster, Metabase, and Python**.

---

## Medallion Architecture Overview

### Bronze Layer – Raw Data Ingestion  
**Description**: This layer ingests raw, unaltered data from source systems—logs, APIs, sensor feeds, files, etc.  
**Target Audience**: Data engineers, ETL developers, system integrators

### Silver Layer – Cleaned and Curated Data  
**Description**: This layer holds validated, normalized, and joinable data used to build features and perform analytics.  
**Target Audience**: Analytics engineers, ML engineers, dashboard developers

### Gold Layer – Feature Store and Analytical Outputs  
**Description**: This layer contains enriched datasets, engineered features, predictions, KPIs, and modeling outputs.  
**Target Audience**: Data scientists, business analysts, decision-makers, ML ops

---

## Bronze Layer – Raw Ingestion

### 1. Time-Syncing and Timestamps  
**What**: Ensure every record has a consistent, standardized timestamp.  
**How**:
- Use `TIMESTAMP WITH TIME ZONE` in PostgreSQL.  
- Normalize all times to UTC using `pendulum` or `pytz`.  
- Capture both `event_time` and `ingestion_time`.  
**Why**: Enables accurate joins, time-based aggregations, and leakage-free model training.

---

### 2. Schema Versioning  
**What**: Track changes to data structure over time.  
**How**:
- Add a `schema_version` column.  
- Log changes in a `schema_audit_log` table.  
- Use `jsonb` columns for semi-structured data.  
**Why**: Prevents breakage in downstream pipelines due to silent schema drift.

---

### 3. Ingestion Latency vs. Model Freshness  
**What**: Measure the delay between data occurrence and ingestion.  
**How**:
- Capture `ingestion_time` at load.  
- Track `ingestion_time - event_time` as a latency metric.  
- Visualize trends in dashboards.  
**Why**: Helps assess model freshness and determine retraining intervals.

---

### 4. Source Metadata and Provenance  
**What**: Record where and how each record originated.  
**How**:
- Add metadata fields: `source_name`, `filename`, `batch_id`, etc.  
- Store source files in `/data/raw/` or object storage.  
- Log ingestion status in a centralized table.  
**Why**: Enables audits, traceability, and debugging of unexpected anomalies.

---

## Silver Layer – Cleaned, Normalized, and Join-Ready

### 1. Feature Stability  
**What**: Keep feature definitions consistent across time and models.  
**How**:
- Enforce value types and allowed sets in dbt or Great Expectations.  
- Normalize encodings and signs.  
- Alert on drifted or out-of-bound values.  
**Why**: Ensures model training and inference remain stable and predictable.

---

### 2. Unit Normalization  
**What**: Standardize physical units to ensure comparability.  
**How**:
- Use the `pint` library for conversions.  
- Store raw and normalized values with unit labels.  
- Maintain a `dim_units` table for lookup.  
**Why**: Avoids data drift and misinterpretation from inconsistent measurement systems.

---

### 3. Missing Value Strategy  
**What**: Define and apply consistent rules for missing values.  
**How**:
- Add `is_<field>_missing` flags.  
- Impute with domain-appropriate logic (mean, zero, ffill, etc.).  
- Log and version imputation rules.  
**Why**: Models need explicit treatment of nulls to avoid unpredictable behavior.

---

### 4. Conformed Dimensions  
**What**: Harmonize shared entities across datasets.  
**How**:
- Build and maintain `dim_customer`, `dim_location`, etc.  
- Use UUIDs or hashed surrogate keys.  
- Refresh on schedule via Dagster assets.  
**Why**: Supports reusable joins, unified reporting, and integrated ML features.

---

### 5. As-of Joins  
**What**: Perform joins using only data available up to a specific point in time.  
**How**:
- Use `LATERAL JOIN` or windowed `ROW_NUMBER()` in SQL.  
- Parameterize timestamp cutoffs for backtesting or training sets.  
- Wrap in reusable dbt macros.  
**Why**: Prevents data leakage by avoiding future-peeking during feature creation.

---

## Gold Layer – Feature Store and Aggregated Outputs

### 1. Feature Versioning  
**What**: Track changes to feature generation logic.  
**How**:
- Tag records with `feature_version`, `code_hash`, and `generated_at`.  
- Use Git to manage transformation scripts.  
- Register logic and parameters in metadata tables.  
**Why**: Enables reproducibility and rollbacks for modeling and governance.

---

### 2. Label Leakage Prevention  
**What**: Ensure no target label information is accidentally used in training features.  
**How**:
- Enforce `feature_time < label_time` logic.  
- Write automated tests to catch leaks.  
- Document prediction cutoffs explicitly in code and metadata.  
**Why**: Leakage produces misleadingly strong model results and weak production behavior.

---

### 3. Windowed Feature Logic  
**What**: Use rolling windows to create dynamic, time-sensitive features.  
**How**:
- Apply `pandas.rolling()` or `dbt_utils.rolling_avg()`  
- Align window end time with prediction timestamps.  
- Parameterize for A/B testing or seasonal tuning.  
**Why**: Captures behavior patterns and trends without introducing future data.

---

### 4. Entity-Event Separation  
**What**: Keep static entity info separate from time-series or event logs.  
**How**:
- Use `dim_entity` tables and `fact_event` logs.  
- Join via `entity_id` at query or feature build time.  
- Maintain independent update cadences.  
**Why**: Supports flexibility in modeling, schema reuse, and long-term maintenance.

---

### 5. Prediction Audit Trail  
**What**: Log inference details to support monitoring, accountability, and compliance.  
**How**:
- Create a `prediction_log` table with:  
  - `model_version`, `input_hash`, `predicted_at`, `confidence`, `input_json`  
- Log inference latency and batch IDs.  
- Store SHAP or LIME explanations alongside results if needed.  
**Why**: Enables traceability, fairness audits, and post-hoc validation of model outputs.

---

## Explainability & Reproducibility Enhancements

### SHAP (SHapley Additive exPlanations)  
**What**: A game-theoretic method to attribute a prediction to each input feature.  
**How**:
- Install: `pip install shap`  
- Use `TreeExplainer` or `KernelExplainer` depending on model type.  
- Visualize with `shap.summary_plot()` or `force_plot()`.  
**Why**: Helps data scientists, auditors, and stakeholders understand why a model made a decision.

---

### LIME (Local Interpretable Model-Agnostic Explanations)  
**What**: Builds a local, human-interpretable approximation of any model near a single prediction.  
**How**:
- Install: `pip install lime`  
- Use `LimeTabularExplainer()` with training data  
- Call `.explain_instance()` for individual predictions  
**Why**: Provides understandable rationales for decisions made by complex or opaque models.
