/*
   Claim payment reconciliation sample
   Purpose: identify claims where recorded payments do not match the
            approved claim amount or where no payment has been recorded.
   Dataset: dummy portfolio data only.
*/

SELECT
    c.claim_id,
    c.policy_id,
    c.claim_status,
    c.claim_amount,
    NVL(SUM(p.payment_amount), 0) AS paid_amount,
    c.claim_amount - NVL(SUM(p.payment_amount), 0) AS outstanding_amount,
    CASE
        WHEN NVL(SUM(p.payment_amount), 0) = 0 THEN 'NO_PAYMENT'
        WHEN NVL(SUM(p.payment_amount), 0) < c.claim_amount THEN 'PARTIAL_PAYMENT'
        WHEN NVL(SUM(p.payment_amount), 0) = c.claim_amount THEN 'FULLY_RECONCILED'
        WHEN NVL(SUM(p.payment_amount), 0) > c.claim_amount THEN 'OVER_PAYMENT'
    END AS reconciliation_status
FROM claims_master c
LEFT JOIN premium_payment p
    ON p.policy_id = c.policy_id
GROUP BY
    c.claim_id,
    c.policy_id,
    c.claim_status,
    c.claim_amount
HAVING NVL(SUM(p.payment_amount), 0) <> c.claim_amount
ORDER BY c.claim_id;
