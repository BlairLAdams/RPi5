# NIST Risk Management Framework (RMF) Guide

The **NIST Risk Management Framework (RMF)** is a flexible, repeatable process that helps organizations manage cybersecurity and privacy risks for information systems. Defined in [NIST SP 800-37 Rev. 2](https://csrc.nist.gov/publications/detail/sp/800-37/rev-2/final), the RMF integrates with enterprise governance and promotes continuous monitoring and authorization.

---

## 📘 Purpose

RMF enables organizations to:

- Make informed, risk-based decisions
- Integrate cybersecurity into the system development life cycle (SDLC)
- Demonstrate compliance with FISMA, FedRAMP, and other NIST 800-series standards
- Align operational risks with organizational objectives

---

## 🔁 RMF Steps

| Step | Name       | Description |
|------|------------|-------------|
| 0    | **Prepare**    | Define roles, context, resources, and risk appetite |
| 1    | **Categorize** | Assign impact levels to system functions and data using [FIPS 199](https://csrc.nist.gov/publications/detail/fips/199/final) |
| 2    | **Select**     | Choose baseline controls from [NIST SP 800-53](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) |
| 3    | **Implement**  | Deploy and document selected security controls |
| 4    | **Assess**     | Evaluate controls using [NIST SP 800-53A](https://csrc.nist.gov/publications/detail/sp/800-53a/rev-5/final) |
| 5    | **Authorize**  | Make a risk-based decision and issue ATO, IATO, or denial |
| 6    | **Monitor**    | Continuously assess security posture and control effectiveness |

---

## 🧭 Step-by-Step Details

### Step 0: Prepare
- Define RMF participants (AO, ISSO, system owner)
- Identify common controls and shared services
- Understand business context and organizational risk tolerance
- Link cybersecurity to mission/business objectives

### Step 1: Categorize
- Follow [FIPS 199](https://csrc.nist.gov/publications/detail/fips/199/final) and [NIST SP 800-60](https://csrc.nist.gov/publications/detail/sp/800-60/vol-1-rev-1/final)
- Evaluate impact on Confidentiality, Integrity, Availability (CIA)
- Output: System Categorization Document

### Step 2: Select
- Use [NIST SP 800-53 Rev. 5](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) control baselines
- Tailor baseline (Low/Moderate/High) using overlays
- Output: System Security Plan (SSP)

### Step 3: Implement
- Configure controls and document implementation
- Use automated configuration management (e.g., Ansible, Terraform)
- Output: Updated SSP with implementation details

### Step 4: Assess
- Use [NIST SP 800-53A Rev. 5](https://csrc.nist.gov/publications/detail/sp/800-53a/rev-5/final)
- Evaluate if controls are implemented correctly and producing expected results
- Output: Security Assessment Report (SAR)

### Step 5: Authorize
- Review SSP, SAR, and POA&M
- Authorizing Official (AO) accepts, rejects, or delays system use
- Decision types: ATO (Authorize to Operate), IATO (Interim), or Denial

### Step 6: Monitor
- Establish continuous monitoring strategy (ConMon)
- Use log management, SIEM, vulnerability scanning, and config monitoring
- Keep SSP, POA&M, and SAR updated

---

## 👥 Core Roles

| Role                      | Responsibility |
|---------------------------|----------------|
| Authorizing Official (AO) | Makes the final risk-based decision to authorize |
| System Owner              | Manages system and ensures security integration |
| ISSO                      | Day-to-day security oversight of the system       |
| Security Control Assessor | Performs control evaluations (internal or third party) |
| Risk Executive Function   | Aligns system risks with organizational priorities |

---

## 📚 Control Sources & Guidance

| Document                                                | Role in RMF |
|----------------------------------------------------------|-------------|
| [NIST SP 800-37 Rev. 2](https://csrc.nist.gov/publications/detail/sp/800-37/rev-2/final) | Defines the RMF process |
| [NIST SP 800-53 Rev. 5](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) | Security and privacy control catalog |
| [NIST SP 800-53A](https://csrc.nist.gov/publications/detail/sp/800-53a/rev-5/final)     | Assessment procedures for controls |
| [FIPS 199](https://csrc.nist.gov/publications/detail/fips/199/final)                    | Categorization of system impact levels |
| [FIPS 200](https://csrc.nist.gov/publications/detail/fips/200/final)                    | Minimum security requirements |
| [NIST SP 800-60 Vol. 1](https://csrc.nist.gov/publications/detail/sp/800-60/vol-1-rev-1/final) | Mapping of data types to impact categories |

---

## 🏭 RMF in Practice

| Use Case         | Notes |
|------------------|-------|
| **FedRAMP**       | RMF is adapted with specific baselines and assessment templates. See [FedRAMP.gov](https://www.fedramp.gov) |
| **OT/ICS Systems**| Pair RMF with [NIST SP 800-82](https://csrc.nist.gov/publications/detail/sp/800-82/rev-2/final) for ICS/SCADA environments |
| **DevSecOps**     | Embed RMF artifacts into CI/CD pipelines with IaC and container security |

---

## 📘 RMF YAML Reference Block

```yaml
nist_rmf:
  steps:
    0: prepare
    1: categorize
    2: select
    3: implement
    4: assess
    5: authorize
    6: monitor
  artifacts:
    - system_security_plan
    - security_assessment_report
    - plan_of_action_and_milestones
    - authorization_package
  controls_catalog: nist_sp_800_53_rev_5
  assessment_guidance: nist_sp_800_53a
  roles:
    - authorizing_official
    - system_owner
    - isso
    - risk_executive_function
    - security_control_assessor
  outputs:
    - impact_levels: [low, moderate, high]
    - authorizations: [ATO, IATO, Denied]
