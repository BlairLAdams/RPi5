# DMBOK Glossary

This glossary defines core terms from the DMBOK v2 framework, tailored for use in public water utilities.

---

### Access Control
The process of defining and enforcing who can view, edit, or delete data, based on roles or permissions.

### Analytics
The practice of exploring, visualizing, and interpreting data to inform decisions or detect trends.

### Anomaly Detection
Techniques used to identify unexpected or unusual patterns in datasets — often used for monitoring or quality control.

### Application Programming Interface (API)
A defined method for systems to exchange data and services securely and consistently.

### Archiving
The process of moving inactive data to long-term storage while preserving integrity and retrievability.

### As-Built Data
Information that reflects the final built condition of infrastructure, often linked to GIS or engineering records.

### Audit Trail
A record of all changes to data or system access, used for traceability, security, and compliance.

### Authoritative Source
The recognized source for a particular dataset or value, typically the system of record or a steward-approved dataset.

### Benchmarking
Comparing key performance metrics across time periods, teams, or external organizations to assess effectiveness.

### Business Glossary
A shared list of clearly defined business terms that ensures everyone uses the same language across reports, dashboards, and systems.

### Business Intelligence (BI)
Tools and processes that transform raw data into dashboards, reports, and insights for strategic or operational decisions.

### Change Management
The structured process of planning, approving, and documenting changes to data definitions, sources, or systems.

### Classification Scheme
A structured system for categorizing assets, work types, or data records using consistent codes or labels.

### Compliance Reporting
Generating reports required by regulatory agencies (e.g., EPA, state water boards), often from the EDW or LIMS.

### Configuration Management
Tracking and managing system settings, schemas, or ETL parameters to ensure consistent environments.

### Contextual Data
Supporting information that gives meaning to primary data — such as date, location, or condition assessment.

### Controlled Vocabulary
A predefined list of acceptable terms or codes for a field, used to ensure data consistency (e.g., work order types).

### Critical Data Element
A data field or metric considered essential to operational decisions, compliance, or reporting.

### Curation
The ongoing process of reviewing, refining, and publishing data so it’s accurate, well-documented, and ready for use.

### Dashboards
Visual tools used to present KPIs or metrics using charts, gauges, and tables — often powered by BI tools.

### Data Architecture
The structural design for how data is stored, organized, and integrated across systems like CMMS, SCADA, GIS, and LIMS.

### Data Catalog
A searchable inventory of available datasets and metadata, often used to support self-service analytics and data governance.

### Data Cleansing
The process of correcting or removing inaccurate, incomplete, or duplicated data entries.

### Data Dictionary
A central listing of field names, types, meanings, and valid values — often used alongside metadata.

### Data Enrichment
The process of enhancing a dataset with additional context, reference values, or derived attributes.

### Data Governance
The decision-making framework that defines who is responsible for data, how decisions are made, and what policies ensure consistency and accountability.

### Data Integration
The process of combining data from multiple systems to create a unified, consistent dataset, often via ETL/ELT pipelines.

### Data Lineage
The record of where data originates, how it flows through systems, and how it’s transformed along the way.

### Data Literacy
The ability of staff to read, understand, and communicate using data effectively in their role.

### Data Mapping
Aligning fields from one system to another — often used when integrating or migrating datasets.

### Data Mart
A focused subset of the EDW designed for a specific purpose or business domain, such as water quality or maintenance.

### Data Modeling
The process of defining entities, relationships, and business rules that structure how data is stored and used.

### Data Owner
The role responsible for approving access and setting rules for how data can be used, usually aligned with business leadership.

### Data Pipeline
A set of processes that extract, transform, and load data from source systems into a target system like an EDW.

### Data Profiling
The process of analyzing datasets to understand structure, quality, and patterns before transformation.

### Data Quality
The discipline of ensuring data is accurate, complete, timely, consistent, and fit for use.

### Data Retention Policy
A formal guideline defining how long data is kept, and when it should be archived or deleted.

### Data Source
The original location or system from which a dataset originates (e.g., a SCADA historian or LIMS export).

### Data Steward
The person responsible for ensuring a specific dataset is accurate, well-documented, and maintained over time.

### Data Transformation
Any process that reshapes, converts, or joins data for a downstream use case (e.g., combining tables, converting units).

### Data Use Agreement
A documented policy or contract defining how a dataset can be used, shared, or published.

### Data Warehouse (EDW)
A centralized system where cleaned and transformed data from operational systems is stored for analysis and reporting.

### Decoupling
Designing systems so that components (like source systems and dashboards) can evolve independently.

### Document and Content Management
The management of unstructured information like reports, photos, and SOPs — ensuring accessibility and version control.

### Duplicate Record
Two or more records that represent the same entity, causing redundancy and potential conflict.

### ELT (Extract-Load-Transform)
A modern integration pattern where data is first loaded into the warehouse, then transformed using SQL or tools like dbt.

### ETL (Extract-Transform-Load)
A traditional integration pattern where data is transformed before being loaded into the target database.

### Governance Committee
A cross-functional group that helps guide data policies, resolve conflicts, and prioritize governance work.

### Line of Business System
A system that supports a specific utility function, such as SCADA (operations), CMMS (maintenance), or LIMS (lab).

### Lineage
See 'Data Lineage.'

### Master Data
Key reference entities like asset types, pressure zones, or customer classes that should remain consistent across systems.

### Metadata
Information about data — such as its definition, origin, steward, and refresh frequency — used to support discovery and governance.

### Metrics
Quantifiable measures (e.g., % data completeness, number of open issues) used to track data quality, governance, and operational performance.

### Operational Data Store
A staging area for cleaned but not yet aggregated data, often used as an intermediate step between raw source and EDW.

### Reference Data
Standardized lists or codes used for validation — such as analyte names, asset categories, or work order types.

### Silver Layer
The curated, joined, and cleaned set of EDW tables ready for business use — downstream of raw source ingestion.

### Source System
The original system where data is generated (e.g., SCADA, CMMS), before any transformation or centralization.

### Stewardship
The active process of managing and maintaining data quality, documentation, and definitions.

### System of Record
The officially designated system responsible for maintaining the authoritative version of a dataset.

### Transformation
The process of reshaping or standardizing data to make it consistent and useful — e.g., converting formats, units, or field names.

### Trusted Dataset
A dataset that meets defined governance, quality, and stewardship standards, making it suitable for enterprise use.

### Validation Rule
A logic statement or constraint used to test whether a value is complete, correct, or consistent (e.g., required fields, valid ranges).