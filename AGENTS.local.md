<!-- Repo-specific appendix to the shared AGENTS.md. Generic conventions live in AGENTS_ARCH.md (hardlinked). -->

```markdown
# AGENTS.local.md — ksf_FA_Performance
## Overview
**FA Module** for OKR (Objectives and Key Results) style performance management, similar to OpenProject's approach. Integrates with Project Management module for execution tracking.
## Repository Structure
```
ksf_FA_Performance/
├── sql/
│   ├── fa_performance_goals.sql        # OKR goals (Objective, Key Result, Task)
│   ├── fa_performance_reviews.sql      # Performance reviews
│   ├── fa_performance_review_goals.sql # Review-goal linkage
│   ├── fa_performance_checkins.sql     # Regular OKR check-ins
│   ├── fa_pm_versions.sql              # Quarters (Q1-2026, etc.)
│   └── fa_pm_task_progress.sql         # OpenProject-style progress tracking
├── includes/
│   ├── performance_goals_db.inc
│   ├── performance_reviews_db.inc
│   ├── performance_checkins_db.inc
│   ├── pm_versions_db.inc
│   └── ...
├── pages/
├── hooks.php
├── composer.json
└── ProjectDocs/
    ├── Requirements.md
    ├── RTM.md
    ├── BABOK.md
    └── UML.md
```
## OKR Hierarchy
```
Strategic Initiative (Top Level)
    └── Objective (Linked to employee)
            └── Key Result (Measurable outcome)
                        └── Task (Linked to fa_pm_tasks)
```
## Documentation (UML/BABOK)
```php
/**
 * Write OKR goal (Objective/Key Result/Task)
 *
 * @param int $goal_id Goal ID (0 for new)
 * @param array $data Goal data with goal_type, parent_goal_id, etc.
 * @return int Goal ID
 *
 * @UML Note: See ProjectDocs/UML.md - OKR Hierarchy class diagram
 * @BABOK Related: BR-008 Performance Management (OKR)
 */
function write_performance_goal($goal_id, $data) { ... }
```
## Design Patterns Used
### Composite Pattern (OKR Hierarchy)
- Goals can have parent-child relationships
- `parent_goal_id` links to `goal_id` (self-referencing)
### Strategy Pattern
- Progress calculation: work-based vs status-based (OpenProject-style)
- `fa_pm_task_progress` table supports both modes
### Hook Pattern (FA Native)
- Uses FA's `update_databases()` for multi-SQL file handling
## Composer/Packagist
```json
{
    "name": "ksfraser/ksf_fa_performance",
    "description": "Performance Management for FrontAccounting (OKR-style)",
    "type": "frontaccounting-module",
    "require": {
        "php": ">=7.3",
        "ksfraser/ksf_fa_crm": "*",
        "ksfraser/ksf_fa_projectmanagement": "*",
        "ksfraser/ksf_fa_performance_core": "*"
    },
    "autoload": {
        "psr-4": {
            "Ksf\\FA\\Performance\\": "src/"
        }
    }
}
```
## RTM (Requirements Traceability Matrix)
See `ProjectDocs/RTM.md` for full traceability:
| Req ID | Description | Test Case | Code File | Version |
|--------|-------------|-----------|----------|---------|
| REQ-001 | OKR Goals Hierarchy | testGoalHierarchy | sql/fa_performance_goals.sql | v1.0.0 |
| REQ-002 | Performance Reviews | testReviewCreation | sql/fa_performance_reviews.sql | v1.0.0 |
| REQ-003 | Quarterly Check-ins | testCheckinCreation | sql/fa_performance_checkins.sql | v1.1.0 |
| REQ-004 | Progress Tracking | testProgressCalc | sql/fa_pm_task_progress.sql | v1.2.0 |
## BABOK Alignment
See `ProjectDocs/BABOK.md` for business analysis alignment:
- **BR-008**: Performance Management - OKR framework (Objectives/Key Results)
- **BR-009**: Review Process - Quarterly/Annual performance reviews
- **BR-010**: Goal Alignment - Link goals to PM projects/tasks
- **BR-011**: Progress Tracking - OpenProject-style work-based/status-based
## UML Documentation
See `ProjectDocs/UML.md` for:
- OKR Hierarchy class diagram
- Check-in sequence diagram
- Progress tracking state diagram
### Example: OKR Check-in Sequence
```
Manager -> Performance: Create Check-in
Performance -> DB: Insert fa_performance_checkins
Performance -> Goal: Update progress
Performance -> DB: Update fa_performance_goals.progress
Performance -> Manager: Display updated progress
```
## Dependencies
- **ksf_FA_Performance_Core** (business logic - framework-agnostic)
- **ksf_FA_CRM** (employee contacts)
- **ksf_FA_ProjectManagement** (project/task linkage)
- **FrontAccounting 2.4+** (FA core)
```
