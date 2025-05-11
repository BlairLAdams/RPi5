# Data Storage and Operations
Data storage and operations ensure that data is accessible, reliable, and maintained over time. In a water utility, this includes where structured data (e.g., SCADA readings, lab results) and unstructured content (e.g., PDFs, inspection photos) are stored, how they are backed up, and who is responsible for maintaining those systems. Storage operations also cover data retention, archiving, and system performance. For utilities beginning to centralize data in an EDW, operational storage decisions must balance accessibility, cost, and security, while ensuring that performance can meet the needs of analytics, compliance, and reporting workflows.

## Objective
Implement a scalable and resilient data storage strategy to support analytics, reporting, and data continuity.

### Key Results
- Designate primary and secondary storage locations for structured and unstructured data  
- Set up automated daily backups of the EDW and key dashboards  
- Document restore process and test recovery of one dataset  
- Define and apply retention policies to three data domains (e.g., SCADA logs, inspection records, work orders)  

## Core Processes
- Backup scheduling and integrity verification  
- Restore testing and incident simulation  
- Storage tiering and archiving strategy  
- Retention policy definition and enforcement  
- Monitoring of storage performance and availability  

## Suggested Metrics
- Backup success rate over rolling 30 days  
- Restore time for one mission-critical dataset  
- Percent of datasets with defined retention rules  
- Storage usage trends across tiers (hot/warm/archive)