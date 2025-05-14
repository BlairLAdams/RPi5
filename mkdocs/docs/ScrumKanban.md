# Agile Scrum and Kanban: Companion Guide for Delivery Teams

This guide introduces Scrum and Kanban, two Agile delivery frameworks used to manage iterative work, increase visibility, and respond to change. Designed for engineering, IT, GIS, field services, and utility project teams, these methods support structured execution and continuous improvement.

---

## Agile Scrum vs Kanban at a Glance

| Feature               | Scrum                           | Kanban                             |
|-----------------------|----------------------------------|-------------------------------------|
| Delivery rhythm       | Fixed sprints (2–4 weeks)       | Continuous flow                    |
| Roles                 | Scrum Master, Product Owner, Team | Optional (can use facilitator)   |
| Planning              | Sprint planning per cycle        | Pull-based with limits             |
| Commitments           | Sprint goal and backlog          | WIP limits, flow optimization      |
| Ideal for             | Feature delivery, cross-functional teams | Reactive ops, BAU, support     |
| Meetings              | Daily standups, reviews, retrospectives | Optional but recommended      |
| Tracking              | Velocity and burndown charts     | Lead time and cumulative flow      |

---

## Scrum: The Iterative Delivery Framework

### Scrum Roles

- **Product Owner**: Prioritizes the backlog and represents stakeholder needs
- **Scrum Master**: Facilitates the process, removes blockers, and supports the team
- **Team Members**: Deliver potentially shippable increments of work each sprint

### Scrum Events

| Event | Description |
|-------|-------------|
| Sprint Planning | Define the sprint goal and select backlog items |
| Daily Standup | Short check-in to share progress, blockers, and plans |
| Sprint Review | Demonstrate completed work to stakeholders |
| Sprint Retrospective | Team reflects on process and suggests improvements |

### Scrum Artifacts

- **Product Backlog**: Ordered list of all features, tasks, bugs, and tech debt
- **Sprint Backlog**: Items committed to during the sprint
- **Increment**: Completed, potentially shippable work output

---

## Kanban: The Visual Flow Framework

Kanban is a pull-based, visual system for managing work in progress (WIP). It helps teams improve flow efficiency and limit overcommitment.

### Core Concepts

- **Visual Board**: Tasks move through columns (e.g., To Do → Doing → Done)
- **Work-in-Progress (WIP) Limits**: Caps the number of active tasks to improve focus
- **Cycle Time**: Measures how long it takes for a task to move from start to finish
- **Pull System**: Team members “pull” new work when capacity allows

### Typical Kanban Workflow

[ Backlog ] → [ Ready ] → [ In Progress ] → [ Review ] → [ Done ]

---

## When to Use Scrum vs Kanban

| Use Scrum When...                             | Use Kanban When...                                |
|----------------------------------------------|--------------------------------------------------|
| Work can be broken into planned iterations   | Work arrives unpredictably (e.g., service requests) |
| Team delivers features or product increments | Team handles BAU, bug fixes, field tickets       |
| Stakeholders need regular demos or goals     | Team values minimizing cycle time and WIP        |
| You're building something new                | You're optimizing workflows                      |

---

## Agile Board Examples

### Scrum Example (2-week sprint)

| Status         | Tasks                            |
|----------------|----------------------------------|
| To Do          | Build lab data connector, mock KPI report |
| In Progress    | Create WIMS-to-Postgres ETL job |
| Review         | SCADA API authentication logic  |
| Done           | MVP dashboard wireframe         |

### Kanban Example (Ongoing)

| Status         | Tasks                            |
|----------------|----------------------------------|
| Backlog        | Add meter dataset to Grafana    |
| Ready          | Fix mobile form GPS sync bug    |
| In Progress    | Migrate schema to v2            |
| Review         | Update SOP documentation        |
| Done           | Archive 2023 water quality data |

---

## Metrics and Continuous Improvement

| Metric        | Scrum Use | Kanban Use | Description |
|---------------|-----------|------------|-------------|
| Velocity      | ✔️        | ❌         | Total story points completed per sprint |
| Lead Time     | ❌        | ✔️         | Time from task creation to completion   |
| Cycle Time    | ❌        | ✔️         | Time from start of work to completion   |
| Burndown      | ✔️        | ❌         | Remaining work vs time in sprint        |
| Cumulative Flow | ❌     | ✔️         | Visualizes bottlenecks across statuses  |

---

## Success Factors

- Keep boards visible and updated (e.g., Jira, DevOps, Trello)
- Review progress regularly with stakeholders
- Reflect and improve—don’t skip retrospectives or process reviews
- Limit WIP to reduce multitasking and increase throughput
- Focus on outcomes, not just velocity or story count

---

## Further Reading

- https://scrumguides.org
- https://kanbanguides.org
- https://www.atlassian.com/agile/tutorials
- https://learn.microsoft.com/en-us/azure/devops/boards/plans/
- https://18f.gsa.gov

---

## Template: Lightweight Scrum Sprint Planning

```markdown
### Sprint Goal
Enable real-time alerting for water quality exceedances

### Planned Stories
- [ ] Build alert engine using threshold logic
- [ ] Connect alert engine to SCADA stream
- [ ] Notify on-call staff via Teams integration
- [ ] Write SOP for triage workflow

### Sprint Duration
March 1 – March 14

### Definition of Done
- All acceptance tests pass
- Deployed to staging
- Stakeholder approval demo complete
