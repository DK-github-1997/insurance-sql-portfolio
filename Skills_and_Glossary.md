# Skills Demonstrated & Insurance Glossary

## Technical Skills Shown in This Repository

| Skill Area              | Where Demonstrated                                              |
|--------------------------|-------------------------------------------------------------------|
| SQL DDL                    | `scripts/ddl/01_create_tables.sql` — table creation, constraints, FKs |
| SQL DML                      | `scripts/dml/02_insert_sample_data.sql` — inserts, sample data setup |
| SQL Querying / Reporting        | `scripts/reports/03_business_queries.sql` — joins, GROUP BY, HAVING, CASE, subqueries |
| PL/SQL Procedures                  | `scripts/plsql/04_plsql_programs.sql` — `register_claim` |
| PL/SQL Functions                     | `get_ncb_discount` function |
| PL/SQL Triggers                        | `trg_check_policy_status` |
| PL/SQL Cursors                           | Explicit cursor `c_pending_kyc` |
| PL/SQL Packages                            | `claims_pkg` (approve_claim, reject_claim) |
| Exception Handling                           | `RAISE_APPLICATION_ERROR`, `EXCEPTION WHEN OTHERS` |
| Application Support / Production Support       | `docs/Application_Support_Runbook.md` |
| Data Modeling / ER Design                        | `docs/ER_Diagram_Description.md` |
| Git & GitHub (Version Control)                     | This repository itself; see `docs/Git_GitHub_Beginner_Guide.md` |

---

## Insurance Domain Glossary (Quick Reference)

| Term            | Meaning                                                                 |
|------------------|--------------------------------------------------------------------------|
| **LOB**            | Line of Business — e.g., Motor, Agriculture, Health, Life               |
| **Policy**            | A contract between insurer and policyholder covering specific risks   |
| **Premium**             | Amount paid by the policyholder to keep the policy active           |
| **Sum Insured**           | Maximum amount the insurer will pay in case of a claim             |
| **IDV** (Motor)             | Insured Declared Value — current market value of the vehicle    |
| **NCB** (Motor)                | No Claim Bonus — discount on premium for claim-free years      |
| **Claim**                         | A formal request by the policyholder for compensation         |
| **Surveyor**                         | Independent assessor who evaluates the loss/damage for a claim |
| **Settlement Ratio**                   | % of claims approved/settled out of total claims received    |
| **TAT**                                  | Turn Around Time — time taken to process a claim or request |
| **KYC**                                    | Know Your Customer — identity verification process         |
| **Kharif / Rabi** (Agri)                     | Crop seasons in India — Kharif (monsoon, June-Oct), Rabi (winter, Oct-Mar) |
| **WBCIS / PMFBY** (Agri)                       | Weather Based Crop Insurance Scheme / Pradhan Mantri Fasal Bima Yojana — Indian govt crop insurance schemes |
| **Underwriting**                                 | Process of evaluating risk before issuing a policy        |
| **Lapsed Policy**                                  | A policy that's inactive due to non-payment of premium    |
| **Third-Party (TP) Cover** (Motor)                   | Insurance covering damage/injury to a third party, not the insured's own vehicle |
| **Own Damage (OD) Cover** (Motor)                       | Covers damage to the policyholder's own vehicle          |

---

## How to Talk About This Project in an Interview

A simple way to describe this repository:

> "I built a sample database and SQL/PL/SQL portfolio simulating an insurance application covering Motor and Agriculture insurance lines. It includes the core schema (policy, customer, claims, premium tables), realistic business reporting queries like renewal lists and claim settlement ratios, and PL/SQL procedures for claim registration and approval workflows. I also documented an application support runbook to show how I'd troubleshoot real production issues using SQL."
