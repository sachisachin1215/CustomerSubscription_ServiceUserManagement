# Customer Subscription & Service Usage Management Platform

A production-ready, full-stack enterprise MCA-level software platform for managing customer subscriptions, plan entitlements, service feature quotas, upgrades/downgrades, auto-renewals, cancellations, and real-time usage validation.

---

## 🚀 1. Project Overview & Business Core

In subscription-driven industries (SaaS, Telecom, Cloud API Platforms), managing plan changes, entitlement rules, and usage quota breaches in real-time is business-critical. Manual access management leads to over-billing, unauthorized usage leaks, or revenue loss.

This platform provides an automated, centralized **Subscription & Usage Validation Engine**. Every service request (API Calls, Storage consumption, SMS, Video Streaming, etc.) passes through a 17-step transactional validation engine before access is granted.

---

## 🛠️ 2. Technology Stack

### Frontend:
- **Framework**: React.js 18 (Vite)
- **Routing**: React Router DOM v6
- **State & HTTP**: Axios with JWT Bearer Interceptors & Context API
- **Charts & Visualization**: Recharts Library
- **Icons & UI**: Lucide React + Modern Dark/Glassmorphism CSS Design System

### Backend:
- **Language & Runtime**: Java 21 (OpenJDK)
- **Framework**: Spring Boot 3.2.3
- **Security**: Spring Security 6, JWT (JJWT 0.12.5), BCrypt Password Hashing
- **Persistence & ORM**: Spring Data JPA, Hibernate ORM
- **API Documentation**: SpringDoc OpenAPI / Swagger UI
- **Build Tool**: Apache Maven 3.9.6
- **Testing**: JUnit 5, Mockito, Spring Boot Test

### Database:
- **RDBMS**: MySQL Server 8.0 / MySQL Connector/J (`com.mysql.cj.jdbc.Driver`)
- **Fallback**: H2 In-Memory Database (MySQL Dialect Mode) for instant zero-setup execution

---

## 🏗️ 3. System Architecture & Validation Engine Flow

```
Customer Request (API / Service)
          ↓
     JWT Auth & Role Check
          ↓
[ USAGE VALIDATION ENGINE ]
  ├── 1. Check Customer Existence
  ├── 2. Verify Account Status == ACTIVE
  ├── 3. Verify Customer Eligibility Status == ELIGIBLE
  ├── 4. Retrieve Active Subscription
  ├── 5. Check Subscription Status == ACTIVE
  ├── 6. Verify Date Range (Start Date <= Today <= End Date)
  ├── 7. Verify Requested Feature Exists & is ACTIVE
  ├── 8. Verify Feature Included in Plan (PlanFeature Entity)
  ├── 9. Retrieve Feature Quota Limit & Overage Policy
  ├── 10. Calculate Current Usage for Current Subscription Period
  ├── 11. Calculate Remaining Quota (Limit - Used)
  ├── 12. Validate Requested Quantity > 0
  └── 13. Evaluate Quota Breach (Requested <= Remaining || Overage Allowed)
          ↓
  [ APPROVED / REJECTED ]
          ↓
  ├── Record UsageTransaction (APPROVED / REJECTED with Reason Code)
  └── Record Audit Log Entry (User, Action, Entity, IP)
```

---

## 🔑 4. User Roles & Default Login Credentials

| Role | Username | Password | Access / Capabilities |
| :--- | :--- | :--- | :--- |
| **ADMIN** | `admin` | `admin123` | Full Management: Customers, Plans, Features, Plan Limits, Subscriptions, Approvals, Analytics, Audit Logs |
| **ADMIN** | `superadmin` | `admin123` | System Administrator |
| **CUSTOMER** | `customer1` | `customer123` | Portal Access: Active Plan, Quota Gauges, Usage Validation Simulator, Upgrade/Downgrade Request, Cancellation, Renewal |
| **CUSTOMER** | `customer2` | `customer123` | Customer Account (Standard Plan) |
| **CUSTOMER** | `customer3` | `customer123` | Customer Account (Premium Plan) |

---

## 💻 5. Quick Start & Execution Guide

### Prerequisites:
- Java JDK 21
- Node.js (v18+) & NPM
- MySQL Server 8.0 (Optional - system falls back to H2 automatically if MySQL is offline)

### Step 1: Start Backend Server
```bash
cd backend
mvn spring-boot:run
```
*Backend runs on:* `http://localhost:8080`
*Swagger API Docs:* `http://localhost:8080/swagger-ui.html`
*H2 Console:* `http://localhost:8080/h2-console`

### Step 2: Start React Frontend
```bash
cd frontend
npm install
npm run dev
```
*Frontend runs on:* `http://localhost:5173`

---

## 📡 6. REST API Endpoints Overview

### Authentication:
- `POST /api/auth/login`: Authenticate and receive JWT Token
- `POST /api/auth/register`: Register new customer account

### Usage Validation Engine (Core Module):
- `POST /api/usage/validate`: Execute 17-step usage validation check
- `GET /api/usage/my-summary`: Retrieve current customer quota utilization gauges
- `GET /api/usage/my-transactions`: Retrieve customer usage transaction logs
- `GET /api/usage`: List all telemetry logs (Admin)

### Subscription & Plan Management:
- `GET /api/plans`: List subscription plans
- `POST /api/plans`: Create new subscription plan (Admin)
- `GET /api/subscriptions/my-subscription`: Get current customer active subscription
- `POST /api/subscriptions`: Assign subscription to customer

### Lifecycle Operations:
- `POST /api/upgrade-downgrade/request`: Request tier upgrade or downgrade
- `PATCH /api/upgrade-downgrade/{id}/process`: Approve/Reject plan change (Admin)
- `POST /api/cancellations/request`: Submit cancellation request
- `POST /api/renewals/renew/{subscriptionId}`: Execute subscription renewal

### Analytics & Audit Logs:
- `GET /api/analytics/dashboard`: Aggregate KPI metrics & charts (Admin)
- `GET /api/audit-logs`: System audit trail log (Admin)

---

## 📬 7. Postman Collection

The workspace includes a complete Postman collection ready for import:
- File Location: `postman/Customer-Subscription-Platform.postman_collection.json`

### Import Instructions:
1. Open Postman -> Click **Import** -> Select `Customer-Subscription-Platform.postman_collection.json`.
2. Execute **Authentication -> Admin Login** or **Customer Login**.
3. The response script automatically saves the Bearer JWT token into collection variables.
4. Run requests under **Usage Validation Engine**, **Customer Management**, **Subscription Plans**, and **Analytics**.

---

## 🧪 8. Test Execution

Unit and integration tests for the Usage Validation Engine are located in `backend/src/test/java/com/subscriptionplatform/UsageValidationEngineTest.java`.

To run tests:
```bash
cd backend
mvn test
```

Tested Scenarios:
- Usage within limit approved
- Usage limit exceeded rejected
- Customer not found rejected
- Inactive customer account rejected
- Suspended subscription rejected
- Feature not included in plan rejected
- Invalid quantity rejected

---

## 🗄️ 9. Database Scripts

- DDL Schema Script: `database/schema.sql`
- DML Seed Data Script: `database/data.sql`

---

## 📄 10. License & Project Rights

Developed as an MCA Final-Year Capstone Project. Suitable for university demonstration and academic defense.
