# 🧭 Top 10 GM Questions Aligned with Open-Source Utility Analytics Stack

This guide aligns the key strategic questions a General Manager must answer with datasets, metrics, and tools from a modern open-source analytics stack for water utilities. It incorporates SCADA, CMMS, LIMS, GIS, customer service, general ledger data, and regulatory tracking (including NOVs/NTCs).

---

## 1. Are we delivering safe, reliable water service?

Operators, lab analysts, and compliance staff need a continuous pulse on water quality and system performance. Whether it's maintaining chlorine residuals or detecting low-pressure zones, real-time awareness of where, when, and why deviations occur is vital to safeguarding public health — and avoiding costly NOVs.

**Key Datasets**:
- `lims_samples`: Lab test results by site, timestamp, analyte  
- `scada_tags`: Real-time telemetry for pressure, tank levels, flow, chlorine  

**Key Metrics**:
- % of samples in compliance (e.g., chlorine ≥ 0.2 mg/L)  
- Low-pressure events per zone per month  
- Sample coverage vs regulatory sampling plan  

**Tools**: `pandas`, `dbt`, `Great Expectations`, `Dagster`, `Metabase`

---

## 2. Where are our biggest operational risks?

Asset managers and operations leads need visibility into which parts of the system are most vulnerable and why. Past failures, deferred maintenance, and aging infrastructure often signal where the next crisis will happen — and help prioritize proactive investment before regulatory intervention is triggered.

**Key Datasets**:
- `cmms_work_orders`: Failures, response times, backlogs  
- `asset_registry`: Install year, material, diameter, risk flags  
- `gis_mains`: Pipe alignments with spatial joins to failure points  

**Key Metrics**:
- Failure frequency by asset  
- % of assets past service life  
- Repeat service callouts by zone  

**Tools**: `GeoPandas`, `dbt`, `SQL`, `Metabase`, `Great Expectations`

---

## 3. How are we performing financially?

Finance teams and executive leadership must track how dollars are spent, where variances emerge, and which programs carry financial risk. This includes linking cost centers to field activity, justifying rate increases, and accounting for costs tied to NOV remediation or regulatory grant compliance.

**Key Datasets**:
- `general_ledger`: GL transactions by program, function, project  
- `cmms_work_orders`: Labor, equipment, and material costs  
- `regulatory_violations`: NOVs with associated penalties, legal fees, or corrective actions  

**Key Metrics**:
- O&M vs Capital expenditures  
- Budget variance by department or asset class  
- Total cost of compliance-related work  

**Tools**: `dbt`, `pandas`, `SQLAlchemy`, `Metabase`, `Dagster`

---

## 4. Are we meeting our regulatory obligations?

Compliance managers must ensure that all sampling, performance tracking, and reporting requirements are met — on time, in full, and with clear documentation. Proactively identifying and resolving gaps reduces exposure to NOVs, improves audit readiness, and strengthens public trust.

**Key Datasets**:
- `lims_samples`: Sample results and schedule adherence  
- `scada_tags`: Time-series data tied to pressure/flow permit limits  
- `regulatory_violations`: NOVs, NTCs, citations, and resolution logs  
- `lims_sample_plan`: Required sample frequency and location  

**Key Metrics**:
- % of required samples collected per period  
- Active vs resolved NOVs and NTCs  
- Average time to resolve compliance violations  

**Tools**: `dbt`, `Great Expectations`, `Dagster`, `Metabase`, `pandas`

---

## 5. Where should we invest next?

Capital planning, engineering, and finance need a shared view of where funds will yield the greatest impact — and prevent future service failures or regulatory fines. Investment decisions must be supported by risk scoring, asset performance, and documented community needs.

**Key Datasets**:
- `asset_registry`: Asset condition, install date, inspection history  
- `cmms_work_orders`: Cost, failure type, work order density  
- `gis_zones`: Overlay of infrastructure age, service gaps, equity metrics  
- `regulatory_violations`: Locations with recurring water quality or system issues  

**Key Metrics**:
- Capital reinvestment need by region  
- Risk-weighted prioritization index  
- % of budget tied to recurring NOV locations  

**Tools**: `dbt`, `GeoPandas`, `pandas`, `Metabase`, `SQL`

---

## 6. Are our customers satisfied?

Public-facing staff and leadership need clarity on where customers are experiencing issues — and how quickly the utility responds. Service reliability, water quality, and billing transparency all shape customer sentiment and, ultimately, regulatory and board scrutiny.

**Key Datasets**:
- `customer_service_tickets`: Complaint type, resolution time, location  
- `cmms_work_orders`: Work tied to customer calls  
- `lims_samples`, `scada_tags`: Events tied to service or quality complaints  

**Key Metrics**:
- Average response time per complaint type  
- Number of repeat complaints per customer or location  
- Complaints correlated with SCADA or LIMS anomalies  

**Tools**: `dbt`, `pandas`, `Metabase`, `Dagster`, `GeoPandas`

---

## 7. Is our team efficient and supported?

Operations and HR leadership need to ensure that staffing, scheduling, and workloads are balanced to meet service needs. Monitoring work volume, response time, and team capacity supports workforce planning, performance evaluation, and justifying budget or FTE requests.

**Key Datasets**:
- `cmms_work_orders`: Labor hours, task types, completion metrics  
- `general_ledger`: Payroll and labor allocation by activity  
- `asset_registry`: Task load by asset class or location  

**Key Metrics**:
- Avg close time per work order  
- Preventive vs reactive maintenance ratio  
- Labor hours per crew or region  

**Tools**: `dbt`, `SQL`, `pandas`, `Metabase`, `Great Expectations`

---

## 8. Are we prepared for emergencies and resilience?

Emergency managers and executive leadership need rapid access to system stress indicators, redundant infrastructure status, and critical asset locations. Resilience isn’t just about infrastructure — it’s about knowing what to do, where, and when under duress.

**Key Datasets**:
- `scada_tags`: Alerts, low-tank levels, critical pressures  
- `asset_registry`: Backup power status, redundancies, lifeline assets  
- `gis_layers`: Emergency response zones, evacuation routes, seismic overlays  
- `cmms_work_orders`: Emergency repairs and outage response  

**Key Metrics**:
- Number of tanks/basins without backup telemetry  
- Median time to restore service after major break  
- Resilience score by zone or facility  

**Tools**: `Dagster`, `GeoPandas`, `Metabase`, `pandas`, `SCADA exports`

---

## 9. Are we future-ready (digital, data-driven, sustainable)?

Executives and IT leadership must assess whether current systems and practices are scalable, open, and modern enough to support long-term resilience, smart metering, and transparency. A modular, open-source architecture ensures freedom from vendor lock-in while supporting innovation.

**Key Datasets**:
- PostgreSQL-backed domains: SCADA, LIMS, CMMS, GIS, GL, CSR  
- `dagster_logs`, `dbt_manifest`, `great_expectations_results`  
- Optional: metadata catalog (OpenMetadata or DataHub)  

**Key Metrics**:
- % of pipelines version-controlled and monitored  
- Data freshness across critical domains  
- % of reports/dashboards with defined lineage  

**Tools**: `Dagster`, `dbt`, `Great Expectations`, `Git`, `Metabase`, `PostgreSQL`

---

## 10. Can I trust the numbers I’m seeing?

Executives and board members need confidence in the accuracy, traceability, and consistency of reports. Trust in data is foundational — and must be demonstrated through validation, lineage, and reproducibility of all metrics presented.

**Key Datasets**:
- `great_expectations_results`: Data quality assertions  
- `dbt_manifest.json`: Model lineage and test coverage  
- `dagster_runs`: Job status, failures, success logs  
- Dashboard metadata and exposures in `Metabase`  

**Key Metrics**:
- % of models with tests passing  
- Number of failed data validations this month  
- % of dashboards with clear data lineage  

**Tools**: `Great Expectations`, `dbt`, `Dagster`, `Metabase`, `pandas`
