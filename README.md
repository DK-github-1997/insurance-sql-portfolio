# Insurance Domain SQL & PL/SQL Portfolio

This repository is a sample project demonstrating **SQL Development** and **Application Support** skills in the **Insurance domain**, specifically **Agriculture Insurance (Crop Insurance)** and **Motor Insurance**.

It is built as a learning + portfolio project to showcase database design, query writing, PL/SQL programming, and the kind of day-to-day production support tasks performed by an Insurance domain SQL Developer / Application Support Engineer.

> **Note:** All data in this repository is dummy/sample data created for demonstration purposes only. No real customer, policy, or claim data is used.

---

## Domain Background

**Agriculture Insurance** covers risks to farmers' crops from natural calamities such as drought, flood, and pest attacks (e.g. schemes similar to PMFBY/WBCIS in India).

**Motor Insurance** covers risks related to vehicles — own damage, third-party liability, theft, and accidents — for private cars, two-wheelers, and commercial vehicles.

---

## Repository Structure

```
insurance-sql-portfolio/
│
├── scripts/
│   ├── ddl/
│   │   └── 01_create_tables.sql        # Table structures (schema)
│   ├── dml/
│   │   └── 02_insert_sample_data.sql   # Sample/dummy data
│   ├── reports/
│   │   └── 03_business_queries.sql     # Real-world reporting queries
│   └── plsql/
│       └── 04_plsql_programs.sql       # Procedures, functions, triggers, packages
│
├── docs/
│   ├── ER_Diagram_Description.md       # Table relationships explained
│   ├── Application_Support_Runbook.md  # Common production issues & fixes
│   ├── Skills_and_Glossary.md          # Skills demonstrated + insurance terms
│   └── Git_GitHub_Beginner_Guide.md    # Step-by-step Git/GitHub setup
│
├── sample_data/                        # (optional) CSV exports if needed
│
└── README.md
```

---

## Database Schema Overview

| Table                  | Purpose                                          |
|-------------------------|--------------------------------------------------|
| `customer_master`        | Policyholder / customer details                  |
| `policy_master`            | Core policy details (common to Motor & Agri)    |
| `motor_vehicle_details`      | Vehicle-specific details for Motor policies    |
| `agri_crop_details`            | Crop/farm-specific details for Agri policies |
| `claims_master`                  | Claims raised against policies             |
| `premium_payment`                  | Premium payment history                  |
| `agent_master`                       | Insurance agents/intermediaries        |

See `docs/ER_Diagram_Description.md` for how these tables relate to each other.

---

## How to Use This Repository

1. Clone or download this repository (see `docs/Git_GitHub_Beginner_Guide.md` if you're new to Git).
2. Run scripts in this order in your SQL client (Oracle SQL Developer / SQL*Plus / DBeaver):
   - `scripts/ddl/01_create_tables.sql`
   - `scripts/dml/02_insert_sample_data.sql`
   - `scripts/plsql/04_plsql_programs.sql`
   - `scripts/reports/03_business_queries.sql`
3. Explore the queries and PL/SQL code, modify them, and practice writing your own variations.

> Scripts are written for **Oracle SQL**. Notes for adapting to MySQL/PostgreSQL/SQL Server are included as comments at the bottom of the DDL file.

---

## Skills Demonstrated

- SQL: DDL, DML, Joins, Aggregations, Subqueries, Window-style reporting queries
- PL/SQL: Procedures, Functions, Triggers, Cursors, Packages, Exception Handling
- Database design: Primary keys, foreign keys, normalization basics
- Application Support: Data quality checks, production issue troubleshooting queries, RCA-style runbook
- Domain knowledge: Insurance lifecycle (Policy issuance → Premium → Claim → Settlement) for Motor & Agriculture LOBs
- Version Control: Git & GitHub basics (this repository itself is the proof of that skill)

Full list with explanations in `docs/Skills_and_Glossary.md`.

---

## About Me

> Add 2-3 lines here about your background, e.g.:
> "SQL Developer / Application Support Engineer with experience in the Insurance domain, working on Agriculture and Motor insurance applications. Skilled in writing complex SQL queries, PL/SQL procedures, and providing production support."

---

## License

This project is open for learning purposes. Feel free to fork and use it to build your own portfolio.
