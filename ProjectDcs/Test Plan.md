# Test Plan - ksf_FA_Performance

## Overview

This document outlines the test strategy, test types, test cases, and acceptance criteria for the Performance Management module.

---

## 1. Test Strategy

### 1.1 Test Objectives

- Verify all functional requirements are met
- Ensure data integrity and consistency
- Validate integration with FA core
- Confirm security controls work correctly
- Achieve code quality standards

### 1.2 Test Levels

| Level | Description | Coverage Target |
|-------|-------------|-----------------|
| Unit Testing | Individual function/method testing | Core business logic |
| Integration Testing | Module integration with FA | All integrations |
| System Testing | End-to-end workflows | Critical paths |
| User Acceptance Testing | Business user validation | All use cases |

### 1.3 Test Types

| Type | Description |
|------|-------------|
| Functional Testing | Feature verification |
| Regression Testing | Existing functionality |
| Security Testing | Permission and access |
| Performance Testing | Response times |
| UI/UX Testing | User interface |

---

## 2. Test Environment

### 2.1 Environment Requirements

- FrontAccounting 2.4.0+ installed
- PHP 8.0+
- MySQL 5.7+
- Web browser (Chrome/Firefox/Edge)
- Sample data loaded

### 2.2 Test Data

**Required Test Data**:
- At least 5 sample KPIs (different categories)
- At least 3 sample employees
- At least 2 sample performance reviews (different statuses)
- At least 5 sample goals (different statuses, priorities)

---

## 3. Test Cases

### 3.1 KPI Management Tests

#### TC-KPI-001: Create New KPI

| Field | Value |
|-------|-------|
| Test ID | TC-KPI-001 |
| Description | Create a new KPI with all required fields |
| Preconditions | User has PERF_MANAGE_KPI permission |
| Steps | 1. Navigate to KPIs page |
| | 2. Click "New KPI" |
| | 3. Fill required fields |
| | 4. Click Save |
| Expected Result | KPI saved to database, appears in list |
| Pass Criteria | KPI visible in list with correct data |

#### TC-KPI-002: View KPI List

| Field | Value |
|-------|-------|
| Test ID | TC-KPI-002 |
| Description | View list of all KPIs |
| Preconditions | User has PERF_VIEW_KPI permission |
| Steps | 1. Navigate to KPIs page |
| | 2. View displayed list |
| Expected Result | KPIs displayed in table format |
| Pass Criteria | All columns display correctly |

#### TC-KPI-003: Filter KPIs by Category

| Field | Value |
|-------|-------|
| Test ID | TC-KPI-003 |
| Description | Filter KPIs by category |
| Preconditions | KPIs exist with different categories |
| Steps | 1. Navigate to KPIs page |
| | 2. Click category filter |
| Expected Result | Only KPIs with selected category shown |
| Pass Criteria | Correct filtering applied |

#### TC-KPI-004: Edit KPI

| Field | Value |
|-------|-------|
| Test ID | TC-KPI-004 |
| Description | Modify existing KPI |
| Preconditions | KPI exists |
| Steps | 1. Navigate to KPIs page |
| | 2. Click Edit on KPI |
| | 3. Modify fields |
| | 4. Click Save |
| Expected Result | KPI updated |
| Pass Criteria | Changes reflected in list |

#### TC-KPI-005: Delete KPI

| Field | Value |
|-------|-------|
| Test ID | TC-KPI-005 |
| Description | Delete a KPI |
| Preconditions | Test KPI exists |
| Steps | 1. Navigate to KPI edit |
| | 2. Click Delete |
| | 3. Confirm deletion |
| Expected Result | KPI removed |
| Pass Criteria | KPI no longer in list |

---

### 3.2 Performance Review Tests

#### TC-PR-001: Create Performance Review

| Field | Value |
|-------|-------|
| Test ID | TC-PR-001 |
| Description | Create a new performance review |
| Preconditions | User has PERF_MANAGE_REVIEW, employees exist |
| Steps | 1. Navigate to Reviews page |
| | 2. Click "New Review" |
| | 3. Select employee and reviewer |
| | 4. Set review period and date |
| | 5. Save |
| Expected Result | Review saved with Draft status |
| Pass Criteria | Review appears in list |

#### TC-PR-002: View Reviews

| Field | Value |
|-------|-------|
| Test ID | TC-PR-002 |
| Description | View list of performance reviews |
| Preconditions | Reviews exist |
| Steps | 1. Navigate to Reviews page |
| | 2. View list |
| Expected Result | Reviews displayed |
| Pass Criteria | Employee names shown, filters work |

#### TC-PR-003: Add Scores to Review

| Field | Value |
|-------|-------|
| Test ID | TC-PR-003 |
| Description | Score employee on KPIs in review |
| Preconditions | Review exists in Draft status, KPIs exist |
| Steps | 1. Edit review |
| | 2. Add scores for each KPI |
| | 3. Add comments |
| | 4. Save |
| Expected Result | Scores saved, overall score calculated |
| Pass Criteria | Individual scores and overall displayed |

#### TC-PR-004: Submit Review

| Field | Value |
|-------|-------|
| Test ID | TC-PR-004 |
| Description | Submit completed review |
| Preconditions | Review has scores, status is Draft |
| Steps | 1. Edit review |
| | 2. Click Submit |
| Expected Result | Status changes to Submitted |
| Pass Criteria | Cannot edit after submit (except admin) |

#### TC-PR-005: Filter Reviews by Status

| Field | Value |
|-------|-------|
| Test ID | TC-PR-005 |
| Description | Filter reviews by status |
| Preconditions | Reviews exist with different statuses |
| Steps | 1. Navigate to Reviews page |
| | 2. Click status filter |
| Expected Result | Only reviews with selected status shown |
| Pass Criteria | Correct filtering |

---

### 3.3 Goal Management Tests

#### TC-GOAL-001: Create Goal

| Field | Value |
|-------|-------|
| Test ID | TC-GOAL-001 |
| Description | Create a new goal for employee |
| Preconditions | User has PERF_MANAGE_GOAL |
| Steps | 1. Navigate to Goals page |
| | 2. Click "New Goal" |
| | 3. Select employee |
| | 4. Enter title, description, target date |
| | 5. Save |
| Expected Result | Goal saved with 0% progress |
| Pass Criteria | Goal appears in list |

#### TC-GOAL-002: Update Goal Progress

| Field | Value |
|-------|-------|
| Test ID | TC-GOAL-002 |
| Description | Update goal completion percentage |
| Preconditions | Goal exists |
| Steps | 1. Edit goal |
| | 2. Update progress to 50% |
| | 3. Save |
| Expected Result | Progress updated |
| Pass Criteria | Progress displays in view |

#### TC-GOAL-003: Goal Overdue Detection

| Field | Value |
|-------|-------|
| Test ID | TC-GOAL-003 |
| Description | Overdue goals highlighted |
| Preconditions | Goal with past target_date and incomplete status |
| Steps | 1. View goal list |
| Expected Result | Overdue goal highlighted in red |
| Pass Criteria | Correct visual indication |

#### TC-GOAL-004: Filter Goals by Priority

| Field | Value |
|-------|-------|
| Test ID | TC-GOAL-004 |
| Description | Filter goals by priority |
| Preconditions | Goals exist with different priorities |
| Steps | 1. Navigate to Goals page |
| | 2. Click priority filter |
| Expected Result | Correct goals displayed |
| Pass Criteria | Filter works correctly |

---

### 3.4 Dashboard Tests

#### TC-DB-001: Dashboard Statistics

| Field | Value |
|-------|-------|
| Test ID | TC-DB-001 |
| Description | Verify dashboard shows correct statistics |
| Preconditions | Data exists in database |
| Steps | 1. Navigate to Dashboard |
| Expected Result | Dashboard shows counts |
| Pass Criteria | Total, Active, Pending, Overdue counts correct |

#### TC-DB-002: Recent Activities

| Field | Value |
|-------|-------|
| Test ID | TC-DB-002 |
| Description | Verify recent activities display |
| Preconditions | Activities logged |
| Steps | 1. Navigate to Dashboard |
| | 2. View Recent Activities section |
| Expected Result | Recent activities listed |
| Pass Criteria | Last 5-10 activities shown |

---

### 3.5 Report Tests

#### TC-RP-001: KPI Analysis Report

| Field | Value |
|-------|-------|
| Test ID | TC-RP-001 |
| Description | Generate KPI analysis report |
| Preconditions | KPIs and reviews exist |
| Steps | 1. Navigate to Reports |
| | 2. Select KPI Analysis |
| Expected Result | KPI distribution displayed |
| Pass Criteria | Category breakdown accurate |

#### TC-RP-002: Employee Performance Summary

| Field | Value |
|-------|-------|
| Test ID | TC-RP-002 |
| Description | View employee performance history |
| Preconditions | Employee has reviews |
| Steps | 1. Navigate to Reports |
| | 2. Select Employee Performance |
| | 3. Choose employee |
| Expected Result | History displayed with average score |
| Pass Criteria | Averages calculated correctly |

#### TC-RP-003: Goal Tracking Report

| Field | Value |
|-------|-------|
| Test ID | TC-RP-003 |
| Description | View goal completion report |
| Preconditions | Goals exist |
| Steps | 1. Navigate to Reports |
| | 2. Select Goal Tracking |
| Expected Result | Completion rates displayed |
| Pass Criteria | Counts accurate |

---

### 3.6 360-Degree Feedback Tests

#### TC-FB-001: Add Feedback

| Field | Value |
|-------|-------|
| Test ID | TC-FB-001 |
| Description | Add feedback from peer/manager |
| Preconditions | Review exists |
| Steps | 1. Open review |
| | 2. Add feedback |
| | 3. Select feedback type (manager/peer/subordinate) |
| | 4. Enter feedback and rating |
| | 5. Save |
| Expected Result | Feedback saved |
| Pass Criteria | Feedback appears in review |

#### TC-FB-002: View Feedback Summary

| Field | Value |
|-------|-------|
| Test ID | TC-FB-002 |
| Description | View aggregated feedback |
| Preconditions | Multiple feedback entries exist |
| Steps | 1. Open review |
| | 2. View feedback section |
| Expected Result | Feedback grouped by type |
| Pass Criteria | Grouping works, summary calculated |

---

### 3.7 Security Tests

#### TC-SC-001: Permission - View KPI

| Field | Value |
|-------|-------|
| Test ID | TC-SC-001 |
| Description | User without permission cannot view KPIs |
| Preconditions | User lacks PERF_VIEW_KPI |
| Steps | 1. User attempts to access KPIs page |
| Expected Result | Access denied error |
| Pass Criteria | Error message displayed |

#### TC-SC-002: Permission - Manage Review

| Field | Value |
|-------|-------|
| Test ID | TC-SC-002 |
| Description | User without permission cannot create reviews |
| Preconditions | User lacks PERF_MANAGE_REVIEW |
| Steps | 1. User attempts to create review |
| Expected Result | Access denied error |
| Pass Criteria | Error message displayed |

---

### 3.8 Integration Tests

#### TC-INT-001: Employee Integration

| Field | Value |
|-------|-------|
| Test ID | TC-INT-001 |
| Description | Employee dropdown populated from FA |
| Preconditions | Employees exist in FA |
| Steps | 1. Navigate to create review/goal |
| | 2. View employee dropdown |
| Expected Result | Employees from FA loaded |
| Pass Criteria | Employee names displayed |

---

## 4. Test Execution

### 4.1 Execution Order

1. Unit tests (via phpunit)
2. Integration tests
3. System tests
4. UAT

### 4.2 Test Results Template

| Test ID | Test Name | Status | Notes |
|---------|-----------|--------|-------|
| TC-KPI-001 | Create New KPI | PASS/FAIL | |
| TC-KPI-002 | View KPI List | PASS/FAIL | |

### 4.3 Defect Reporting

| Field | Description |
|-------|-------------|
| Defect ID | Unique identifier |
| Test ID | Related test case |
| Severity | Critical/Major/Minor |
| Description | Detailed description |
| Steps to Reproduce | Reproduction steps |
| Expected Result | What should happen |
| Actual Result | What actually happened |

---

## 5. Acceptance Criteria

### 5.1 Functional Acceptance

| Requirement ID | Description | Test Coverage |
|----------------|-------------|---------------|
| FR-1.1 | Create KPI | TC-KPI-001 |
| FR-1.2 | View KPIs | TC-KPI-002 |
| FR-1.3 | Edit KPI | TC-KPI-004 |
| FR-1.4 | Delete KPI | TC-KPI-005 |
| FR-2.1 | Create Review | TC-PR-001 |
| FR-2.2 | View Reviews | TC-PR-002 |
| FR-2.4 | Review Scoring | TC-PR-003 |
| FR-2.5 | Submit Review | TC-PR-004 |
| FR-3.1 | Create Goal | TC-GOAL-001 |
| FR-3.2 | View Goals | TC-GOAL-002 |
| FR-4.1 | Dashboard | TC-DB-001 |
| FR-5.1 | Collect Feedback | TC-FB-001 |

### 5.2 Non-Functional Acceptance

| Criteria | Target |
|----------|--------|
| Page Load Time | < 3 seconds |
| Database Queries | < 10 per page |
| Browser Compatibility | Chrome, Firefox, Edge |
| Access Control | All permissions enforced |
| Data Validation | All inputs validated |

---

## 6. Test Deliverables

| Deliverable | Description |
|-------------|-------------|
| Test Cases | This document |
| Test Data | Sample data for testing |
| Test Results | Execution results log |
| Defect Log | Issues found during testing |
| Test Summary | Final pass/fail report |

---

## 7. Test Schedule

| Phase | Duration | Activities |
|-------|----------|-----------|
| Unit Testing | 1 day | phpunit execution |
| Integration Testing | 2 days | Integration tests |
| System Testing | 3 days | End-to-end workflows |
| UAT | 5 days | User acceptance |
| Bug Fixing | Ongoing | Fix and retest |

---

## 8. Risk Management

### 8.1 Test Risks

| Risk | Mitigation |
|------|-------------|
| Test data not available | Create sample data first |
| Environment issues | Use isolated test environment |
| Scope creep | Track changes to requirements |
