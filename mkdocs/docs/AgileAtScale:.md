# Agile at Scale: Program Manager Companion Guide

This guide introduces how to scale Agile principles across multi-team programs, portfolios, or departments—especially in public agencies, utilities, and infrastructure-heavy organizations. It emphasizes adaptability, transparency, and cross-functional coordination, while recognizing governance, budget, and regulatory constraints.

---

## 🚦 What Is Agile at Scale?

**Agile at Scale** applies core Agile principles—iterative delivery, continuous feedback, and adaptive planning—across many teams and stakeholders, including:

- Program Management Offices (PMO)
- Capital Planning
- IT and OT Teams
- Regulatory & Compliance Groups
- Operations & Maintenance (O&M)
- Field Engineering

> **Goal:** Harmonize delivery across silos by focusing on shared outcomes, transparency, and fast feedback loops.

---

## 🧱 Core Principles

| Principle | Description |
|----------|-------------|
| **Customer-Centered Value** | Prioritize outcomes that deliver measurable value to constituents, users, or regulators. |
| **Decentralized Decision-Making** | Empower teams to own delivery within a shared strategic framework. |
| **Incremental Delivery** | Release usable components regularly—dashboards, forms, integrations, etc.—not just at project close. |
| **Transparency** | Make work, risks, and dependencies visible to all teams and stakeholders. |
| **Continuous Feedback** | Incorporate lessons and stakeholder feedback into each cycle to evolve both solutions and priorities. |

---

## 🗺️ Scaled Agile Planning Layers

Agile at scale is built around aligning multiple planning layers:

### 1. **Strategic Themes (Annual / Multi-Year)**
Broad agency goals (e.g., water equity, infrastructure modernization, compliance readiness)

### 2. **Program Increments (Quarterly)**
Cross-team, outcome-driven goals across multiple initiatives or systems

### 3. **Team Sprints (2–4 Weeks)**
Short delivery cycles focused on working software, integrations, and feedback loops

---

## 🔄 Sample Quarterly Agile Cycle

| Week | Activity |
|------|----------|
| 1 | Quarterly Planning (define goals, OKRs, team alignments) |
| 2–10 | Sprints (2–4 weeks each) with demos and stakeholder feedback |
| 11 | System Integration / User Acceptance Testing (UAT) |
| 12 | Retrospective and Replanning for next cycle |

---

## 🛠️ Agile Roles in a Public Sector or Utility Setting

| Role | Adaptation |
|------|------------|
| **Product Owner** | May be a business analyst, project manager, or subject matter expert focused on stakeholder needs |
| **Scrum Master / Delivery Lead** | Facilitates sprints, removes blockers, ensures Agile principles are followed |
| **Program Manager** | Aligns multiple teams, manages dependencies, integrates strategic planning (OKRs, roadmaps) |
| **Team Members** | May include GIS analysts, SCADA integrators, asset engineers, data modelers, etc. |

---

## 🧰 Recommended Tools by Layer

| Planning Layer | Tools |
|----------------|-------|
| Strategic & Program | Azure DevOps, Jira Portfolio, MS Planner, Trello |
| Backlog Management | Jira, Azure Boards, Trello |
| Feedback & Retrospectives | Miro, Mural, Teams Whiteboard |
| Visualization & Reporting | Power BI, Confluence, SharePoint |

---

## 🧪 Agile vs Traditional Waterfall Comparison

| Feature | Waterfall | Agile at Scale |
|---------|-----------|----------------|
| Delivery | One-time, big bang | Continuous, incremental |
| Change | Difficult and late-stage | Embraced and iterative |
| Planning | Fixed upfront | Adaptive and ongoing |
| Risk | Realized late | Identified and mitigated early |
| Feedback | Post-launch | Every sprint or increment |

---

## 📋 Agile at Scale Readiness Checklist

- [ ] Do we have cross-functional representation in planning?
- [ ] Are teams empowered to adjust scope in real time?
- [ ] Are stakeholder feedback loops built into every sprint or release?
- [ ] Are workstreams visible to leadership and other teams?
- [ ] Are OKRs or KPIs used to guide priority decisions?

---

## 🧩 Agile Building Blocks (Glossary)

- **Epic**: A large body of work that can be broken into smaller stories or tasks
- **Feature**: A service or component delivered to users
- **Story**: A user-focused unit of work (e.g., "As a planner, I want to visualize pipe condition...")
- **Backlog**: The prioritized list of upcoming stories or features
- **Sprint**: A short, time-boxed development cycle (usually 2–4 weeks)
- **Demo / Review**: Stakeholder presentation of sprint results
- **Retrospective**: Team reflection on process, blockers, and improvements

---

## 📌 Pro Tips for Utilities & Government

- Start small: pilot Agile with one cross-functional team before scaling
- Combine Agile delivery with OKRs to maintain long-term alignment
- Use Agile boards to expose dependencies and competing priorities
- Don’t skip retrospectives—they’re vital for cultural change
- Adapt rituals (e.g., stand-ups, sprints) to field staff or shift schedules

---

## 📚 Additional Resources

- [Scaled Agile Framework (SAFe)](https://scaledagileframework.com)
- [Agile Government Handbook (18F)](https://18f.gsa.gov/2016/08/15/the-agile-gov-handbook/)
- [Azure DevOps Scaled Agile Practices](https://learn.microsoft.com/en-us/azure/devops/boards/plans/)
- [Scrum Guide](https://scrumguides.org)

---

## ✅ Sample Agile Sprint Template (for Teams)

```markdown
### Sprint Goal
Improve water service map accuracy in customer portal

### Stories / Tasks
- Integrate GIS parcel layer into web app backend (GIS Dev)
- QA cross-street labels with field-verified data (QA/SCADA)
- Stakeholder review of new zoom-to-address function (UX/PM)

### Definition of Done
- All tests pass
- Stakeholder review completed
- Deployed to staging
