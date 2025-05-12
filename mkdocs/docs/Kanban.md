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

## Common Agile Terminology

| Term Agile                  | Definition                                                                                    |
| ---------------------- | --------------------------------------------------------------------------------------------- |
| **Agile**              | A mindset and approach emphasizing adaptability and value delivery                            |
| **Scrum**              | A framework based on time-boxed iterations (sprints), with defined roles and ceremonies       |
| **Kanban**             | A pull-based system for managing and visualizing workflow                                     |
| **Sprint**             | A fixed-length iteration (commonly 2–4 weeks) where a team delivers a defined set of work     |
| **User Story**         | A structured expression of user needs (e.g., “As a \[user], I want \[goal] so that \[value]”) |
| **Backlog**            | A prioritized list of tasks or features to be completed                                       |
| **Epic**               | A large body of work that can be broken into smaller stories                                  |
| **Task**               | A specific action or unit of work, often linked to a user story                               |
| **Card**               | A visual representation of a task or story on a board                                         |
| **Board**              | A visual layout of work (columns, swimlanes, cards)                                           |
| **Column**             | A workflow state (e.g., To Do, In Progress, Done)                                             |
| **WIP Limit**          | Maximum number of items allowed in a column to prevent overload                               |
| **Cycle Time**         | Time taken for a task to move from start to completion                                        |
| **Lead Time**          | Time from task request to delivery                                                            |
| **Velocity**           | The number of story points or tasks completed per sprint (Scrum)                              |
| **Burndown Chart**     | A graph tracking remaining work over time during a sprint                                     |
| **Definition of Done** | Team agreement on what qualifies work as complete                                             |
| **Blocked**            | A task that cannot proceed due to a dependency or issue                                       |

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