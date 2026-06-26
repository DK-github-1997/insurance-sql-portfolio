/*=====================================================================
  File    : 04_plsql_programs.sql
  Purpose : PL/SQL Procedures, Functions, Triggers, and Cursors
            commonly used in Insurance application support/development
=======================================================================*/

-- ============================================================
-- 1. PROCEDURE: Register a new claim and auto-generate claim number
-- ============================================================
CREATE OR REPLACE PROCEDURE register_claim (
    p_policy_id          IN  NUMBER,
    p_claim_type          IN  VARCHAR2,
    p_incident_date         IN  DATE,
    p_claim_amount             IN  NUMBER,
    p_claim_number_out             OUT VARCHAR2
)
IS
    v_seq_num    NUMBER;
    v_policy_cnt NUMBER;
BEGIN
    -- Validate policy exists and is active
    SELECT COUNT(*) INTO v_policy_cnt
    FROM   policy_master
    WHERE  policy_id = p_policy_id
    AND    policy_status = 'ACTIVE';

    IF v_policy_cnt = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Policy not found or not active. Claim cannot be registered.');
    END IF;

    SELECT NVL(MAX(claim_id), 0) + 1 INTO v_seq_num FROM claims_master;

    p_claim_number_out := 'CLM-' || TO_CHAR(SYSDATE, 'YYYY') || '-' || LPAD(v_seq_num, 4, '0');

    INSERT INTO claims_master (
        claim_id, claim_number, policy_id, claim_type,
        intimation_date, incident_date, claim_amount_requested, claim_status
    ) VALUES (
        v_seq_num, p_claim_number_out, p_policy_id, p_claim_type,
        SYSDATE, p_incident_date, p_claim_amount, 'REGISTERED'
    );

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END register_claim;
/


-- ============================================================
-- 2. FUNCTION: Calculate No Claim Bonus (NCB) discount % for motor renewal
--    Simple slab logic commonly used in motor insurance pricing
-- ============================================================
CREATE OR REPLACE FUNCTION get_ncb_discount (
    p_claim_free_years IN NUMBER
) RETURN NUMBER
IS
    v_discount NUMBER;
BEGIN
    CASE
        WHEN p_claim_free_years = 0 THEN v_discount := 0;
        WHEN p_claim_free_years = 1 THEN v_discount := 20;
        WHEN p_claim_free_years = 2 THEN v_discount := 25;
        WHEN p_claim_free_years = 3 THEN v_discount := 35;
        WHEN p_claim_free_years = 4 THEN v_discount := 45;
        WHEN p_claim_free_years >= 5 THEN v_discount := 50;
        ELSE v_discount := 0;
    END CASE;

    RETURN v_discount;
END get_ncb_discount;
/


-- ============================================================
-- 3. TRIGGER: Prevent premium payment for a CANCELLED or EXPIRED policy
--    (Common data-integrity guard used in application support)
-- ============================================================
CREATE OR REPLACE TRIGGER trg_check_policy_status
BEFORE INSERT ON premium_payment
FOR EACH ROW
DECLARE
    v_status VARCHAR2(20);
BEGIN
    SELECT policy_status INTO v_status
    FROM   policy_master
    WHERE  policy_id = :NEW.policy_id;

    IF v_status IN ('CANCELLED', 'EXPIRED') THEN
        RAISE_APPLICATION_ERROR(-20002, 'Cannot accept premium payment for a cancelled/expired policy.');
    END IF;
END trg_check_policy_status;
/


-- ============================================================
-- 4. CURSOR EXAMPLE: Loop through pending KYC customers and
--    print a follow-up reminder list (explicit cursor with FOR loop)
-- ============================================================
DECLARE
    CURSOR c_pending_kyc IS
        SELECT customer_id, customer_name, mobile_number
        FROM   customer_master
        WHERE  kyc_status = 'PENDING';
BEGIN
    FOR rec IN c_pending_kyc LOOP
        DBMS_OUTPUT.PUT_LINE('Reminder -> Customer: ' || rec.customer_name ||
                              ' | Mobile: ' || rec.mobile_number ||
                              ' | ID: ' || rec.customer_id);
    END LOOP;
END;
/


-- ============================================================
-- 5. PACKAGE: Simple package grouping claim-related operations
--    (Shows packaging skills - common ask in PLSQL developer interviews)
-- ============================================================
CREATE OR REPLACE PACKAGE claims_pkg IS
    PROCEDURE approve_claim (p_claim_id IN NUMBER, p_approved_amount IN NUMBER);
    PROCEDURE reject_claim  (p_claim_id IN NUMBER, p_reason IN VARCHAR2);
END claims_pkg;
/

CREATE OR REPLACE PACKAGE BODY claims_pkg IS

    PROCEDURE approve_claim (p_claim_id IN NUMBER, p_approved_amount IN NUMBER) IS
    BEGIN
        UPDATE claims_master
        SET    claim_status = 'APPROVED',
               claim_amount_approved = p_approved_amount
        WHERE  claim_id = p_claim_id;
        COMMIT;
    END approve_claim;

    PROCEDURE reject_claim (p_claim_id IN NUMBER, p_reason IN VARCHAR2) IS
    BEGIN
        UPDATE claims_master
        SET    claim_status = 'REJECTED',
               remarks = p_reason
        WHERE  claim_id = p_claim_id;
        COMMIT;
    END reject_claim;

END claims_pkg;
/

-- ============================================================
-- Sample usage (for testing in SQL*Plus / SQL Developer):
-- ============================================================
-- SET SERVEROUTPUT ON;
-- DECLARE
--     v_claim_no VARCHAR2(30);
-- BEGIN
--     register_claim(1001, 'ACCIDENT', SYSDATE, 25000, v_claim_no);
--     DBMS_OUTPUT.PUT_LINE('New Claim Number: ' || v_claim_no);
-- END;
-- /
--
-- SELECT get_ncb_discount(3) FROM dual;   -- returns 35
--
-- BEGIN
--     claims_pkg.approve_claim(1, 40000);
-- END;
-- /
