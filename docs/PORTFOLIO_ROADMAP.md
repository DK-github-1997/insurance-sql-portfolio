# Oracle SQL / PL/SQL Portfolio Roadmap

## Positioning
Production-oriented Oracle SQL and PL/SQL development for insurance and enterprise data applications. All examples use synthetic data and clearly documented schema assumptions.

## Repository boundaries
- This repository owns insurance-domain database design, PL/SQL business processing, reporting SQL, and developer-facing documentation.
- `data-validation-framework` owns reusable ETL/data-quality/reconciliation checks. Link to it rather than copying those scripts.
- `Oracle-Retail-Sales-Analytics` remains the home for retail analytics, window functions, and query-tuning examples.

## Project roadmap
| Priority | Project | Evidence to publish |
|---|---|---|
| 1 | Claim settlement validation and controlled processing | Package, test cases, exception handling, transaction boundary |
| 2 | Policy premium allocation and reconciliation | SQL/PLSQL, control totals, edge-case tests |
| 3 | Bulk claim status processing | BULK COLLECT/FORALL, SAVE EXCEPTIONS, performance comparison |
| 4 | Policy/claim reporting workload tuning | Explain plans, indexes, before/after measurements |
| 5 | Production-safe deployment and rollback | Pre/post checks, deployment checklist, rollback notes |

## Standard project structure
```
projects/<project-name>/
  README.md
  sql/
  plsql/
  tests/
  sample_data/
  docs/
```

## Definition of done
- Business problem, assumptions, and data dictionary are documented.
- Scripts can be run in a stated order on a supported Oracle version.
- Positive, negative, duplicate, NULL, and boundary cases are covered.
- Expected results are included; actual runtime evidence is labelled separately.
- No production credentials, customer data, or employer-confidential information is committed.

## Validation status
A GitHub commit proves that source files were committed; it does not prove execution. Record Oracle version, test date, test cases, and outcomes when runtime validation is performed.
