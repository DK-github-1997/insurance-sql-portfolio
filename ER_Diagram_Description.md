# Entity Relationship (ER) Overview

This document explains how the tables in this database relate to each other, in plain language — useful for explaining your data model in interviews.

## Relationship Summary

```
customer_master  (1) ----- (M) policy_master
agent_master     (1) ----- (M) policy_master
policy_master    (1) ----- (1) motor_vehicle_details   [only if line_of_business = 'MOTOR']
policy_master    (1) ----- (1) agri_crop_details        [only if line_of_business = 'AGRI']
policy_master    (1) ----- (M) claims_master
policy_master    (1) ----- (M) premium_payment
```

## Explanation

- **One customer can hold many policies.** A single farmer or vehicle owner (`customer_master`) may have one motor policy and one agriculture policy, or multiple policies of the same type over the years (renewals).

- **One agent can sell many policies.** `agent_master` links to `policy_master` to track which intermediary sold/serviced a policy — useful for commission and performance reports.

- **Policy is the central table.** Every Motor or Agri-specific record links back to `policy_master` through `policy_id`. This is a common "supertype/subtype" design: common fields (start date, end date, premium, sum insured) sit in `policy_master`, while LOB-specific fields sit in their own child table (`motor_vehicle_details` or `agri_crop_details`).

- **One policy can have many claims.** A motor policy could have multiple accident claims over its term; an agri policy could have multiple crop-damage claims across different perils (flood, drought) in the same season.

- **One policy can have many premium payments.** This supports installment-based premium payment plans, not just single lump-sum payment.

## Why this design?

This mirrors how real insurance core systems (e.g. Guidewire, Insurance Suite platforms, custom legacy systems) typically separate **policy data** from **product-specific data**, so that adding a new Line of Business (say, Health Insurance) later just means adding one new child table — without altering the core policy/claims/payment structure.
