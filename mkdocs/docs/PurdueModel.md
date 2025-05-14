# Purdue Model for Industrial Control Systems (ICS)

The Purdue Model (Purdue Enterprise Reference Architecture) is a layered architecture framework that defines how information technology (IT) and operational technology (OT) systems interact in industrial environments. It provides a reference for securing, segmenting, and modernizing systems used in manufacturing, utilities, and critical infrastructure.

---

## Purdue Model Overview

| Level   | Function                    | Scope                            | Common Examples                               |
|---------|-----------------------------|----------------------------------|------------------------------------------------|
| Level 5 | Enterprise Network (IT)     | Corporate applications and cloud | ERP, CRM, M365, BI Tools, Cloud Storage       |
| Level 4 | Business Logistics Systems  | Site-wide operations and analytics| MES, CMMS, LIMS, Historian, Data Lake         |
| Level 3 | Site Operations / DMZ       | Aggregation and security bridge  | SCADA servers, OPC-UA, MQTT Broker, Firewall  |
| Level 2 | Area Supervisory Control    | Local control room functions     | SCADA HMIs, Historian Nodes, Batch Control    |
| Level 1 | Basic Control               | Machine-level instructions       | PLCs, RTUs, PACs, Motor Controllers           |
| Level 0 | Physical Process            | Sensors and actuators            | Flow meters, temperature sensors, valves      |

---

## Modern Enhancements to Purdue Model

| Enhancement              | Placement     | Description                                                        |
|--------------------------|---------------|--------------------------------------------------------------------|
| Edge Compute / Gateway   | Levels 1–3     | Local preprocessing of OT data before transmission                 |
| Unified Namespace (UNS)  | Level 3.5      | MQTT or event-driven pub/sub model connecting OT to IT systems     |
| Cloud Integration        | Levels 4–5     | Data lakes, dashboards, AI/ML models, centralized reporting         |
| Zero Trust Security      | Levels 3–5     | Role-based access, network segmentation, encrypted northbound flows|
| Data Diodes / Brokers    | Level 3.5      | One-way data transmission from OT to IT                            |

---

## ICS Data Flow

```yaml
purdue_model:
  levels:
    level_5:
      name: Enterprise Network (IT)
      function: Corporate applications and cloud services
      examples:
        - ERP
        - CRM
        - Power BI
        - M365
        - Cloud Storage
    level_4:
      name: Business Logistics Systems
      function: Site-wide operations, reporting, analytics
      examples:
        - MES
        - CMMS
        - LIMS
        - Historian
        - Data Lake
    level_3:
      name: Site Operations / DMZ
      function: Aggregation of SCADA data, secure IT/OT boundary
      examples:
        - SCADA servers
        - OPC-UA
        - MQTT Broker
        - Firewalls
    level_2:
      name: Area Supervisory Control
      function: Local control room, process monitoring
      examples:
        - SCADA HMI
        - Historian nodes
        - Batch controllers
    level_1:
      name: Basic Control
      function: Machine-level automation and instruction execution
      examples:
        - PLCs
        - RTUs
        - PACs
    level_0:
      name: Physical Process
      function: Sensor data collection and actuator control
      examples:
        - Flow meters
        - Actuators
        - Temperature sensors
        - Valves

  enhancements:
    - name: Edge Compute
      placement: L1–L3
      description: Local preprocessing and buffering of OT data
    - name: Unified Namespace (UNS)
      placement: L3.5
      description: Real-time event-driven MQTT pub/sub architecture
    - name: Cloud Integration
      placement: L4–L5
      description: Enables cloud-based BI, AI/ML, and enterprise dashboards
    - name: Zero Trust Architecture
      placement: L3–L5
      description: Enforces fine-grained access and traffic segmentation
    - name: Data Diode / Broker
      placement: L3.5
      description: One-way transmission from OT to IT

  security_zones:
    - zone: Enterprise
      levels: [5]
      description: Business applications and cloud interfaces
    - zone: Industrial DMZ
      levels: [3.5]
      description: Segregates OT from IT; monitored bridge layer
    - zone: Manufacturing
      levels: [2, 3]
      description: Control room operations, SCADA visualization
    - zone: Control
      levels: [0, 1]
      description: Field-level, real-time deterministic control

  use_cases:
    - name: Predictive Maintenance
      tools: [MQTT, InfluxDB, MLflow, Power BI]
      levels_spanned: [1, 2, 3, 4, 5]
    - name: SCADA Modernization
      tools: [Node-RED, MQTT, Grafana]
      levels_spanned: [2, 3, 4, 5]
    - name: Regulatory Reporting
      tools: [Historian, dbt, Superset]
      levels_spanned: [3, 4, 5]
    - name: Leak Detection
      tools: [OPC-UA, Edge AI, Cloud Alert]
      levels_spanned: [0, 1, 3, 4]
    - name: Energy Optimization
      tools: [Smart Metering, MES, BI Dashboard]
      levels_spanned: [0, 1, 4, 5]

  references:
    - https://csrc.nist.gov/publications/detail/sp/800-82/rev-2/final
    - https://www.isa.org/standards-and-publications/isa-standards/isa-62443-series-of-standards
    - https://inductiveautomation.com/resources/article/what-is-the-purdue-model
    - https://docs.aws.amazon.com/whitepapers/latest/aws-industrial-iot/aws-industrial-iot.html
    - https://www.microsoft.com/security/blog/2021/10/27/zero-trust-for-ot/
