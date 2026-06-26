/*=====================================================================
  File        : 01_create_tables.sql
  Purpose     : Core schema for Agriculture & Motor Insurance domain
  Author      : <Your Name>
  Database    : Oracle (tested on Oracle 19c) -  minor tweaks needed for
                MySQL / PostgreSQL / SQL Server (see notes at bottom)
=======================================================================*/

-- ============================================================
-- 1. CUSTOMER / POLICYHOLDER MASTER
-- ============================================================
CREATE TABLE customer_master (
    customer_id        NUMBER(10)        PRIMARY KEY,
    customer_name       VARCHAR2(100)     NOT NULL,
    date_of_birth       DATE,
    gender               VARCHAR2(10),
    mobile_number        VARCHAR2(15),
    email                VARCHAR2(100),
    address               VARCHAR2(250),
    state                 VARCHAR2(50),
    pincode               VARCHAR2(10),
    kyc_status            VARCHAR2(20) DEFAULT 'PENDING',  -- PENDING / VERIFIED / REJECTED
    created_date          DATE DEFAULT SYSDATE
);

-- ============================================================
-- 2. POLICY MASTER (common to all LOBs - Line of Business)
-- ============================================================
CREATE TABLE policy_master (
    policy_id           NUMBER(10)        PRIMARY KEY,
    policy_number        VARCHAR2(30)      UNIQUE NOT NULL,
    customer_id          NUMBER(10)        NOT NULL,
    line_of_business      VARCHAR2(20)      NOT NULL,   -- 'MOTOR' or 'AGRI'
    product_code           VARCHAR2(20),
    policy_start_date       DATE             NOT NULL,
    policy_end_date          DATE             NOT NULL,
    sum_insured                NUMBER(15,2),
    premium_amount               NUMBER(12,2),
    policy_status                  VARCHAR2(20) DEFAULT 'ACTIVE', -- ACTIVE/LAPSED/CANCELLED/EXPIRED
    agent_id                         NUMBER(10),
    created_date                       DATE DEFAULT SYSDATE,
    CONSTRAINT fk_policy_customer FOREIGN KEY (customer_id)
        REFERENCES customer_master(customer_id)
);

-- ============================================================
-- 3. MOTOR INSURANCE - VEHICLE DETAILS
-- ============================================================
CREATE TABLE motor_vehicle_details (
    vehicle_id          NUMBER(10)        PRIMARY KEY,
    policy_id            NUMBER(10)        NOT NULL,
    registration_number   VARCHAR2(20)      NOT NULL,
    vehicle_type            VARCHAR2(30),     -- CAR / TWO_WHEELER / COMMERCIAL
    make                       VARCHAR2(50),
    model                        VARCHAR2(50),
    manufacture_year              NUMBER(4),
    engine_number                    VARCHAR2(30),
    chassis_number                     VARCHAR2(30),
    idv_value                            NUMBER(12,2),   -- Insured Declared Value
    ncb_percentage                         NUMBER(5,2),  -- No Claim Bonus
    CONSTRAINT fk_vehicle_policy FOREIGN KEY (policy_id)
        REFERENCES policy_master(policy_id)
);

-- ============================================================
-- 4. AGRICULTURE INSURANCE - CROP / FARM DETAILS
-- ============================================================
CREATE TABLE agri_crop_details (
    crop_record_id       NUMBER(10)        PRIMARY KEY,
    policy_id             NUMBER(10)        NOT NULL,
    farmer_id               NUMBER(10)      NOT NULL,
    crop_name                 VARCHAR2(50)  NOT NULL,   -- e.g. WHEAT, COTTON, RICE
    season                       VARCHAR2(20),           -- KHARIF / RABI
    survey_number                  VARCHAR2(30),
    area_insured_hectares             NUMBER(8,2),
    sowing_date                          DATE,
    expected_yield_qtl                    NUMBER(10,2),
    state                                    VARCHAR2(50),
    district                                  VARCHAR2(50),
    CONSTRAINT fk_agri_policy FOREIGN KEY (policy_id)
        REFERENCES policy_master(policy_id)
);

-- ============================================================
-- 5. CLAIMS MASTER (common to both LOBs)
-- ============================================================
CREATE TABLE claims_master (
    claim_id             NUMBER(10)        PRIMARY KEY,
    claim_number           VARCHAR2(30)     UNIQUE NOT NULL,
    policy_id                NUMBER(10)     NOT NULL,
    claim_type                  VARCHAR2(30), -- ACCIDENT / THEFT / CROP_DAMAGE / NATURAL_CALAMITY
    intimation_date                DATE      NOT NULL,
    incident_date                    DATE,
    claim_amount_requested              NUMBER(12,2),
    claim_amount_approved                  NUMBER(12,2),
    claim_status                              VARCHAR2(20) DEFAULT 'REGISTERED',
                                               -- REGISTERED/UNDER_REVIEW/APPROVED/REJECTED/SETTLED
    surveyor_id                                  NUMBER(10),
    remarks                                        VARCHAR2(500),
    CONSTRAINT fk_claim_policy FOREIGN KEY (policy_id)
        REFERENCES policy_master(policy_id)
);

-- ============================================================
-- 6. PREMIUM PAYMENT HISTORY
-- ============================================================
CREATE TABLE premium_payment (
    payment_id           NUMBER(10)        PRIMARY KEY,
    policy_id             NUMBER(10)        NOT NULL,
    payment_date            DATE            NOT NULL,
    amount_paid                NUMBER(12,2)  NOT NULL,
    payment_mode                  VARCHAR2(20),  -- CASH/CARD/UPI/NEFT
    receipt_number                   VARCHAR2(30),
    CONSTRAINT fk_payment_policy FOREIGN KEY (policy_id)
        REFERENCES policy_master(policy_id)
);

-- ============================================================
-- 7. AGENT / INTERMEDIARY MASTER
-- ============================================================
CREATE TABLE agent_master (
    agent_id             NUMBER(10)        PRIMARY KEY,
    agent_name             VARCHAR2(100)    NOT NULL,
    branch_code               VARCHAR2(20),
    contact_number               VARCHAR2(15),
    status                          VARCHAR2(15) DEFAULT 'ACTIVE'
);

/*=====================================================================
  NOTES FOR OTHER DATABASES
  -----------------------------------------------------------------
  - MySQL      : Replace NUMBER -> INT/DECIMAL, VARCHAR2 -> VARCHAR,
                 SYSDATE -> CURDATE() or NOW()
  - PostgreSQL : Replace NUMBER -> NUMERIC/INTEGER, VARCHAR2 -> VARCHAR,
                 SYSDATE -> CURRENT_DATE
  - SQL Server : Replace NUMBER -> INT/DECIMAL, VARCHAR2 -> VARCHAR,
                 SYSDATE -> GETDATE()
=======================================================================*/
