/*=====================================================================
  File    : 03_business_queries.sql
  Purpose : Realistic day-to-day reporting & support queries used by
            SQL Developers / Application Support Engineers in
            Insurance (Agri + Motor LOB)
=======================================================================*/

-- ------------------------------------------------------------
-- Q1. List all ACTIVE Motor policies expiring in next 30 days
--     (Used by renewal/retention team)
-- ------------------------------------------------------------
SELECT p.policy_number,
       c.customer_name,
       c.mobile_number,
       p.policy_end_date,
       p.premium_amount
FROM   policy_master p
JOIN   customer_master c ON c.customer_id = p.customer_id
WHERE  p.line_of_business = 'MOTOR'
AND    p.policy_status = 'ACTIVE'
AND    p.policy_end_date BETWEEN SYSDATE AND SYSDATE + 30
ORDER BY p.policy_end_date;


-- ------------------------------------------------------------
-- Q2. Crop-wise total insured area and sum insured, per district
--     (Used for Agri portfolio risk analysis)
-- ------------------------------------------------------------
SELECT a.district,
       a.crop_name,
       COUNT(*)                       AS policy_count,
       SUM(a.area_insured_hectares)    AS total_area_hectares,
       SUM(p.sum_insured)               AS total_sum_insured
FROM   agri_crop_details a
JOIN   policy_master p ON p.policy_id = a.policy_id
GROUP BY a.district, a.crop_name
ORDER BY a.district, total_sum_insured DESC;


-- ------------------------------------------------------------
-- Q3. Claim Settlement Ratio (Approved vs Total Claims) by LOB
--     (Common KPI requested by management / IRDAI reporting)
-- ------------------------------------------------------------
SELECT p.line_of_business,
       COUNT(cl.claim_id)                                            AS total_claims,
       SUM(CASE WHEN cl.claim_status = 'APPROVED' THEN 1 ELSE 0 END) AS approved_claims,
       ROUND( SUM(CASE WHEN cl.claim_status = 'APPROVED' THEN 1 ELSE 0 END)
              / COUNT(cl.claim_id) * 100, 2)                          AS settlement_ratio_pct
FROM   claims_master cl
JOIN   policy_master p ON p.policy_id = cl.policy_id
GROUP BY p.line_of_business;


-- ------------------------------------------------------------
-- Q4. Policies with NO premium payment received yet
--     (Used by Application Support team to flag data/payment gateway issues)
-- ------------------------------------------------------------
SELECT p.policy_number, p.customer_id, p.premium_amount, p.policy_status
FROM   policy_master p
LEFT JOIN premium_payment pp ON pp.policy_id = p.policy_id
WHERE  pp.payment_id IS NULL
AND    p.policy_status = 'ACTIVE';


-- ------------------------------------------------------------
-- Q5. Find duplicate vehicle registration numbers across policies
--     (Data quality check - common production support task)
-- ------------------------------------------------------------
SELECT registration_number, COUNT(*) AS occurrence_count
FROM   motor_vehicle_details
GROUP BY registration_number
HAVING COUNT(*) > 1;


-- ------------------------------------------------------------
-- Q6. Average claim processing time (days) for SETTLED claims
--     (TAT - Turn Around Time report)
-- ------------------------------------------------------------
SELECT p.line_of_business,
       ROUND(AVG(cl.intimation_date - cl.incident_date), 1) AS avg_days_intimation_after_incident
FROM   claims_master cl
JOIN   policy_master p ON p.policy_id = cl.policy_id
WHERE  cl.claim_status IN ('APPROVED','SETTLED','REJECTED')
GROUP BY p.line_of_business;


-- ------------------------------------------------------------
-- Q7. Top 5 agents by premium collected (Agent performance report)
-- ------------------------------------------------------------
SELECT ag.agent_name,
       COUNT(p.policy_id)        AS policies_sold,
       SUM(p.premium_amount)      AS total_premium
FROM   policy_master p
JOIN   agent_master ag ON ag.agent_id = p.agent_id
GROUP BY ag.agent_name
ORDER BY total_premium DESC
FETCH FIRST 5 ROWS ONLY;   -- For SQL Server use: SELECT TOP 5 ...
                            -- For MySQL use: ... LIMIT 5;


-- ------------------------------------------------------------
-- Q8. Customers with KYC pending for more than 7 days
--     (Compliance / operations follow-up list)
-- ------------------------------------------------------------
SELECT customer_id, customer_name, mobile_number, created_date
FROM   customer_master
WHERE  kyc_status = 'PENDING'
AND    created_date < SYSDATE - 7;
