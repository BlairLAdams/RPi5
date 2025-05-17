# Data Warehouse Architectures

This page introduces foundational and modern data warehouse architectures. It includes the evolution of DW approaches, key pioneers and books, and practical implementation patterns used in enterprise analytics and utility operations.

---

## Overview

A **data warehouse (DW)** is a centralized platform designed to integrate, store, and organize structured data for analytics, reporting, and business intelligence. It serves as a core component in enterprise data strategy.

---

## Objectives

- Consolidate cross-system data for consistent analytics
- Improve report performance and data quality
- Enable governed, historical, and secure access to enterprise data
- Support modeling, stewardship, and compliance frameworks

---

## Foundational Frameworks

### Bill Inmon: Corporate Information Factory

- Known as the **father of data warehousing**
- Advocates a **top-down** approach:
  - Data is modeled in a normalized, 3NF format in the EDW
  - Data marts are created downstream
- Emphasis on **subject-oriented**, **integrated**, **non-volatile**, and **time-variant** data

**Key Book:**  
*Building the Data Warehouse* (Inmon, 2005)  
ISBN: 9780764599446

---

### Ralph Kimball: Dimensional Modeling

- Advocates a **bottom-up** approach:
  - Start with dimensional data marts for immediate value
  - Combine marts into a conformed dimensional warehouse
- Emphasizes star/snowflake schema, fact/dimension modeling

**Key Book:**  
*The Data Warehouse Toolkit* (Kimball & Ross, 3rd Edition)  
ISBN: 9781118530801

---

### Dan Linstedt: Data Vault Architecture

- Aimed at scalability and auditability in **high-change environments**
- Combines elements of both Inmon and Kimball
- Uses **hubs**, **links**, and **satellites** to track core business concepts and changes

**Key Book:**  
*Building a Scalable Data Warehouse with Data Vault 2.0*  
ISBN: 9780128025109

---

## Modern Architecture Patterns

### 1. Traditional Layered Architecture

**Components:**
- Source Systems → Staging → EDW → Data Marts → BI Tools
- Often built with ETL tools like SSIS, Informatica, Talend

**Best Fit:**
- Utilities with batch processing and compliance reporting needs

---

### 2. Medallion Architecture (Bronze–Silver–Gold)

**Popularized by:** Databricks  
**Stages:**

- **Bronze**: Raw ingestion  
- **Silver**: Cleaned and filtered  
- **Gold**: Aggregated, business-ready

**Benefits:**

- Modular and flexible
- Supports real-time and batch pipelines
- Easily integrates with dbt, Dagster, and Lakehouse platforms

---

### 3. Lakehouse Architecture

**Combines** the openness of data lakes with the reliability of warehouses.

**Features:**

- Schema enforcement and ACID (Atomicity, Consistency, Isolation, and Durability) compliance (Delta Lake, Iceberg, Hudi)
- Supports both structured and semi-structured data
- Enables analytics and ML from a single platform

**Tool Examples:**

- Databricks, Snowflake, Apache Hudi, Delta Lake, DuckDB

---

## Tool Landscape by Architecture

| Architecture      | Tools (Data Platform)            | Tools (Pipeline & BI)                |
|------------------|-----------------------------------|--------------------------------------|
| Inmon-style       | Oracle, SQL Server, PostgreSQL   | Informatica, SSIS, Cognos            |
| Kimball-style     | Redshift, BigQuery, Snowflake    | dbt, Power BI, Tableau               |
| Data Vault        | PostgreSQL, Snowflake, Azure SQL | VaultSpeed, dbtvault, WhereScape     |
| Medallion         | Delta Lake, DuckDB, BigQuery     | dbt, Dagster, Great Expectations     |
| Lakehouse         | Databricks, Trino, Iceberg       | Superset, Metabase, Apache Spark     |

---

## Governance and DMBOK Alignment

- **Data Architecture**: Defines zones/layers and schema strategy  
- **Data Integration**: Staging, orchestration, and lineage  
- **Data Storage & Operations**: Performance, reliability, cost  
- **Data Governance**: Metadata, ownership, and access policies  
- **Metadata Management**: Enables catalogs, glossaries, lineage  

---

## Recommended Reading

- *The Data Warehouse Toolkit* – Ralph Kimball  
- *Building the Data Warehouse* – Bill Inmon  
- *Data Warehouse Design Solutions* – Kimball et al.  
- *Building a Scalable Data Warehouse with Data Vault 2.0* – Dan Linstedt  
- *Fundamentals of Data Engineering* – Joe Reis & Matt Housley

---

## Key Takeaways

- Inmon and Kimball differ in sequencing, but both are foundational
- Data Vault supports auditability and long-term history
- Medallion and Lakehouse architectures offer flexibility for modern analytics
- Choose your approach based on use case, org size, and governance needs
