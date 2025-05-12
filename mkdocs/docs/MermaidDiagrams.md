# Mermaid Diagram Examples

Mermaid diagrams provide lightweight, code-based visuals ideal for use in data governance, analytics, and digital transformation projects. In the **water sector**, they are particularly useful for documenting SCADA workflows, governance processes, CIP project timelines, asset lifecycle states, and stakeholder communication flows — all in a version-controlled format that’s easy to embed in MkDocs or GitHub wikis.

This reference includes examples of all supported Mermaid diagram types relevant to technical documentation.

---

## Flowchart

**Description:**
Used for simple process flows, logic structures, or decision diagrams. Ideal for visualizing system logic, workflows, or stakeholder engagement steps in governance.

**Syntax:** `flowchart`

**Rendered Diagram:**

```mermaid
flowchart LR
  A[Start] --> B{SCADA Alarm?}
  B -- Yes --> C[Send Notification]
  B -- No --> D[Log Event]
  C --> E[Close Alert]
  D --> E
```

**Mermaid Code:**

````text
```mermaid
flowchart LR
  A[Start] --> B{SCADA Alarm?}
  B -- Yes --> C[Send Notification]
  B -- No --> D[Log Event]
  C --> E[Close Alert]
  D --> E
```
````

---

## Sequence Diagram

**Description:**
Visualizes interactions between components over time. Useful for illustrating SCADA alert flows or data handoffs across departments.

**Syntax:** `sequenceDiagram`

**Rendered Diagram:**

```mermaid
sequenceDiagram
  participant Operator
  participant SCADA
  participant Historian
  Operator->>SCADA: Acknowledge alarm
  SCADA->>Historian: Log acknowledgment
  Historian-->>Operator: Status updated
```

**Mermaid Code:**

````text
```mermaid
sequenceDiagram
  participant Operator
  participant SCADA
  participant Historian
  Operator->>SCADA: Acknowledge alarm
  SCADA->>Historian: Log acknowledgment
  Historian-->>Operator: Status updated
```
````

---

## Class Diagram

**Description:**
Represents object-oriented data structures. Ideal for modeling asset hierarchies or telemetry object models.

**Syntax:** `classDiagram`

**Rendered Diagram:**

```mermaid
classDiagram
  Sensor <|-- FlowMeter
  Sensor <|-- PressureSensor
  class Sensor {
    +string id
    +string type
    +recordReading()
  }
```

**Mermaid Code:**

````text
```mermaid
classDiagram
  Sensor <|-- FlowMeter
  Sensor <|-- PressureSensor
  class Sensor {
    +string id
    +string type
    +recordReading()
  }
```
````

---

## State Diagram

**Description:**
Illustrates state transitions. Useful for equipment states (on/off), work order flows, or data validation stages.

**Syntax:** `stateDiagram-v2`

**Rendered Diagram:**

```mermaid
stateDiagram-v2
  [*] --> Requested
  Requested --> Approved
  Approved --> Scheduled
  Scheduled --> Completed
  Completed --> [*]
```

**Mermaid Code:**

````text
```mermaid
stateDiagram-v2
  [*] --> Requested
  Requested --> Approved
  Approved --> Scheduled
  Scheduled --> Completed
  Completed --> [*]
```
````

---

## Entity Relationship Diagram (ERD)

**Description:**
Models database relationships. Ideal for billing systems, AMI integrations, or customer-asset linkages.

**Syntax:** `erDiagram`

**Rendered Diagram:**

```mermaid
erDiagram
  CUSTOMER ||--o{ SERVICE_CONNECTION : has
  SERVICE_CONNECTION ||--|{ METER : measures
  CUSTOMER {
    int id
    string name
  }
  SERVICE_CONNECTION {
    string location
    int status
  }
  METER {
    string serial
    float multiplier
  }
```

**Mermaid Code:**

````text
```mermaid
erDiagram
  CUSTOMER ||--o{ SERVICE_CONNECTION : has
  SERVICE_CONNECTION ||--|{ METER : measures
  CUSTOMER {
    int id
    string name
  }
  SERVICE_CONNECTION {
    string location
    int status
  }
  METER {
    string serial
    float multiplier
  }
```
````

---

## Gantt Chart

**Description:**
Displays project timelines and milestones. Common for CIP planning or dashboard rollout tracking.

**Syntax:** `gantt`

**Rendered Diagram:**

```mermaid
gantt
  title Smart Meter Rollout
  dateFormat YYYY-MM-DD
  section Planning
  Requirements :a1, 2025-01-01, 10d
  section Deployment
  District A :a2, after a1, 15d
  District B :a3, after a2, 15d
  section Reporting
  Summary Reports :a4, after a3, 5d
```

**Mermaid Code:**

````text
```mermaid
gantt
  title Smart Meter Rollout
  dateFormat YYYY-MM-DD
  section Planning
  Requirements :a1, 2025-01-01, 10d
  section Deployment
  District A :a2, after a1, 15d
  District B :a3, after a2, 15d
  section Reporting
  Summary Reports :a4, after a3, 5d
```
````

---

## Pie Chart

**Description:**
Visualizes simple proportion breakdowns (e.g., usage by sector, cost by category).

**Syntax:** `pie`

**Rendered Diagram:**

```mermaid
pie
title Water Demand by Sector
"Residential" : 50
"Commercial" : 20
"Industrial" : 10
"Agricultural" : 20
```

**Mermaid Code:**

````text
```mermaid
pie
title Water Demand by Sector
"Residential" : 50
"Commercial" : 20
"Industrial" : 10
"Agricultural" : 20
```
````

---

## Git Graph

**Description:**
Models Git workflow. Useful for documenting ETL pipelines or dashboard versioning.

**Syntax:** `gitGraph`

**Rendered Diagram:**

```mermaid
gitGraph
  commit
  commit
  branch dev
  checkout dev
  commit
  checkout main
  merge dev
```

**Mermaid Code:**

````text
```mermaid
gitGraph
  commit
  commit
  branch dev
  checkout dev
  commit
  checkout main
  merge dev
```
````

---

---

## Timeline

**Description:**
Used for plotting key events chronologically (e.g., audits, go-lives).

**Syntax:** `timeline`

**Rendered Diagram:**

```mermaid
timeline
  title AMI Deployment Timeline
  2024-01 : Kickoff
  2024-02 : Site Surveys
  2024-05 : Installations Start
  2024-09 : Full Go-Live
```

**Mermaid Code:**

````text
```mermaid
timeline
  title AMI Deployment Timeline
  2024-01 : Kickoff
  2024-02 : Site Surveys
  2024-05 : Installations Start
  2024-09 : Full Go-Live
```
````

---

## Journey (User Journey)

**Description:**
Maps user steps and emotional states across a process. Great for CX design or customer billing feedback.

**Syntax:** `journey`

**Rendered Diagram:**

```mermaid
journey
  title New Customer Onboarding
  section Website
    Register: 5: User
    Confirm Email: 4: User
  section Account Setup
    Add Service Address: 3: User
    Link Meter: 2: User
```

**Mermaid Code:**

````text
```mermaid
journey
  title New Customer Onboarding
  section Website
    Register: 5: User
    Confirm Email: 4: User
  section Account Setup
    Add Service Address: 3: User
    Link Meter: 2: User
```
````
