# From Raw Data to Reliable Insights: A Tiered Approach for Water Utilities

Water utilities rely on a growing stream of data from SCADA, CMMS, and LIMS systems to field reports and lab results. To transform this data into insights, it must be structured, cleaned, and contextualized so that engineers, analysts, and executives can all trust what they’re seeing.

One proven way to do this is by following a **layered data architecture** a method popularized by data warehousing pioneer **Ralph Kimball**, and today adapted by both open-source and cloud-native platforms. Kimball emphasized clarity, usability, and dimensional modeling, shaping data to reflect the way people think and make decisions.

This approach is commonly referred to as the **Bronze, Silver, and Gold** model, especially in platforms like Databricks. But the same pattern appears across tools with different labels:

- **Bronze** is also known as **Raw**, **Staging**, or **Landing Zone**
- **Silver** is referred to as **Cleaned**, **Core**, **Conformed**, or **Integrated**
- **Gold** goes by **Semantic Layer**, **Presentation**, **Mart**, or **Business KPIs**

These tiers also align with how data systems behave technically:

- The **Bronze layer** typically uses **OLTP systems** (Online Transaction Processing) — optimized for high-speed data entry, retrieval, and row-level accuracy
- The **Gold layer** relies on **OLAP systems** (Online Analytical Processing) — built for slicing, aggregating, and drilling into data for reporting and dashboards
- The **Silver layer** sits in between — using OLTP-style storage with increasing OLAP behaviors as data is joined, transformed, and analyzed

This layered model creates structure and accountability — so analysts can explore freely, and decision-makers can trust the numbers.

---

## 🟫 Bronze – Raw Data and the Source of Truth

Bronze is the **raw ingestion layer**. It captures every file, reading, and log exactly as it was received from SCADA sensors, CMMS exports, LIMS reports, spreadsheets, and APIs.

Nothing is filtered or modified. Every record is timestamped and stored for traceability. This layer serves as the **source of truth** — critical for audits, data science, historical investigations, or future reprocessing if definitions change.

Technically, Bronze often lives in **OLTP systems** like PostgreSQL — designed for quick, accurate capture of row-level data.

**Used by**:  
SCADA engineers, developers, data scientists building models or monitoring ML drift, compliance and IT teams

**Purpose**:  
Preserve full-fidelity source data; support audits, modeling, and traceability

**Also known as**:  
Raw, Staging, Landing, Base Layer

---

## 🪙 Silver – Clean Data for Exploration and Innovation

Silver is the **refined and integrated layer**. Here, raw records are cleaned, deduplicated, and aligned across systems — such as linking pump runtimes with work orders, or joining lab results with field inspections.

This layer powers **ad hoc analysis, dashboards, and exploratory insight**. Analysts and engineers use Silver to create custom filters, calculate new metrics, and answer operational questions — often through tools like Power BI or Python notebooks.

While still stored in OLTP-like systems, Silver begins to show **OLAP characteristics**: dimensional joins, aggregations, and slicing across time, site, and asset class.

**Used by**:  
Analysts, engineers, power users, dashboard authors, planning teams

**Purpose**:  
Support diagnostics, self-service analysis, metric development, and operational reporting

**Also known as**:  
Cleaned, Integrated, Core, Conformed, Intermediate Layer

---

## 🥇 Gold – Trusted Metrics for Decision-Making

Gold is the **semantic layer** a curated, documented, and versioned set of business metrics. It defines KPIs like "chlorine compliance rate," "average days to close a work order," or "downtime per pump."

Gold is where **enterprise alignment** happens. Metrics here are governed and consistent — used across executive dashboards, finance reports, board briefings, and regulatory submissions.

These datasets typically live in **OLAP-optimized systems**  (ex. PostGres, DuckDB or BI models in Power BI) supporting fast reads, aggregations, and secure slicing by geography or time.

**Used by**:  
Directors, general managers, compliance leads, finance and strategy teams

**Purpose**:  
Power strategic dashboards, ensure metric consistency, drive regulatory and performance reporting

**Also known as**:  
Presentation Layer, KPI Model, Semantic Layer, Business Mart

---

## 🔁 Tier-Based Update Intervals

Each layer in this architecture has its own ideal update frequency — based on its users, purpose, and technical requirements.

**Bronze – Frequent or Real-Time**  
This layer ingests raw data as it arrives. SCADA readings, sensor logs, and CSV exports should be written to Bronze as frequently as needed, often every few minutes or hourly, to preserve completeness and support real-time models.

**Silver – Hourly to Daily**  
Silver should be updated thoughtfully. It serves users exploring trends or diagnosing recent events. Updates every hour or once daily are typically sufficient. This timing avoids propagating unvalidated data and gives time for QA processes to catch issues.

**Gold – Daily to Weekly**  
Gold values consistency over freshness. Daily or weekly updates ensure stable KPIs for reporting and decision-making. Changes should follow a versioned workflow, with clear documentation and review.

Rule of thumb:  
> **Fastest updates in Bronze, careful cadence in Silver, and deliberate governance in Gold.**

---

## 🤝 Hybrid Governance: Encouraging Innovation Without Fragmentation

To stay agile, teams must have the freedom to experiment but also the structure to ensure shared truth. In a hybrid governance model, each tier plays a role in both exploration and standardization:

1. **Explore in Silver**  
   Analysts and power users can prototype new metrics and filters using cleaned, reliable Silver-layer data. These may include new classifications, time windows, or operational definitions relevant to a specific site or department.

2. **Model from Bronze**  
   Data scientists and advanced users can work directly with raw Bronze data to build machine learning models, conduct anomaly detection, or generate new operational insights. Starting from the unfiltered source ensures reproducibility, full context, and access to outliers or edge cases that might be cleaned away in Silver.

3. **Promote to Gold**  

   When a metric, model output, or derived feature proves valuable:

   - It is reviewed by data leads and operational SMEs
   - The logic or model output is formalized in DBT or SQL
   - It is added to the governed Gold layer for broad reuse
   - Dashboards and reports are updated to reflect the shared definition

4. **Track lineage**  
   Maintain a register of all metrics and model-derived outputs that graduate from Silver or Bronze to Gold. This helps promote accountability, document assumptions, and create a feedback loop for future refinement.

5. **Protect enterprise outputs**  
   Dashboards used for strategic planning, board briefings, or regulatory submissions should only draw from the Gold layer to ensure stability, explainability, and data trustworthiness.

This hybrid approach allows analysts and modelers to innovate, while protecting business users from conflicting definitions or unverified results. It also ensures that AI and machine learning outputs contribute to, rather than compete with, the organization's shared understanding of performance.

---

## ✅ Why This Works for Water Utilities

Water agencies don’t need a massive tech stack they need; structure, transparency, and alignment.

- **Bronze** ensures nothing is lost or overwritten
- **Silver** empowers analysts to explore operational trends
- **Gold** creates consistency and clarity in metrics that matter