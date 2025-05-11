# Reference and Master Data
Reference and master data represent the stable, high-value data elements that provide consistency across systems. For water utilities, this includes locations, facility codes, analyte names, asset types, pressure zones, and customer classifications. Maintaining authoritative versions of these datasets — and ensuring they are applied consistently across CMMS, GIS, SCADA, billing, and reporting tools — is essential to integration, analytics, and regulatory compliance. A practical approach to master data management (MDM) starts by identifying key domains, selecting a source of truth for each, and publishing standardized values that downstream systems can adopt or validate against.

## Objective
Establish clear ownership and structure for high-value reference datasets that support accuracy and alignment across operational systems.

### Key Results
- Identify three master/reference data domains (e.g., analyte names, facility codes, asset classes)  
- Designate a system of record and data steward for each domain  
- Publish a reference table in the EDW and confirm usage in at least one dashboard or report  
- Document how changes are proposed, reviewed, and approved  

## Core Processes
- Domain identification and priority ranking  
- System-of-record designation  
- Reference table publication and access setup  
- Data value normalization and validation  
- Change control (e.g., new values, deprecation, synonym mapping)  

## Suggested Metrics
- Percent of reports referencing published master tables  
- Number of inconsistent or duplicate values resolved  
- Time-to-approve a reference value update  
- Frequency of unauthorized local overrides in source systems