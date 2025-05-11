# Mermaid Diagram Examples

## Design Thinking Flowchart

```mermaid
flowchart LR
    A[Empathize] --> B[Define]
    B --> C[Ideate]
    C --> D[Prototype]
    D --> E[Test]
    E --> A[Empathize]
    style A fill:#f9f,stroke:#333,stroke-width:1px
    style B fill:#bbf,stroke:#333,stroke-width:1px
    style C fill:#bfb,stroke:#333,stroke-width:1px
    style D fill:#ffb,stroke:#333,stroke-width:1px
    style E fill:#fbb,stroke:#333,stroke-width:1px
```
## Agile / Kanban Flowchart

```mermaid
flowchart TB
  %% Align columns left to right
  subgraph BACKLOG [Backlog]
    direction TB
    A1[Define terms]
    A2[Assess data owners]
  end

  subgraph INPROGRESS [In Progress]
    direction TB
    B1[Clean addresses]
    B2[Draft policy]
  end

  subgraph REVIEW [In Review]
    direction TB
    C1[Metadata validation]
  end

  subgraph DONE [Done]
    direction TB
    D1[Steward assigned]
    D2[First dashboard live]
  end

  %% Position columns left to right with invisible spacing
  BACKLOG --> INPROGRESS
  INPROGRESS --> REVIEW
  REVIEW --> DONE

  %% Remove connectors by styling them invisible (optional)
  linkStyle 0 stroke:transparent
  linkStyle 1 stroke:transparent
  linkStyle 2 stroke:transparent

  %% Style each column
  style BACKLOG fill:#eee,stroke:#aaa
  style INPROGRESS fill:#ccf,stroke:#aaa
  style REVIEW fill:#ffc,stroke:#aaa
  style DONE fill:#cfc,stroke:#aaa
```

## Sequence Diagram

```mermaid
sequenceDiagram
  participant Alice
  participant Bob
  Alice->>Bob: Hello Bob, how are you?
  Bob-->>Alice: I'm good, thanks!
```

## Gantt Chart

```mermaid
gantt
  title Project Timeline
  dateFormat  YYYY-MM-DD
  section Planning
  Research       :a1, 2025-05-01, 7d
  Design         :a2, after a1, 5d
  section Execution
  Build          :b1, 2025-05-10, 10d
  Test           :b2, after b1, 5d
```

## Class Diagram

```mermaid
classDiagram
  Animal <|-- Duck
  Animal <|-- Fish
  Animal <|-- Zebra
  class Animal {
    +int age
    +String gender
    +isMammal()
  }
```

## State Diagram

```mermaid
stateDiagram-v2
  [*] --> Idle
  Idle --> Loading
  Loading --> Success
  Loading --> Error
  Error --> Idle
```

## Entity Relationship Diagram (ERD)

```mermaid
erDiagram
  CUSTOMER ||--o{ ORDER : places
  ORDER ||--|{ LINE_ITEM : contains
  CUSTOMER {
    string name
    string email
  }
```

## Pie Chart

```mermaid
pie
  title Water Usage
  "Residential" : 45
  "Commercial" : 25
  "Industrial" : 15
  "Agricultural" : 15
```

## Git Graph

```mermaid
gitGraph
  commit
  commit
  branch develop
  checkout develop
  commit
  commit
  checkout main
  merge develop
```