# Scrumban Agile Framework with OKR + Sprint Tracker Template

A practical hybrid approach combining Scrum structure and Kanban flow—tailored for delivery teams in infrastructure, utilities, IT, GIS, and digital modernization.

## 🧭 When to Use Scrumban

Use Scrumban if:
- Your team handles both feature development and operational support.
- You want iterative planning without committing to strict sprint cadences.
- You need visibility and flow management for ongoing or reactive work.
- You're modernizing from traditional waterfall processes.

## 🔧 Key Characteristics

| Element | Description |
|---------|-------------|
| Planning Cadence | Optional; use weekly/biweekly syncs or just-in-time planning |
| Work-in-Progress Limits | Limit active work per status column to maintain flow |
| Pull-Based System | Team members pull work based on capacity |
| Backlog Grooming | Continuous prioritization instead of big batch sprint planning |
| Standups | Short daily or twice-weekly check-ins |
| Retrospectives | Regular (every 2–4 weeks) process reflection |
| Tagging/Swimlanes | Label work by theme: OKRs, Support, Compliance, Tech Debt |

## 🎨 Example Scrumban Board

[ Backlog ] → [ Ready for Development ] → [ In Progress ] (WIP: 3) → [ In Review ] → [ Blocked ] → [ Done ]

Use swimlanes or tags such as #OKR, #Ops, #Fieldwork, #GIS, #Support.

## 📝 Example Task Card

### Task: Integrate turbidity sensors into SCADA dashboard
- Tags: Feature, SCADA, OKR-Q2
- Status: In Progress
- WIP Limit: 3 items
- Related Objective: Enhance visibility into water quality conditions

## 📋 OKR + Sprint Tracker Template

### Objective  
Improve transparency and decision support with real-time operations dashboards

### Key Results
- [ ] Deploy MVP dashboard with live data by May 15  
- [ ] Complete stakeholder validation with 90% satisfaction score  
- [ ] Train 20 users on filtering and reporting capabilities  
- [ ] Reduce average report generation time from 48h to <8h  

### Sprint Tracker — Q2 Sprint 2 (May 1 – May 15)

#### Sprint Goal  
Deliver first end-to-end functional version of dashboard with water quality indicators.

#### In Progress
- [ ] Develop PostgreSQL view for SCADA stream ingest  
- [ ] Build dashboard layout in Power BI with drilldowns  
- [ ] Configure role-based access for viewer/editor modes  

#### Completed
- [x] Wireframe and data mapping validated  
- [x] Data refresh frequency set to hourly  

#### Blockers
- Pending firewall exception for SCADA-to-staging DB route  
- Clarification needed on unit conversion rules from WIMS  

### Velocity Notes
- Story points completed: 18 (target: 20)  
- Key Result progress: 60% overall  
- Team notes: Good velocity, need clearer acceptance criteria for KR2  

### Retrospective Notes
- ✅ What went well: Early testing of live refresh improved UI decisions  
- ⚠️ What to improve: Better coordination on IT security review timelines  
- 📌 Action items: Create SCADA access checklist for future teams  

## 🧠 Tips for Adopting Scrumban

- Start with your current board and add WIP limits gradually.  
- Encourage tagging OKR-aligned work to keep strategic priorities visible.  
- Make retrospectives short, regular, and focused on process—not blame.  
- Use dashboards (Power BI, Grafana, Confluence) to make progress visible.  
- Don’t wait for perfection—improve one small thing every cycle.

## 📚 References

- https://www.atlassian.com/agile/scrumban  
- https://scrumguides.org  
- https://kanbanguides.org  
- https://www.whatmatters.com  
- https://learn.microsoft.com/en-us/azure/devops/boards/plans/  