# NIST Cybersecurity Framework (CSF) Guide

The NIST Cybersecurity Framework (CSF) provides a flexible, repeatable, and cost-effective approach for managing cybersecurity risk. It is widely adopted in critical infrastructure, utilities, and IT/OT environments.

Originally published by NIST in 2014 and updated in 2018 (v1.1) and 2024 (v2.0), the CSF consists of five **Core Functions**, further organized into **Categories** and **Subcategories**.

---

## 🔷 CSF Core Functions Overview

| Function   | Purpose                                       |
|------------|-----------------------------------------------|
| **Identify**   | Understand organizational context, risk, and assets |
| **Protect**    | Implement safeguards to ensure service delivery     |
| **Detect**     | Discover cybersecurity events in time               |
| **Respond**    | Take action during or after a detected event        |
| **Recover**    | Restore capabilities and services after disruption  |

---

## 📂 CSF Categories by Function

### 🟦 Identify

| Category                    | Description                                |
|----------------------------|--------------------------------------------|
| Asset Management            | Inventory physical and digital assets      |
| Governance                  | Define risk management roles and policies  |
| Risk Assessment             | Understand threats, vulnerabilities         |
| Supply Chain Risk Management| Identify third-party dependencies          |

### 🟩 Protect

| Category                | Description                                |
|------------------------|--------------------------------------------|
| Identity Management    | Control access to systems and data         |
| Awareness & Training   | Educate staff and stakeholders             |
| Data Security          | Protect data at rest and in transit        |
| Protective Technology  | Harden endpoints and network infrastructure|

### 🟨 Detect

| Category           | Description                                |
|-------------------|--------------------------------------------|
| Anomalies & Events| Monitor for deviations from normal behavior|
| Continuous Monitoring | Use tools to track assets and risks     |
| Detection Processes | Define playbooks and alerting protocols  |

### 🟥 Respond

| Category               | Description                                |
|-----------------------|--------------------------------------------|
| Response Planning     | Establish incident response processes       |
| Communications        | Coordinate with stakeholders and public     |
| Analysis              | Investigate impact and root cause           |
| Mitigation            | Contain the incident                        |
| Improvements          | Update response plans and security controls|

### 🟪 Recover

| Category               | Description                                |
|-----------------------|--------------------------------------------|
| Recovery Planning     | Maintain recovery procedures and backups    |
| Improvements          | Learn from incidents and strengthen posture |
| Communications        | Coordinate internal and external messaging  |

---

## 📊 Implementation Tiers

Tiers describe how an organization manages cybersecurity risk. They are not maturity levels but help assess current capabilities.

| Tier | Description                                 |
|------|---------------------------------------------|
| 1    | **Partial** – Ad hoc, reactive              |
| 2    | **Risk Informed** – Some risk processes exist|
| 3    | **Repeatable** – Formalized and consistent  |
| 4    | **Adaptive** – Continuous improvement based on lessons learned |

---

## 🏭 Utility/OT Mapping Examples

| CSF Function | Example for Water/Wastewater Utility              |
|--------------|---------------------------------------------------|
| Identify      | Inventory PLCs, SCADA servers, and telemetry nodes |
| Protect       | Role-based access to HMI terminals; VLAN isolation |
| Detect        | Use SCADA anomaly detection or IDS for OT traffic |
| Respond       | OT incident response runbooks for ICS downtime   |
| Recover       | Restore SCADA configs and test system integrity  |

---

## 🧰 Common Tools by Function

| Function | Tools & Technologies                                               |
|----------|--------------------------------------------------------------------|
| Identify | CMDB, OT asset discovery (Nozomi, Claroty), NIST RMF               |
| Protect  | RBAC, MFA, network segmentation, VPN, firewall                     |
| Detect   | SIEM, OT IDS, log correlation, endpoint detection (EDR)           |
| Respond  | SOAR, IR playbooks, ticketing (ServiceNow, Jira), audit logs      |
| Recover  | Immutable backups, BCP plans, system reimage scripts              |

---

## 📘 NIST CSF YAML (for automation or config-as-doc)

```yaml
csf:
  functions:
    identify:
      - asset_management
      - governance
      - risk_assessment
      - supply_chain_risk_management
    protect:
      - identity_management
      - awareness_training
      - data_security
      - protective_technology
    detect:
      - anomalies_and_events
      - continuous_monitoring
      - detection_processes
    respond:
      - response_planning
      - communications
      - analysis
      - mitigation
      - improvements
    recover:
      - recovery_planning
      - improvements
      - communications
  tiers:
    1: Partial
    2: Risk Informed
    3: Repeatable
    4: Adaptive
