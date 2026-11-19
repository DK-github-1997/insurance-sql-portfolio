-- Demo test data for CLAIM_SETTLEMENT_CONTROL_PKG.
-- Run after claim_settlement_control.sql in a disposable Oracle schema.
-- Expected: CLAIM-100 valid; CLAIM-200 rejected as duplicate; CLAIM-300
-- rejected for a non-positive amount; CLAIM-400 rejected for missing ref.

INSERT INTO claim_settlement_stage
    (batch_id, claim_id, approved_amount, settlement_reference)
VALUES
    (1001, 'CLAIM-100', 1250.00, 'SETTLE-REF-100');

INSERT INTO claim_settlement_stage
    (batch_id, claim_id, approved_amount, settlement_reference)
VALUES
    (1001, 'CLAIM-200', 900.00, 'SETTLE-REF-200-A');

INSERT INTO claim_settlement_stage
    (batch_id, claim_id, approved_amount, settlement_reference)
VALUES
    (1001, 'CLAIM-200', 900.00, 'SETTLE-REF-200-B');

INSERT INTO claim_settlement_stage
    (batch_id, claim_id, approved_amount, settlement_reference)
VALUES
    (1001, 'CLAIM-300', 0.00, 'SETTLE-REF-300');

INSERT INTO claim_settlement_stage
    (batch_id, claim_id, approved_amount, settlement_reference)
VALUES
    (1001, 'CLAIM-400', 450.00, NULL);

BEGIN
    claim_settlement_control_pkg.validate_batch(p_batch_id => 1001);
END;
/

SELECT
    claim_id,
    row_count,
    approved_amount,
    result_status,
    result_reason
FROM claim_settlement_audit
WHERE batch_id = 1001
ORDER BY claim_id;

-- Expected outcomes:
-- CLAIM-100 | 1 | 1250.00 | VALID    | VALIDATION_PASSED
-- CLAIM-200 | 2 |  900.00 | REJECTED | DUPLICATE_CLAIM_IN_BATCH
-- CLAIM-300 | 1 |    0.00 | REJECTED | APPROVED_AMOUNT_NOT_POSITIVE
-- CLAIM-400 | 1 |  450.00 | REJECTED | SETTLEMENT_REFERENCE_MISSING
--
-- This script intentionally leaves transaction control to the caller.
-- ROLLBACK; -- use instead of COMMIT when running an isolated test.
