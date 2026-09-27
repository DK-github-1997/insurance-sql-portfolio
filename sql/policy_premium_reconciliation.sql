-- Policy premium reconciliation
-- Portfolio example: validate source policy premiums against target totals.

WITH source_premium AS (
    SELECT policy_date,
           SUM(premium_amount) AS source_premium
    FROM source_policy_transactions
    GROUP BY policy_date
),
target_premium AS (
    SELECT policy_date,
           SUM(premium_amount) AS target_premium
    FROM target_policy_transactions
    GROUP BY policy_date
)
SELECT COALESCE(s.policy_date, t.policy_date) AS policy_date,
       NVL(s.source_premium, 0) AS source_premium,
       NVL(t.target_premium, 0) AS target_premium,
       ROUND(NVL(t.target_premium, 0) - NVL(s.source_premium, 0), 2) AS premium_difference,
       CASE
           WHEN ABS(NVL(t.target_premium, 0) - NVL(s.source_premium, 0)) < 0.01
               THEN 'PASS'
           ELSE 'FAIL'
       END AS reconciliation_status
FROM source_premium s
FULL OUTER JOIN target_premium t
    ON s.policy_date = t.policy_date
ORDER BY policy_date;