# Application Support Runbook (Sample)

This document simulates a real **Application Support / Production Support runbook** for an insurance application. It lists common issues, how to investigate them with SQL, and how to resolve them. This kind of document is exactly what's maintained in real insurance IT support teams — having one in your portfolio shows you understand the support side of the job, not just development.

---

## Issue 1: Customer says premium was paid but policy still shows "ACTIVE = NO" / pending

**Possible Cause:** Payment record didn't get linked to the policy due to a batch job failure or incorrect `policy_id` mapping.

**Investigation Query:**
```sql
SELECT pp.*, p.policy_status
FROM   premium_payment pp
JOIN   policy_master p ON p.policy_id = pp.policy_id
WHERE  pp.receipt_number = '<receipt_number_given_by_customer>';
```

**Resolution Steps:**
1. Confirm payment exists in `premium_payment` table.
2. If payment exists but `policy_status` wasn't updated, check the nightly batch job logs that update policy status post-payment.
3. If the batch job failed, manually trigger the status-update procedure or escalate to L3/Dev team.

---

## Issue 2: Duplicate vehicle registration number across two policies

**Possible Cause:** Data entry error at the point of sale, or the same vehicle re-insured without closing the old policy.

**Investigation Query:**
```sql
SELECT registration_number, COUNT(*) 
FROM   motor_vehicle_details
GROUP BY registration_number
HAVING COUNT(*) > 1;
```

**Resolution Steps:**
1. Identify which policy is the active/valid one (check `policy_status` and `policy_start_date`).
2. Coordinate with the underwriting team to cancel/correct the duplicate entry.
3. Log it as a data quality ticket for root cause if it recurs frequently.

---

## Issue 3: Claim stuck in "UNDER_REVIEW" beyond SLA (e.g. > 15 days)

**Possible Cause:** Surveyor report pending, or claim assigned but not picked up.

**Investigation Query:**
```sql
SELECT claim_number, policy_id, surveyor_id, intimation_date,
       SYSDATE - intimation_date AS days_pending
FROM   claims_master
WHERE  claim_status = 'UNDER_REVIEW'
AND    SYSDATE - intimation_date > 15;
```

**Resolution Steps:**
1. Share the list with the Claims Operations team for follow-up with surveyors.
2. If a specific surveyor has multiple SLA breaches, flag for performance review.

---

## Issue 4: Crop insurance — premium subsidy not reflecting (Agri specific)

**Possible Cause:** Government subsidy portion of premium recorded separately and not reconciled with `premium_payment`.

**Investigation Query:**
```sql
SELECT p.policy_number, p.premium_amount, SUM(pp.amount_paid) AS total_received
FROM   policy_master p
LEFT JOIN premium_payment pp ON pp.policy_id = p.policy_id
WHERE  p.line_of_business = 'AGRI'
GROUP BY p.policy_number, p.premium_amount
HAVING SUM(pp.amount_paid) IS NULL OR SUM(pp.amount_paid) < p.premium_amount;
```

**Resolution Steps:**
1. Check if the shortfall matches the expected government subsidy amount.
2. Confirm with the finance/subsidy reconciliation team whether the subsidy batch has run for that period.
3. Do not mark the policy as "premium pending" if subsidy reconciliation is simply delayed — escalate instead of auto-lapsing the policy.

---

## General Troubleshooting Checklist (used for almost any ticket)

1. Reproduce the issue by querying the relevant table(s) directly (read-only).
2. Check `created_date` / timestamp columns to see if it's a timing/batch-job issue.
3. Check for NULLs in foreign key columns (`policy_id`, `customer_id`) — common cause of "missing record" complaints.
4. Cross-verify counts: e.g., does `COUNT(*)` from the application UI match `COUNT(*)` from the underlying query?
5. Never run UPDATE/DELETE directly in production without going through a change request — always test in UAT/staging first, and only run **SELECT** queries when triaging an issue.
6. Document the root cause and fix in the ticket before closing.
