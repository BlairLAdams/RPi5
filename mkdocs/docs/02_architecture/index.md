*Home > DMBOK > Data Architecture*

# Data Architecture

[Data Architecture](../glossary.md#data-architecture) defines the blueprint for how data is structured, stored, and integrated across systems.  
In a water utility, this includes designing how data flows between [line of business systems](../glossary.md#line-of-business-system) such as [CMMS](../glossary.md#cmms), [SCADA](../glossary.md#scada), and [GIS](../glossary.md#gis),  
and how it's centralized into an [Enterprise Data Warehouse](../glossary.md#data-warehouse-edw). Architecture decisions clarify the [system of record](../glossary.md#system-of-record) for key data domains,  
standardize [reference data](../glossary.md#reference-data), and document data movement through [pipelines](../glossary.md#data-pipeline).

---

## Objective

Design and document a scalable [data architecture](../glossary.md#data-architecture) to support trustworthy, integrated data analytics.

---

### Key Results

- Create a current-state architecture diagram (source systems, [data pipelines](../glossary.md#data-pipeline), consumers)  
- Designate the [system of record](../glossary.md#system-of-record) for three major domains  
- Document at least one [data flow](../glossary.md#data-pipeline) from source to warehouse  
- Publish an inventory of data sources with refresh frequencies and business owners  

---

## Core Processes

- Architecture diagramming and validation  
- Data domain and [system of record](../glossary.md#system-of-record) assignment  
- Reference data harmonization  
- Metadata tagging for architectural components  
- Integration onboarding and change tracking  

---

## Suggested Metrics

- Number of systems diagrammed with data lineage  
- Percentage of domains with confirmed [system of record](../glossary.md#system-of-record)  
- Time-to-update diagrams after system changes  
- Reduction in redundant data stores

---

**← Previous:** [Data Governance](../01_governance/index.md)  
**Next:** [Data Modeling and Design](../03_modeling/index.md)
