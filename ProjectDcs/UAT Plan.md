# UAT Plan - ksf_FA_Performance

## Overview

This document defines the User Acceptance Test (UAT) cases for the Performance Management module. UAT validates that the system meets business requirements and is ready for production deployment.

---

## 1. UAT Objectives

### 1.1 Goals

- Validate business workflows function correctly
- Confirm user requirements are met
- Ensure integration with FA works seamlessly
- Verify data accuracy and integrity
- Obtain sign-off for production deployment

### 1.2 Success Criteria

- All critical test cases pass
- No high-severity defects open
- User acceptance obtained
- Sign-off documented

---

## 2. UAT Scope

### 2.1 In Scope

- KPI CRUD operations
- Performance review management and scoring
- Goal setting and progress tracking
- Dashboard and reporting
- 360-degree feedback collection
- FA integrations (Employee Management)
- Security and permissions

### 2.2 Out of Scope

- Performance stress testing
- Security penetration testing
- Browser compatibility (covered in QA)
- Data migration from legacy systems

---

## 3. UAT User Roles

| Role | Description | Tests Executed |
|------|-------------|----------------|
| HR Manager | Manages KPIs, reviews, and reports | HRM-001 through HRM-010 |
| Team Leader | Manages team goals and reviews | TL-001 through TL-005 |
| Employee | Views own goals and reviews | EMP-001 through EMP-003 |
| Administrator | System configuration | AD-001 through AD-003 |

---

## 4. UAT Test Cases

### 4.1 KPI Management (KPI)

#### UAT-KPI-001: Create New KPI

| Field | Value |
|-------|-------|
| Test Case ID | UAT-KPI-001 |
| Scenario | Create a new KPI as HR Manager |
| Preconditions | User has PERF_MANAGE_KPI permission |
| Test Steps | 1. Login as HR Manager |
| | 2. Navigate to KPIs |
| | 3. Click "New KPI" |
| | 4. Enter: Name = "Sales Target", Description = "Monthly sales target", Category = "Sales", Target = 100000, Weight = 1.5 |
| | 5. Click Save |
| Expected Result | Success message, KPI appears in list |
| Acceptance Criteria | [ ] KPI saved to database |
| | [ ] KPI visible in list with all fields correct |
| | [ ] Activity logged |
| Result | PASS/FAIL |
| Notes | |

#### UAT-KPI-002: Edit KPI Details

| Field | Value |
|-------|-------|
| Test Case ID | UAT-KPI-002 |
| Scenario | Modify KPI details |
| Preconditions | KPI exists from UAT-KPI-001 |
| Test Steps | 1. Edit KPI "Sales Target" |
| | 2. Change weight to 2.0 |
| | 3. Save changes |
| Expected Result | Changes saved successfully |
| Acceptance Criteria | [ ] Weight updated in database |
| | [ ] Activity logged |
| Result | PASS/FAIL |
| Notes | |

#### UAT-KPI-003: Filter KPIs by Category

| Field | Value |
|-------|-------|
| Test Case ID | UAT-KPI-003 |
| Scenario | Filter KPIs by category |
| Preconditions | KPIs exist in different categories |
| Test Steps | 1. Navigate to KPIs |
| | 2. Select category filter |
| Expected Result | Only KPIs in selected category shown |
| Acceptance Criteria | [ ] Correct filtering |
| Result | PASS/FAIL |
| Notes | |

#### UAT-KPI-004: Delete KPI

| Field | Value |
|-------|-------|
| Test Case ID | UAT-KPI-004 |
| Scenario | Delete a KPI |
| Preconditions | Test KPI exists |
| Test Steps | 1. Navigate to KPI edit |
| | 2. Click Delete |
| | 3. Confirm deletion |
| Expected Result | KPI removed from system |
| Acceptance Criteria | [ ] KPI not in list |
| | [ ] Activity logged |
| Result | PASS/FAIL |
| Notes | |

---

### 4.2 Performance Reviews (PR)

#### UAT-PR-001: Create Performance Review

| Field | Value |
|-------|-------|
| Test Case ID | UAT-PR-001 |
| Scenario | Create a new performance review as HR Manager |
| Preconditions | User has PERF_MANAGE_REVIEW permission |
| Test Steps | 1. Login as HR Manager |
| | 2. Navigate to Reviews |
| | 3. Click "New Review" |
| | 4. Select Employee = "John Doe", Reviewer = "Jane Smith" |
| | 5. Select Review Period = "Q1 2026", Review Date = today |
| | 6. Click Save |
| Expected Result | Success message, review appears in list with Draft status |
| Acceptance Criteria | [ ] Review saved to database |
| | [ ] Review visible in list |
| | [ ] Status is "Draft" |
| Result | PASS/FAIL |
| Notes | |

#### UAT-PR-002: Add KPI Scores

| Field | Value |
|-------|-------|
| Test Case ID | UAT-PR-002 |
| Scenario | Score employee on KPIs |
| Preconditions | Review exists from UAT-PR-001, KPIs exist |
| Test Steps | 1. Edit review |
| | 2. Add score for each KPI |
| | 3. Add comments |
| | 4. Save |
| Expected Result | Scores saved, overall score calculated |
| Acceptance Criteria | [ ] Individual scores saved |
| | [ ] Overall score calculated correctly (weighted) |
| Result | PASS/FAIL |
| Notes | |

#### UAT-PR-003: Submit Review

| Field | Value |
|-------|-------|
| Test Case ID | UAT-PR-003 |
| Scenario | Submit completed review |
| Preconditions | Review has scores |
| Test Steps | 1. Edit review |
| | 2. Click Submit |
| Expected Result | Status changes to "Submitted" |
| Acceptance Criteria | [ ] Status updated |
| | [ ] Cannot edit after submit (except admin) |
| Result | PASS/FAIL |
| Notes | |

#### UAT-PR-004: View Reviews by Employee

| Field | Value |
|-------|-------|
| Test Case ID | UAT-PR-004 |
| Scenario | Filter reviews by employee |
| Preconditions | Reviews exist for multiple employees |
| Test Steps | 1. Navigate to Reviews |
| | 2. Select employee filter |
| Expected Result | Only reviews for selected employee shown |
| Acceptance Criteria | [ ] Correct filtering |
| | [ ] Employee name displayed |
| Result | PASS/FAIL |
| Notes | |

---

### 4.3 Goal Management (GM)

#### UAT-GM-001: Create Employee Goal

| Field | Value |
|-------|-------|
| Test Case ID | UAT-GM-001 |
| Scenario | Create goal for employee as Team Leader |
| Preconditions | User has PERF_MANAGE_GOAL permission |
| Test Steps | 1. Login as Team Leader |
| | 2. Navigate to Goals |
| | 3. Click "New Goal" |
| | 4. Select employee |
| | 5. Enter: Title = "Complete Training", Description = "Complete mandatory training", Target Date = end of month, Priority = "High" |
| | 6. Save |
| Expected Result | Goal created with 0% progress |
| Acceptance Criteria | [ ] Goal saved |
| | [ ] Progress defaults to 0% |
| | [ ] Activity logged |
| Result | PASS/FAIL |
| Notes | |

#### UAT-GM-002: Update Goal Progress

| Field | Value |
|-------|-------|
| Test Case ID | UAT-GM-002 |
| Scenario | Update goal completion percentage |
| Preconditions | Goal exists |
| Test Steps | 1. Edit goal |
| | 2. Update progress to 50% |
| | 3. Save |
| Expected Result | Progress updated |
| Acceptance Criteria | [ ] Progress saves correctly |
| | [ ] Progress bar displays |
| | [ ] Status auto-updates |
| Result | PASS/FAIL |
| Notes | |

#### UAT-GM-003: Filter Goals by Status

| Field | Value |
|-------|-------|
| Test Case ID | UAT-GM-003 |
| Scenario | Filter goals by status |
| Preconditions | Goals exist with different statuses |
| Test Steps | 1. Navigate to Goals |
| | 2. Select status filter |
| Expected Result | Correct goals displayed |
| Acceptance Criteria | [ ] Filtering works |
| Result | PASS/FAIL |
| Notes | |

---

### 4.4 Dashboard (DB)

#### UAT-DB-001: View Dashboard Statistics

| Field | Value |
|-------|-------|
| Test Case ID | UAT-DB-001 |
| Scenario | Verify dashboard displays correct counts |
| Preconditions | Test data created in previous tests |
| Test Steps | 1. Navigate to Dashboard |
| | 2. View statistics |
| Expected Result | Dashboard shows counts |
| Acceptance Criteria | [ ] KPI counts match |
| | [ ] Review counts match |
| | [ ] Goal counts match |
| Result | PASS/FAIL |
| Notes | |

#### UAT-DB-002: View Recent Activities

| Field | Value |
|-------|-------|
| Test Case ID | UAT-DB-002 |
| Scenario | Verify activity log displays |
| Preconditions | Activities performed in previous tests |
| Test Steps | 1. Navigate to Dashboard |
| | 2. View Recent Activities section |
| Expected Result | Activities listed |
| Acceptance Criteria | [ ] Activities chronologically ordered |
| | [ ] Action and details shown |
| Result | PASS/FAIL |
| Notes | |

---

### 4.5 Reports (RP)

#### UAT-RP-001: Generate KPI Analysis Report

| Field | Value |
|-------|-------|
| Test Case ID | UAT-RP-001 |
| Scenario | View KPI analysis |
| Preconditions | KPIs and reviews exist |
| Test Steps | 1. Navigate to Reports |
| | 2. Select KPI Analysis |
| Expected Result | Report displays with breakdown |
| Acceptance Criteria | [ ] Category distribution shown |
| | [ ] Data accurate |
| Result | PASS/FAIL |
| Notes | |

#### UAT-RP-002: Generate Employee Performance Summary

| Field | Value |
|-------|-------|
| Test Case ID | UAT-RP-002 |
| Scenario | View employee performance history |
| Preconditions | Employee has completed reviews |
| Test Steps | 1. Navigate to Reports |
| | 2. Select Employee Performance |
| | 3. Choose employee |
| Expected Result | Summary displayed |
| Acceptance Criteria | [ ] Review history shown |
| | [ ] Average score calculated |
| | [ ] Goal completion rate shown |
| Result | PASS/FAIL |
| Notes | |

---

### 4.6 360-Degree Feedback (FB)

#### UAT-FB-001: Add Peer Feedback

| Field | Value |
|-------|-------|
| Test Case ID | UAT-FB-001 |
| Scenario | Add feedback as peer |
| Preconditions | Review exists |
| Test Steps | 1. Open review |
| | 2. Click "Add Feedback" |
| | 3. Select feedback type = "Peer" |
| | 4. Enter feedback text |
| | 5. Add rating |
| | 6. Save |
| Expected Result | Feedback saved |
| Acceptance Criteria | [ ] Feedback appears in review |
| | [ ] Feedback type shown |
| Result | PASS/FAIL |
| Notes | |

#### UAT-FB-002: View Feedback Summary

| Field | Value |
|-------|-------|
| Test Case ID | UAT-FB-002 |
| Scenario | View aggregated feedback |
| Preconditions | Multiple feedback entries exist |
| Test Steps | 1. Open review |
| | 2. View feedback section |
| Expected Result | Feedback grouped by type |
| Acceptance Criteria | [ ] Grouping works |
| | [ ] Summary visible |
| Result | PASS/FAIL |
| Notes | |

---

### 4.7 Security (SC)

#### UAT-SC-001: Permission - View KPIs

| Field | Value |
|-------|-------|
| Test Case ID | UAT-SC-001 |
| Scenario | Access denied without permission |
| Preconditions | User without PERF_VIEW_KPI |
| Test Steps | 1. User attempts to access KPIs page |
| Expected Result | Access denied message |
| Acceptance Criteria | [ ] Error message shown |
| | [ ] No data displayed |
| Result | PASS/FAIL |
| Notes | |

#### UAT-SC-002: Permission - Manage Reviews

| Field | Value |
|-------|-------|
| Test Case ID | UAT-SC-002 |
| Scenario | Create denied without permission |
| Preconditions | User without PERF_MANAGE_REVIEW |
| Test Steps | 1. User attempts to create review |
| Expected Result | Access denied message |
| Acceptance Criteria | [ ] Error message shown |
| | [ ] Review not created |
| Result | PASS/FAIL |
| Notes | |

---

### 4.8 Integration (INT)

#### UAT-INT-001: Employee Dropdown Populated

| Field | Value |
|-------|-------|
| Test Case ID | UAT-INT-001 |
| Scenario | Verify FA employees in dropdown |
| Preconditions | Employees exist in FA |
| Test Steps | 1. Navigate to create review/goal |
| | 2. View employee dropdown |
| Expected Result | Employees from FA displayed |
| Acceptance Criteria | [ ] Employee names shown |
| | [ ] Can select employee |
| Result | PASS/FAIL |
| Notes | |

#### UAT-INT-002: Employee Data Display

| Field | Value |
|-------|-------|
| Test Case ID | UAT-INT-002 |
| Scenario | Verify employee data from FA |
| Preconditions | Employees exist |
| Test Steps | 1. View review/goal details |
| | 2. Check employee field |
| Expected Result | Employee data displayed |
| Acceptance Criteria | [ ] Name shown correctly |
| Result | PASS/FAIL |
| Notes | |

---

### 4.9 Employee Self-Service (EMP)

#### UAT-EMP-001: View Own Goals

| Field | Value |
|-------|-------|
| Test Case ID | UAT-EMP-001 |
| Scenario | Employee views own goals |
| Preconditions | Employee has goals assigned |
| Test Steps | 1. Login as employee |
| | 2. Navigate to Goals |
| Expected Result | Only own goals shown |
| Acceptance Criteria | [ ] Only user's goals visible |
| | [ ] Can view goal details |
| Result | PASS/FAIL |
| Notes | |

#### UAT-EMP-002: View Own Performance Review

| Field | Value |
|-------|-------|
| Test Case ID | UAT-EMP-002 |
| Scenario | Employee views own completed review |
| Preconditions | Employee has completed review |
| Test Steps | 1. Login as employee |
| | 2. Navigate to Reviews |
| | 3. Select own review |
| Expected Result | Review details displayed |
| Acceptance Criteria | [ ] Can view submitted reviews |
| | [ ] Scores visible |
| Result | PASS/FAIL |
| Notes | |

---

## 5. UAT Execution

### 5.1 Execution Checklist

- [ ] All test cases reviewed
- [ ] Test environment ready
- [ ] Test data loaded
- [ ] Test users configured
- [ ] Test cases executed
- [ ] Results documented
- [ ] Defects logged

### 5.2 Sign-off

| Role | Name | Date | Signature |
|------|------|------|----------|
| HR Manager | | | |
| QA Lead | | | |
| Development Lead | | | |

---

## 6. Test Results Summary

### 6.1 Results Summary

| Category | Total | Passed | Failed | Pass Rate |
|----------|-------|--------|--------|----------|
| KPI Management | 4 | | | |
| Performance Reviews | 4 | | | |
| Goal Management | 3 | | | |
| Dashboard | 2 | | | |
| Reports | 2 | | | |
| 360-Degree Feedback | 2 | | | |
| Security | 2 | | | |
| Integration | 2 | | | |
| Employee Self-Service | 2 | | | |
| **TOTAL** | **23** | | | |

### 6.2 Defects Found

| Defect ID | Test Case | Severity | Description | Status |
|-----------|----------|----------|-------------|--------|
| | | | | |

---

## 7. UAT Completion

### 7.1 Completion Criteria

- [ ] All critical test cases pass
- [ ] No high-severity defects open
- [ ] All test data cleaned up
- [ ] Sign-off obtained

### 7.2 Final Sign-off

This module is approved for production deployment.

| Role | Name | Date | Signature |
|------|------|------|----------|
| Business Owner | | | |
| HR Manager | | | |
| QA Lead | | | |
