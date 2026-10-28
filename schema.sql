-- ====================================================================
-- CUSTOMER SUBSCRIPTION & SERVICE USAGE MANAGEMENT PLATFORM
-- DATABASE SCHEMA DDL (MySQL Compatible)
-- ====================================================================

CREATE DATABASE IF NOT EXISTS customer_subscription_platform;
USE customer_subscription_platform;

-- Disable Foreign Key checks during schema generation
SET FOREIGN_KEY_CHECKS = 0;

-- 1. USERS TABLE
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role VARCHAR(20) NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. CUSTOMERS TABLE
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_code VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(500),
    account_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    eligibility_status VARCHAR(20) NOT NULL DEFAULT 'ELIGIBLE',
    user_id BIGINT UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_customer_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. PLANS TABLE
DROP TABLE IF EXISTS plans;
CREATE TABLE plans (
    plan_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    plan_code VARCHAR(50) NOT NULL UNIQUE,
    plan_name VARCHAR(100) NOT NULL,
    description VARCHAR(1000),
    price DECIMAL(10,2) NOT NULL,
    billing_cycle VARCHAR(20) NOT NULL DEFAULT 'MONTHLY',
    validity_days INT NOT NULL DEFAULT 30,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. FEATURES TABLE
DROP TABLE IF EXISTS features;
CREATE TABLE features (
    feature_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    feature_code VARCHAR(50) NOT NULL UNIQUE,
    feature_name VARCHAR(100) NOT NULL,
    description VARCHAR(1000),
    unit VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. PLAN_FEATURES TABLE
DROP TABLE IF EXISTS plan_features;
CREATE TABLE plan_features (
    plan_feature_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    plan_id BIGINT NOT NULL,
    feature_id BIGINT NOT NULL,
    usage_limit DECIMAL(19,2) NOT NULL,
    overage_allowed BOOLEAN NOT NULL DEFAULT FALSE,
    overage_rate DECIMAL(10,2) DEFAULT 0.00,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT uk_plan_feature UNIQUE (plan_id, feature_id),
    CONSTRAINT fk_pf_plan FOREIGN KEY (plan_id) REFERENCES plans(plan_id) ON DELETE CASCADE,
    CONSTRAINT fk_pf_feature FOREIGN KEY (feature_id) REFERENCES features(feature_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. SUBSCRIPTIONS TABLE
DROP TABLE IF EXISTS subscriptions;
CREATE TABLE subscriptions (
    subscription_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    plan_id BIGINT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    auto_renew BOOLEAN NOT NULL DEFAULT TRUE,
    renewal_date DATE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_sub_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_sub_plan FOREIGN KEY (plan_id) REFERENCES plans(plan_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. USAGE_TRANSACTIONS TABLE
DROP TABLE IF EXISTS usage_transactions;
CREATE TABLE usage_transactions (
    usage_transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    subscription_id BIGINT,
    feature_id BIGINT NOT NULL,
    quantity DECIMAL(19,2) NOT NULL,
    usage_timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    validation_status VARCHAR(20) NOT NULL,
    rejection_reason VARCHAR(255),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ut_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_ut_subscription FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id) ON DELETE SET NULL,
    CONSTRAINT fk_ut_feature FOREIGN KEY (feature_id) REFERENCES features(feature_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. UPGRADE_DOWNGRADE_REQUESTS TABLE
DROP TABLE IF EXISTS upgrade_downgrade_requests;
CREATE TABLE upgrade_downgrade_requests (
    request_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    subscription_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    current_plan_id BIGINT NOT NULL,
    requested_plan_id BIGINT NOT NULL,
    request_date DATE NOT NULL,
    effective_date DATE,
    change_type VARCHAR(20) NOT NULL,
    reason VARCHAR(1000),
    status VARCHAR(20) NOT NULL DEFAULT 'REQUESTED',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_ud_sub FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id) ON DELETE CASCADE,
    CONSTRAINT fk_ud_cust FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_ud_cplan FOREIGN KEY (current_plan_id) REFERENCES plans(plan_id),
    CONSTRAINT fk_ud_rplan FOREIGN KEY (requested_plan_id) REFERENCES plans(plan_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9. CANCELLATIONS TABLE
DROP TABLE IF EXISTS cancellations;
CREATE TABLE cancellations (
    cancellation_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    subscription_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    reason VARCHAR(1000),
    requested_date DATE NOT NULL,
    effective_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'REQUESTED',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cn_sub FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id) ON DELETE CASCADE,
    CONSTRAINT fk_cn_cust FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 10. RENEWALS TABLE
DROP TABLE IF EXISTS renewals;
CREATE TABLE renewals (
    renewal_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    subscription_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    previous_end_date DATE NOT NULL,
    new_start_date DATE NOT NULL,
    new_end_date DATE NOT NULL,
    renewal_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    renewal_date DATE NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rn_sub FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id) ON DELETE CASCADE,
    CONSTRAINT fk_rn_cust FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 11. SUBSCRIPTION_HISTORY TABLE
DROP TABLE IF EXISTS subscription_history;
CREATE TABLE subscription_history (
    history_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    subscription_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    previous_plan VARCHAR(100),
    new_plan VARCHAR(100),
    previous_status VARCHAR(20),
    new_status VARCHAR(20),
    event_type VARCHAR(50) NOT NULL,
    reason VARCHAR(1000),
    changed_by VARCHAR(100),
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sh_sub FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id) ON DELETE CASCADE,
    CONSTRAINT fk_sh_cust FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 12. AUDIT_LOGS TABLE
DROP TABLE IF EXISTS audit_logs;
CREATE TABLE audit_logs (
    audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    action VARCHAR(100) NOT NULL,
    entity_name VARCHAR(100),
    entity_id BIGINT,
    old_value VARCHAR(2000),
    new_value VARCHAR(2000),
    timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(45)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
