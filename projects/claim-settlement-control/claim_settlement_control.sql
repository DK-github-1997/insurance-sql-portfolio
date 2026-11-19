-- Project: Claim Settlement Control
-- Database: Oracle 12c+ (uses standard PL/SQL and MERGE)
-- Purpose: validate a staged settlement batch and upsert one audit outcome
-- per claim. This is a control/demo workflow; it does NOT release payments.
--
-- Run once in a demo schema. Re-running the DDL requires dropping the demo
-- objects first. The package deliberately does not COMMIT: transaction
-- ownership remains with the calling job/session.

CREATE TABLE claim_settlement_stage (
    batch_id               NUMBER        NOT NULL,
    claim_id               VARCHAR2(40)  NOT NULL,
    approved_amount        NUMBER(12,2),
    settlement_reference   VARCHAR2(80),
    staged_at              TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE INDEX ix_css_batch_claim
    ON claim_settlement_stage (batch_id, claim_id);

CREATE TABLE claim_settlement_audit (
    batch_id       NUMBER        NOT NULL,
    claim_id       VARCHAR2(40)  NOT NULL,
    row_count      NUMBER        NOT NULL,
    approved_amount NUMBER(12,2),
    result_status  VARCHAR2(10)  NOT NULL,
    result_reason  VARCHAR2(100) NOT NULL,
    processed_at   TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT pk_claim_settlement_audit PRIMARY KEY (batch_id, claim_id),
    CONSTRAINT ck_csa_status CHECK (result_status IN ('VALID', 'REJECTED'))
);

CREATE OR REPLACE PACKAGE claim_settlement_control_pkg AS
    PROCEDURE validate_batch(p_batch_id IN NUMBER);
END claim_settlement_control_pkg;
/

CREATE OR REPLACE PACKAGE BODY claim_settlement_control_pkg AS
    PROCEDURE validate_batch(p_batch_id IN NUMBER) IS
        l_stage_count PLS_INTEGER;
    BEGIN
        IF p_batch_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Batch ID is required');
        END IF;

        SELECT COUNT(*)
          INTO l_stage_count
          FROM claim_settlement_stage
         WHERE batch_id = p_batch_id;

        IF l_stage_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'No staged rows found for batch');
        END IF;

        MERGE INTO claim_settlement_audit tgt
        USING (
            SELECT
                batch_id,
                claim_id,
                COUNT(*) AS row_count,
                MIN(approved_amount) AS approved_amount,
                CASE
                    WHEN COUNT(*) > 1 THEN 'REJECTED'
                    WHEN MIN(approved_amount) IS NULL THEN 'REJECTED'
                    WHEN MIN(approved_amount) <= 0 THEN 'REJECTED'
                    WHEN MIN(settlement_reference) IS NULL THEN 'REJECTED'
                    ELSE 'VALID'
                END AS result_status,
                CASE
                    WHEN COUNT(*) > 1 THEN 'DUPLICATE_CLAIM_IN_BATCH'
                    WHEN MIN(approved_amount) IS NULL THEN 'APPROVED_AMOUNT_MISSING'
                    WHEN MIN(approved_amount) <= 0 THEN 'APPROVED_AMOUNT_NOT_POSITIVE'
                    WHEN MIN(settlement_reference) IS NULL THEN 'SETTLEMENT_REFERENCE_MISSING'
                    ELSE 'VALIDATION_PASSED'
                END AS result_reason
            FROM claim_settlement_stage
            WHERE batch_id = p_batch_id
            GROUP BY batch_id, claim_id
        ) src
        ON (tgt.batch_id = src.batch_id AND tgt.claim_id = src.claim_id)
        WHEN MATCHED THEN UPDATE SET
            tgt.row_count = src.row_count,
            tgt.approved_amount = src.approved_amount,
            tgt.result_status = src.result_status,
            tgt.result_reason = src.result_reason,
            tgt.processed_at = SYSTIMESTAMP
        WHEN NOT MATCHED THEN INSERT (
            batch_id, claim_id, row_count, approved_amount,
            result_status, result_reason, processed_at
        ) VALUES (
            src.batch_id, src.claim_id, src.row_count, src.approved_amount,
            src.result_status, src.result_reason, SYSTIMESTAMP
        );

        -- No COMMIT here. Caller decides whether to commit or roll back.
    EXCEPTION
        WHEN OTHERS THEN
            -- Preserve the original Oracle error for the scheduler/caller.
            RAISE;
    END validate_batch;
END claim_settlement_control_pkg;
/

-- Example execution after loading synthetic rows into CLAIM_SETTLEMENT_STAGE:
-- BEGIN
--   claim_settlement_control_pkg.validate_batch(p_batch_id => 1001);
-- END;
-- /
--
-- Review:
-- SELECT * FROM claim_settlement_audit
-- WHERE batch_id = 1001
-- ORDER BY claim_id;
--
-- Operational notes:
-- 1. VALID means the staged row passed these demo controls; it is not proof
--    that a bank/payment gateway settled the claim.
-- 2. The MERGE makes repeated validation of the same batch/claim update the
--    existing audit row instead of inserting a second audit record.
-- 3. The caller should serialize concurrent validation for the same batch
--    and enforce a unique business key at the upstream load boundary.
-- 4. Extend the checks only after confirming the actual domain data contract.
