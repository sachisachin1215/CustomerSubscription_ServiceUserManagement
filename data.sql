-- ====================================================================
-- CUSTOMER SUBSCRIPTION & SERVICE USAGE MANAGEMENT PLATFORM
-- DATABASE SEED DATA (MySQL Compatible)
-- ====================================================================

USE customer_subscription_platform;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. USERS (BCrypt Password = 'admin123' / 'customer123')
INSERT INTO users (id, username, password, email, role, enabled) VALUES
(1, 'admin', '$2a$10$eACCx4c99H/wE8.tH3MzA.S7aQvO6K4zY.92A1W.eW8Q2vVw8vQmW', 'admin@platform.com', 'ROLE_ADMIN', true),
(2, 'superadmin', '$2a$10$eACCx4c99H/wE8.tH3MzA.S7aQvO6K4zY.92A1W.eW8Q2vVw8vQmW', 'superadmin@platform.com', 'ROLE_ADMIN', true),
(3, 'customer1', '$2a$10$qT1fE7vM9sE8qL3aH9k4.O8W.eW8Q2vVw8vQmW2A1W.eW8Q2vVw8v', 'rahul.sharma@example.com', 'ROLE_CUSTOMER', true),
(4, 'customer2', '$2a$10$qT1fE7vM9sE8qL3aH9k4.O8W.eW8Q2vVw8vQmW2A1W.eW8Q2vVw8v', 'priya.patel@example.com', 'ROLE_CUSTOMER', true),
(5, 'customer3', '$2a$10$qT1fE7vM9sE8qL3aH9k4.O8W.eW8Q2vVw8vQmW2A1W.eW8Q2vVw8v', 'amit.kumar@example.com', 'ROLE_CUSTOMER', true);

-- 2. CUSTOMERS
INSERT INTO customers (customer_id, customer_code, first_name, last_name, email, phone, address, account_status, eligibility_status, user_id) VALUES
(1, 'CUST-1001', 'Rahul', 'Sharma', 'rahul.sharma@example.com', '+91 9876543210', 'Tech Park, Bangalore', 'ACTIVE', 'ELIGIBLE', 3),
(2, 'CUST-1002', 'Priya', 'Patel', 'priya.patel@example.com', '+91 9876543211', 'MG Road, Mumbai', 'ACTIVE', 'ELIGIBLE', 4),
(3, 'CUST-1003', 'Amit', 'Kumar', 'amit.kumar@example.com', '+91 9876543212', 'Connaught Place, Delhi', 'ACTIVE', 'ELIGIBLE', 5);

-- 3. PLANS
INSERT INTO plans (plan_id, plan_code, plan_name, description, price, billing_cycle, validity_days, status) VALUES
(1, 'PLAN-BASIC', 'Basic Plan', 'Starter plan for developers & individual creators', 499.00, 'MONTHLY', 30, 'ACTIVE'),
(2, 'PLAN-STD', 'Standard Plan', 'Growth plan for small & medium businesses', 999.00, 'MONTHLY', 30, 'ACTIVE'),
(3, 'PLAN-PREM', 'Premium Plan', 'Enterprise-grade feature plan for scaled operations', 1999.00, 'MONTHLY', 30, 'ACTIVE'),
(4, 'PLAN-ENT', 'Enterprise Plan', 'Custom high-capacity plan for high volume demands', 4999.00, 'YEARLY', 365, 'ACTIVE');

-- 4. FEATURES
INSERT INTO features (feature_id, feature_code, feature_name, description, unit, status) VALUES
(1, 'FEAT-API', 'API Calls', 'REST API Request quota', 'Calls', 'ACTIVE'),
(2, 'FEAT-STOR', 'Storage', 'Cloud Storage Quota', 'GB', 'ACTIVE'),
(3, 'FEAT-SMS', 'SMS Notifications', 'Transactional & Alert SMS messages', 'SMS', 'ACTIVE'),
(4, 'FEAT-VID', 'Video Streaming', 'HD Streaming Bandwidth Hours', 'Hours', 'ACTIVE');

-- 5. PLAN_FEATURES
INSERT INTO plan_features (plan_feature_id, plan_id, feature_id, usage_limit, overage_allowed, overage_rate, status) VALUES
(1, 1, 1, 100.00, false, 0.00, 'ACTIVE'),
(2, 1, 2, 10.00, false, 0.00, 'ACTIVE'),
(3, 1, 3, 100.00, false, 0.00, 'ACTIVE'),
(4, 2, 1, 500.00, false, 0.00, 'ACTIVE'),
(5, 2, 2, 50.00, true, 1.50, 'ACTIVE');

-- 6. SUBSCRIPTIONS
INSERT INTO subscriptions (subscription_id, customer_id, plan_id, start_date, end_date, status, auto_renew, renewal_date) VALUES
(1, 1, 1, CURDATE() - INTERVAL 10 DAY, CURDATE() + INTERVAL 20 DAY, 'ACTIVE', true, CURDATE() + INTERVAL 20 DAY),
(2, 2, 2, CURDATE() - INTERVAL 15 DAY, CURDATE() + INTERVAL 15 DAY, 'ACTIVE', true, CURDATE() + INTERVAL 15 DAY),
(3, 3, 3, CURDATE() - INTERVAL 5 DAY, CURDATE() + INTERVAL 25 DAY, 'ACTIVE', true, CURDATE() + INTERVAL 25 DAY);

-- 7. USAGE TRANSACTIONS
INSERT INTO usage_transactions (usage_transaction_id, customer_id, subscription_id, feature_id, quantity, usage_timestamp, validation_status, rejection_reason) VALUES
(1, 1, 1, 1, 30.00, NOW() - INTERVAL 5 DAY, 'APPROVED', NULL),
(2, 1, 1, 1, 40.00, NOW() - INTERVAL 2 DAY, 'APPROVED', NULL),
(3, 1, 1, 1, 40.00, NOW() - INTERVAL 1 DAY, 'REJECTED', 'USAGE_LIMIT_EXCEEDED');

SET FOREIGN_KEY_CHECKS = 1;
