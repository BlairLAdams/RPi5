*Home > DMBOK > Reference and Master Data*

# Reference and Master Data

[Reference and Master Data](../glossary.md#master-data) are shared values and entities used across multiple systems and business processes.  
In a water utility, this may include zone codes, facility names, pipe materials, analyte lists, and asset classifications.  
These data types often form the backbone of integration efforts and are critical for aligning reporting and operations.

[Reference data](../glossary.md#reference-data) values are typically finite and stable (e.g., unit types, regions),  
while [master data](../glossary.md#master-data) refers to key business entities like stations, customers, or assets with lifecycle status and [system of record](../glossary.md#system-of-record) designations.

---

## Objective

Publish and maintain stewarded [reference](../glossary.md#reference-data) and [master data](../glossary.md#master-data) values to support integration, consistency, and reporting.

---

### Key Results

- Identify three priority domains (e.g., assets, analytes, pressure zones) with assigned stewards  
- Publish one [reference dataset](../glossary.md#reference-data) to a shared environment (e.g., EDW or reporting tool)  
- Designate a [system of record](../glossary.md#system-of-record) for each dataset  
- Document value crosswalks between two systems using the same domain  

---

## Core Processes

- Stewardship assignment by domain  
- Reference value curation and approval  
- [Metadata](../glossary.md#metadata) tagging for business context and refresh frequency  
- Change control for master data updates  
- Documentation of value mappings and exceptions  

---

## Suggested Metrics

- Number of domains with documented [master data](../glossary.md#master-data)  
- Percentage of dashboards using certified reference values  
- Time-to-update for code tables and dropdown lists  
- Number of system conflicts resolved via reference alignment

---

**← Previous:** [Document and Content Management](../07_content/index.md)  
**Next:** [Data Warehousing and Business Intelligence](../09_warehousing/index.md)
