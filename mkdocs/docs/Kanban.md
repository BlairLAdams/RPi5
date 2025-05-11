# Agile Kanban Overview

This page introduces **Agile Kanban** — a visual workflow management method used to organize, prioritize, and deliver work efficiently. Kanban is widely applied in data teams, IT operations, DevOps, and governance programs where flexibility and flow are critical.

---

## Definition

**Kanban** is a method for managing and improving workflows using a visual board and incremental process evolution. Originating in lean manufacturing, it has been adapted to software development, analytics, and enterprise planning.

---

## Core Principles

1. **Visualize Work**  
   Make tasks and workflows visible through columns and cards.

2. **Limit Work in Progress (WIP)**  
   Restrict the number of items in each stage to avoid overload.

3. **Manage Flow**  
   Measure cycle time, identify bottlenecks, and improve throughput.

4. **Make Policies Explicit**  
   Define what “done” means and document process agreements.

5. **Implement Feedback Loops**  
   Use daily standups, retrospectives, and metrics for continuous learning.

6. **Improve Collaboratively, Evolve Experimentally**  
   Encourage team-led improvements and evolutionary change.

---

## Common Terminology

| Term               | Definition |
|--------------------|------------|
| **Board**          | A visual display of workflow columns and task cards |
| **Card**           | A unit of work or task (e.g., user story, data issue, enhancement) |
| **Column**         | A stage in the workflow (e.g., Backlog → In Progress → Done) |
| **WIP Limit**      | The maximum number of cards allowed in a column at once |
| **Cycle Time**     | The time taken to complete a card from start to finish |
| **Throughput**     | The number of work items completed in a given period |
| **Swimlane**       | Horizontal grouping of cards by type, project, or priority |
| **Blocked**        | A card that cannot proceed due to a dependency or issue |

---

## Use Cases in Utilities and IT

- Prioritizing data quality or stewardship tasks  
- Managing agile infrastructure and DevOps work  
- Coordinating SCADA or CMMS enhancement backlogs  
- Supporting regulatory and audit deliverables  
- Tracking metadata documentation and integration requests

---

## Sample Kanban Board

```
Backlog       | In Progress     | In Review       | Done
------------------------------------------------------------
Catalog SCADA | Clean address   | Steward review  | Field forms digitized
Develop ETL   | Create glossary | Validate schema | Owner assignment complete
```

---

## Benefits

- Lightweight and easy to adopt  
- Encourages team self-organization  
- Reduces hidden work and multitasking  
- Provides visibility to stakeholders  
- Works well with both Agile and non-Agile teams  

---

## Comparisons

| Feature            | Kanban                         | Scrum                        |
|--------------------|--------------------------------|------------------------------|
| Work Cadence       | Continuous flow                | Iteration-based (sprints)    |
| Roles Required     | None required (flexible)       | Scrum Master, Product Owner  |
| Best For           | Ops, analytics, shared services| Product teams, time-boxed goals |
| Board Type         | Column-based, flexible         | Sprint board with backlog    |
| Planning Approach  | Just-in-time (pull-based)      | Pre-planned sprints          |

---

## Metrics You Can Track

- **WIP** (Work in Progress)  
- **Cycle Time**  
- **Lead Time**  
- **Throughput**  
- **Blocked Rate**  
- **Aging Work Items**

---

## References and Further Reading

- *Kanban: Successful Evolutionary Change for Your Technology Business* – David J. Anderson  
  ISBN: 9780984521401

- *Essential Kanban Condensed* – David J. Anderson & Andy Carmichael  
  ISBN: 9780984521425  
  Free PDF: https://leankanban.com/guide/

- *Making Work Visible* – Dominica DeGrandis  
  ISBN: 9781788603846  
  Focuses on hidden work, context switching, and WIP

- Kanban University  
  https://www.kanban.university/

- Atlassian Kanban Guide  
  https://www.atlassian.com/agile/kanban

---

## Related Topics

- [Agile Work Management](../agile/index.md)  
- [Data Governance OKRs](../01_governance/index.md)  
- [Metrics and KPIs](../performance-metrics/index.md)