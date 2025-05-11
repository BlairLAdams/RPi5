# Reference and Master Data

[Reference and Master Data](../glossary.md#master-data) represent stable, shared values used across multiple systems and departments.  
In a water utility, this may include analyte codes, facility IDs, pipe material types, pressure zones, or asset classifications.  
These values must be consistent across [line of business systems](../glossary.md#line-of-business-system) such as [SCADA](../glossary.md#scada), [CMMS](../glossary.md#cmms), [GIS](../glossary.md#gis), and billing.

Managing [reference data](../glossary.md#reference-data) involves publishing standards, assigning stewards, and enforcing version control.  
[Master data](../glossary.md#master-data) often maps to key identifiers like location, asset, or customer, and typically has a designated [system of record](../glossary.md#system-of-record).

---

## Objective

Establish trusted, stewarded [reference](../glossary.md#reference-data) and [master data](../glossary.md#master-data) sources to support accurate integration and reporting.

---

### Key Results

- Identify and steward three core domains (e.g., facility codes, pressure zones, asset types)  
- Assign a [system of record](../glossary.md#system-of-record) for each and publish to EDW  
- Publish a version-controlled [reference dataset](../glossary.md#reference-data) used in at least one dashboard  
- Define a change control process for approving updates  

---

## Core Processes

- Domain identification and prioritization  
- Reference table publication and access  
- Cross-system value mapping  
- Change request review and approval workflow  
- Stewardship assignment and contact documentation  

---

## Suggested Metrics

- Coverage of [reference data](../glossary.md#reference-data) in certified dashboards  
- Number of conflicting or duplicate codes resolved  
- Time-to-approve value changes  
- Frequency of unauthorized overrides in source systems
