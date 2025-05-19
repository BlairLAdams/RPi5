# Data Architecture Patterns

This section outlines foundational and modern data architecture patterns used to organize, transform, and deliver data across enterprise environments. These are technology-agnostic designs that define how data moves from source to consumption layers.

---

## 1. Traditional Enterprise Data Warehouse (EDW)

### Inmon (Top-Down)

This model is well-suited for water and air quality agencies that need to centralize data from multiple legacy systems and ensure traceable, historical reporting. It supports regulatory compliance, structured metadata, and audit trails, which are crucial in public sector environments. For successful end-user adoption, clear data ownership, centralized governance, and a dedicated data team are essential to manage the complexity and ensure trusted outputs.

* Centralized EDW using normalized 3NF schemas
* Subject-oriented, integrated, time-variant, non-volatile
* Data marts are downstream and derived
* **Industry Fit**: Government, utilities, finance, healthcare
* **Maturity Required**: High — centralized data governance and skilled ETL team

### Kimball (Bottom-Up)

Ideal for utilities starting with tactical dashboards or performance metrics (e.g., energy use, response times). This approach enables faster delivery of insights while gradually building toward an enterprise model. For successful adoption, it requires close collaboration between data engineers and business users, and investment in dimensional modeling training for analysts.

* Builds dimensional data marts first
* Uses star/snowflake schemas with conformed dimensions
* Combines marts into a warehouse bus architecture
* **Industry Fit**: Utilities, retail, manufacturing, public sector
* **Maturity Required**: Medium — cross-functional BI alignment and dimensional modeling

### Data Vault

Best for agencies with dynamic data sources and strict audit or lineage requirements. For example, tracking changes to sampling protocols, work orders, or regulatory standards over time. Adoption depends on strong metadata practices, automation tools, and staff capable of managing complex model structures.

* Hybrid model for agility, auditability, and traceability
* Uses Hubs (keys), Links (relationships), and Satellites (context)
* Suitable for volatile environments with frequent schema change
* **Industry Fit**: Banking, insurance, defense, telecom
* **Maturity Required**: High — metadata-driven modeling and strong governance controls

---

## 2. Lakehouse Architecture

For utilities and air quality agencies modernizing toward scalable cloud solutions, Lakehouse offers flexibility to handle both structured (e.g., work orders) and semi-structured (e.g., sensor logs) data. Key to adoption is strong DevOps support, investment in cloud infrastructure, and a data team trained in ACID-compliant formats like Delta or Iceberg.

* Combines data lake flexibility with warehouse reliability
* Supports both structured and semi-structured data
* Implements ACID transactions (Delta Lake, Apache Iceberg, Hudi)
* Unified platform for analytics, BI, and machine learning
* **Industry Fit**: Tech, utilities, life sciences, logistics
* **Maturity Required**: Medium to High — requires data engineering and cloud architecture skills

---

## 3. Medallion Architecture (Bronze–Silver–Gold)

A great fit for water utilities managing SCADA, CMMS, and LIMS data. This architecture supports data validation and enrichment workflows and aligns with public sector goals for transparency and stewardship. End-user success hinges on having clear documentation and gradual onboarding to promote trust in layered data.

* Staged refinement of data quality and business readiness

  * **Bronze**: Raw ingestion layer
  * **Silver**: Cleaned, filtered, and enriched
  * **Gold**: Aggregated, business-consumable layer
* Promotes modularity, traceability, and reusability
* **Industry Fit**: Utilities, energy, public health, education
* **Maturity Required**: Low to Medium — approachable for small teams, extensible for scale

---

## 4. Operational Data Store (ODS)

Ideal for near-term reporting needs in field operations, such as water main breaks, service tickets, or sampling events. Adoption is smoother if tools are integrated with work management systems and if business users are trained to distinguish between operational vs. historical data.

* Stores current, integrated data from multiple sources
* Supports near real-time operational reporting
* Often used as a staging area before loading into the EDW
* Limited historical depth compared to a warehouse
* **Industry Fit**: Field operations, customer service, logistics
* **Maturity Required**: Low — good entry point for operational analytics

---

## 5. Lambda Architecture

Relevant for water utilities with real-time telemetry (e.g., pressure, flow) that must also support historical reporting. Its complexity can be a barrier—successful adoption requires real-time observability needs, sufficient engineering capacity, and a well-governed approach to combining batch and stream data.

* Combines batch + real-time data pipelines

  * **Batch layer**: Immutable, append-only data for long-term processing
  * **Speed layer**: Real-time views for low-latency analytics
  * **Serving layer**: Unified query interface
* Used in time-sensitive environments like IoT or sensor networks
* **Industry Fit**: Smart cities, water/wastewater, industrial IoT
* **Maturity Required**: High — requires real-time pipeline design and dual-system maintenance

---

## 6. Kappa Architecture

Best suited for edge analytics or sensor networks with high-frequency data (e.g., SCADA, AMI, AQ sensors). Kappa simplifies operations by treating all data as a stream. For adoption, organizations must invest in stream-native tooling and establish real-time alerting or visualization use cases.

* Simplifies Lambda by treating all data as a stream
* No batch layer; supports continuous ingestion and transformation
* Ideal for streaming-first applications and observability pipelines
* **Industry Fit**: Utilities with high-frequency telemetry (SCADA, AMI)
* **Maturity Required**: High — stream-native tooling and operational resilience required

---

## 7. Event-Driven Architecture

Applies well to permit management, compliance actions, or telemetry alerting systems where each state change is significant. Adoption depends on having a culture of immutability and strong system integration capabilities. Event logs must be well-documented and queryable.

* Captures state changes as a sequence of immutable events
* Supports event sourcing, CDC (Change Data Capture), and temporal analytics
* Enables full audit trails, rollback, and lineage
* **Industry Fit**: Finance, compliance, regulated industries
* **Maturity Required**: Medium to High — requires data immutability and governance patterns

---

## 8. Federated Query / Virtual Warehouse

Useful for utilities with siloed systems or partner agencies needing cross-platform insights. Supports scenarios where moving data is restricted due to regulation or policy. Adoption requires data stewards to define views, ensure data quality, and train users on latency and performance tradeoffs.

* Allows unified querying across disparate sources without physical movement
* Useful in hybrid or regulatory-constrained environments
* Tools include Trino, Presto, Dremio, Starburst
* **Industry Fit**: Government, multi-agency programs, regulated data sharing
* **Maturity Required**: Medium — requires data virtualization strategy and security governance

---

## 9. Knowledge Graphs

Ideal for agencies maintaining asset registries, regulations, or ontologies (e.g., water quality standards, facility hierarchies). Knowledge graphs support metadata enrichment and lineage tracking. Success depends on well-curated data dictionaries and technical staff familiar with graph databases and semantic modeling.

* Represents data as entities and relationships (nodes + edges)
* Enables semantic querying, lineage tracking, and discovery
* Common in data catalogs, ontologies, and linked data models
* **Industry Fit**: Research, utilities, metadata-driven enterprises
* **Maturity Required**: High — requires semantic modeling expertise and supporting ontologies

---

## Summary

Each architecture pattern serves a different need depending on:

* Data volume, velocity, and variety
* Organizational size and complexity
* Governance, audit, and lineage requirements
* Real-time vs. batch processing needs
* Industry regulatory context
* Team maturity and data management culture

**Examples:**

* A small public works department may start with a **Kimball-style EDW** and **ODS** to centralize SCADA and CMMS exports.
* A mid-sized water district could adopt a **Medallion architecture** using **Postgres + dbt** for phased QA and dashboarding.
* A regional air quality agency may leverage a **Lakehouse** and **Kappa** model to handle high-frequency sensor data.
* A multi-agency regulatory program might adopt **Federated Query** to share data across jurisdictions without centralization.

These patterns can be mixed and layered to suit evolving enterprise requirements.