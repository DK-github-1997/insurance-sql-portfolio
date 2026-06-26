/*=====================================================================
  File    : 02_insert_sample_data.sql
  Purpose : Sample/dummy data to test the schema (no real customer data)
=======================================================================*/

-- Agents
INSERT INTO agent_master VALUES (1, 'Ramesh Patil', 'PUN001', '9876543210', 'ACTIVE');
INSERT INTO agent_master VALUES (2, 'Sunita Deshmukh', 'PUN002', '9876501234', 'ACTIVE');

-- Customers
INSERT INTO customer_master (customer_id, customer_name, date_of_birth, gender, mobile_number, email, address, state, pincode, kyc_status)
VALUES (101, 'Anil Kumar Sharma', TO_DATE('1985-04-12','YYYY-MM-DD'), 'MALE', '9000011111', 'anil.sharma@example.com', 'Village Rasulpur', 'Maharashtra', '413001', 'VERIFIED');

INSERT INTO customer_master (customer_id, customer_name, date_of_birth, gender, mobile_number, email, address, state, pincode, kyc_status)
VALUES (102, 'Priya Suresh Patil', TO_DATE('1990-09-23','YYYY-MM-DD'), 'FEMALE', '9000022222', 'priya.patil@example.com', '12 MG Road', 'Maharashtra', '411001', 'VERIFIED');

-- Policies
INSERT INTO policy_master (policy_id, policy_number, customer_id, line_of_business, product_code, policy_start_date, policy_end_date, sum_insured, premium_amount, policy_status, agent_id)
VALUES (1001, 'MOT-2025-000123', 101, 'MOTOR', 'PVT_CAR_COMP', TO_DATE('2025-01-15','YYYY-MM-DD'), TO_DATE('2026-01-14','YYYY-MM-DD'), 650000, 18500, 'ACTIVE', 1);

INSERT INTO policy_master (policy_id, policy_number, customer_id, line_of_business, product_code, policy_start_date, policy_end_date, sum_insured, premium_amount, policy_status, agent_id)
VALUES (1002, 'AGR-2025-000456', 102, 'AGRI', 'CROP_WBCIS', TO_DATE('2025-06-01','YYYY-MM-DD'), TO_DATE('2025-11-30','YYYY-MM-DD'), 200000, 4500, 'ACTIVE', 2);

-- Motor Vehicle Details
INSERT INTO motor_vehicle_details (vehicle_id, policy_id, registration_number, vehicle_type, make, model, manufacture_year, engine_number, chassis_number, idv_value, ncb_percentage)
VALUES (1, 1001, 'MH12AB1234', 'CAR', 'Maruti Suzuki', 'Swift', 2022, 'ENG12345', 'CHS98765', 650000, 20);

-- Agri Crop Details
INSERT INTO agri_crop_details (crop_record_id, policy_id, farmer_id, crop_name, season, survey_number, area_insured_hectares, sowing_date, expected_yield_qtl, state, district)
VALUES (1, 1002, 102, 'COTTON', 'KHARIF', 'SUR/45/2025', 2.5, TO_DATE('2025-06-15','YYYY-MM-DD'), 15, 'Maharashtra', 'Pune');

-- Claims
INSERT INTO claims_master (claim_id, claim_number, policy_id, claim_type, intimation_date, incident_date, claim_amount_requested, claim_amount_approved, claim_status, surveyor_id, remarks)
VALUES (1, 'CLM-2025-0001', 1001, 'ACCIDENT', TO_DATE('2025-08-10','YYYY-MM-DD'), TO_DATE('2025-08-09','YYYY-MM-DD'), 45000, 40000, 'APPROVED', 501, 'Front bumper damage, minor collision');

INSERT INTO claims_master (claim_id, claim_number, policy_id, claim_type, intimation_date, incident_date, claim_amount_requested, claim_amount_approved, claim_status, surveyor_id, remarks)
VALUES (2, 'CLM-2025-0002', 1002, 'CROP_DAMAGE', TO_DATE('2025-09-05','YYYY-MM-DD'), TO_DATE('2025-09-01','YYYY-MM-DD'), 80000, NULL, 'UNDER_REVIEW', 502, 'Heavy rainfall caused flooding in field');

-- Premium Payments
INSERT INTO premium_payment (payment_id, policy_id, payment_date, amount_paid, payment_mode, receipt_number)
VALUES (1, 1001, TO_DATE('2025-01-15','YYYY-MM-DD'), 18500, 'UPI', 'RCPT0001');

INSERT INTO premium_payment (payment_id, policy_id, payment_date, amount_paid, payment_mode, receipt_number)
VALUES (2, 1002, TO_DATE('2025-06-01','YYYY-MM-DD'), 4500, 'NEFT', 'RCPT0002');

COMMIT;
