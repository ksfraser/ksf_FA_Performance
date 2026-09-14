# FA Performance Module - Access Control Specification

## Document Information

| Field | Value |
|-------|-------|
| Document Title | Access Control Specification |
| Module | ksf_FA_Performance |
| Version | 1.0.0 |
| Author | KSF Development Team |
| Last Updated | May 2026 |

---

## 1. Access Control Overview

### 1.1 Purpose

This document defines access control rules for ksf_FA_Performance implementing:
- **Employees** see their own performance reviews
- **Managers** see their direct reports' performance data
- **HR Managers** see aggregated performance data
- **HR Admin** has full access to all performance records

### 1.2 Key Principles

| Principle | Description |
|-----------|-------------|
| Self-Service | Employees can view their own reviews |
| Manager View | Managers access team performance data |
| Confidentiality | Rating details restricted to authorized personnel |
| Fair Assessment | Multiple reviewers with weighted scores |

---

## 2. Role Definitions

### 2.1 Performance Module Roles

| Role | Code | Access Level |
|------|------|--------------|
| Employee | `employee` | Own reviews only |
| Manager | `manager` | Own + direct reports' reviews |
| HR Manager | `hr_manager` | All employee reviews + aggregates |
| HR Admin | `hr_admin` | Full access + configuration |
| System Admin | `system_admin` | Unrestricted |

---

## 3. Record-Level Access Rules

### 3.1 Performance Review Records

| Field | Employee | Manager | HR Manager | HR Admin |
|-------|----------|---------|------------|----------|
| Review Period | Read (own) | Read (team) | Read | Read/Write |
| Goals Set | Read (own) | Read/Write (team) | Read | Read/Write |
| Self-Assessment | Read (own) | Read (team) | Read | Read/Write |
| Manager Assessment | Hidden | Read (team) | Read | Read/Write |
| Competency Ratings | Hidden | Read (team) | Read | Read/Write |
| Overall Rating | Hidden | Read (team) | Read | Read/Write |
| Development Plan | Read (own) | Read/Write (team) | Read | Read/Write |
| Salary Recommendation | Hidden | Hidden | Read | Read/Write |

### 3.2 Goal Tracking

| Field | Employee | Manager | HR Manager | HR Admin |
|-------|----------|---------|------------|----------|
| Goal Description | Read/Write (own) | Read | Read | Read/Write |
| Progress Updates | Read (own) | Read (team) | Read | Read |
| Completion Status | Read (own) | Read/Write (team) | Read | Read/Write |
| Due Dates | Read (own) | Read (team) | Read | Read/Write |

---

## 4. Performance Review Workflow

### 4.1 Review Cycle Access

```
Annual Review Cycle:
├── Self-Assessment (Employee) ──▶ Own goals + self-ratings
├── Manager Assessment (Manager) ──▶ Team member ratings
├── Calibration (HR Manager) ──▶ Adjust ratings for consistency
└── Final Approval (HR Admin) ──▶ Approve and publish
```

### 4.2 Access by Workflow Stage

| Stage | Employee | Manager | HR Manager | HR Admin |
|-------|----------|---------|------------|----------|
| Draft | Read (own) | Read/Write (team) | Read | Read/Write |
| Submitted | Hidden | Read (team) | Read | Read/Write |
| In Review | Hidden | Read (team) | Read/Write | Read/Write |
| Calibrated | Hidden | Hidden | Read | Read/Write |
| Published | Read (own) | Read (team) | Read | Read |

---

## 5. Manager Hierarchy

### 5.1 Direct Report Visibility

Managers can only view performance reviews for:
1. Their direct reports (1 level down)
2. Their own review
3. Reviews where they are assigned as reviewer

### 5.2 Multi-Reviewer Access

When a review requires multiple reviewers:
- Each assigned reviewer can view the review
- Reviewers cannot see each other's ratings until final calibration
- HR Manager sees all ratings during calibration

---

## 6. Sensitive Data Handling

### 6.1 Protected Information

| Data | Access Level |
|------|-------------|
| Individual Ratings | Manager+ (team), HR Manager+ (all) |
| Salary Recommendations | HR Manager+ only |
| Promotion Decisions | HR Admin only |
| Potential Ratings | HR Manager+ only |
| 360 Feedback Comments | Hidden from subject, visible to HR |

### 6.2 Aggregation Rules

- Individual ratings never shown in raw form to HR Managers
- Only aggregated team scores shown in dashboards
- Minimum group size of 5 for any reporting

---

## 7. Family Company Considerations

### 7.1 Family Member Reviews

| Scenario | Access |
|----------|--------|
| Family employee as employee | Sees only own review |
| Family employee as manager | Normal manager access to team |
| Review contains family info | Normal access rules apply |

### 7.2 Gift Flag for Bonuses

Performance-based bonuses and rewards can be flagged:
- Default: Visible per normal rules
- With `gift_flag=true`: Only HR Admin can see

---

## 8. WordPress Integration

### 8.1 Employee Self-Service

Via ksf_WP_ESS, employees access:
- View their own published reviews
- Complete self-assessments
- View goals and development plans
- Cannot see others' reviews

---

## 9. Compliance

### 9.1 Audit Requirements

- All review views logged
- All rating changes logged with previous values
- Promotion decisions logged separately

### 9.2 Data Retention

- Review records: 7 years
- Goal history: 3 years
- Audit logs: 5 years

---

## 10. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | May 2026 | KSF Development Team | Initial specification |