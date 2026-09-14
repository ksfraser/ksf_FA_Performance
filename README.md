# ksf_FA_Performance

Performance Management module for FrontAccounting CRM.

## Overview

ksf_FA_Performance is a FrontAccounting extension module that provides comprehensive performance management functionality for tracking employee KPIs, performance reviews, goals, and evaluations within the FA ecosystem.

## Features

### Core Features
- **KPI Management** - Define and track Key Performance Indicators
- **Performance Reviews** - Conduct periodic employee performance reviews
- **Goal Setting** - Set individual and team goals with milestones
- **Performance Scoring** - Score employees on various performance dimensions
- **Performance Reports** - Generate performance analytics and trends
- **Goal Tracking** - Track progress towards organizational objectives
- **360-Degree Feedback** - Collect feedback from peers, managers, and subordinates

### Integration Features
- **FA Employee Integration** - Sync with FA Employee Management
- **FA CRM Integration** - Link performance to customer outcomes
- **Dashboard View** - Real-time performance metrics dashboard
- **Activity Logging** - Complete audit trail of all performance activities

## Quick Start

### Installation

1. Copy the module to your FrontAccounting modules directory:
   ```
   /modules/ksf_FA_Performance
   ```

2. Login to FrontAccounting as administrator

3. Navigate to: **Setup > Modules Management**

4. Activate the Performance module

5. The module will create necessary database tables automatically

### Configuration

After activation, configure the module:

1. Navigate to: **Performance > Settings**
2. Set up review periods (monthly, quarterly, annually)
3. Configure KPI categories
4. Set up performance rating scales
5. Define review workflow

### First Time Setup

1. Define KPI categories relevant to your organization
2. Create performance templates
3. Set up employee review cycles
4. Configure notification preferences

## Database Tables

The module creates the following database tables:

### Main Tables

| Table | Description |
|-------|-------------|
| `fa_perf_kpis` | KPI definitions and metrics |
| `fa_perf_reviews` | Performance review records |
| `fa_perf_goals` | Goal definitions and tracking |
| `fa_perf_scores` | Individual performance scores |
| `fa_perf_feedback` | 360-degree feedback records |

### Support Tables

| Table | Description |
|-------|-------------|
| `fa_perf_kpi_categories` | KPI category definitions |
| `fa_perf_review_templates` | Review form templates |
| `fa_perf_rating_scales` | Rating scale definitions |
| `fa_perf_activity_log` | Activity audit trail |

### Table Schema

#### fa_perf_kpis
```sql
CREATE TABLE `@TB_PREF@fa_perf_kpis` (
    `kpi_id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `description` TEXT,
    `category_id` INT(11) DEFAULT NULL,
    `target_value` DECIMAL(10,2) DEFAULT 0.00,
    `weight` DECIMAL(5,2) DEFAULT 1.00,
    `measurement_unit` VARCHAR(20) DEFAULT NULL,
    `inactive` TINYINT(1) DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`kpi_id`),
    KEY `idx_category` (`category_id`),
    KEY `idx_inactive` (`inactive`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

#### fa_perf_reviews
```sql
CREATE TABLE `@TB_PREF@fa_perf_reviews` (
    `review_id` INT(11) NOT NULL AUTO_INCREMENT,
    `employee_id` VARCHAR(100) NOT NULL,
    `reviewer_id` VARCHAR(100) NOT NULL,
    `review_period` VARCHAR(20) NOT NULL,
    `review_date` DATE NOT NULL,
    `status` VARCHAR(20) DEFAULT 'Draft',
    `overall_score` DECIMAL(5,2) DEFAULT 0.00,
    `comments` TEXT,
    `strengths` TEXT,
    `areas_for_improvement` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`review_id`),
    KEY `idx_employee` (`employee_id`),
    KEY `idx_reviewer` (`reviewer_id`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

#### fa_perf_goals
```sql
CREATE TABLE `@TB_PREF@fa_perf_goals` (
    `goal_id` INT(11) NOT NULL AUTO_INCREMENT,
    `employee_id` VARCHAR(100) NOT NULL,
    `title` VARCHAR(200) NOT NULL,
    `description` TEXT,
    `category` VARCHAR(50) DEFAULT NULL,
    `target_date` DATE DEFAULT NULL,
    `progress` DECIMAL(5,2) DEFAULT 0.00,
    `status` VARCHAR(30) DEFAULT 'Not Started',
    `priority` VARCHAR(20) DEFAULT 'Medium',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`goal_id`),
    KEY `idx_employee` (`employee_id`),
    KEY `idx_status` (`status`),
    KEY `idx_priority` (`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

#### fa_perf_scores
```sql
CREATE TABLE `@TB_PREF@fa_perf_scores` (
    `score_id` INT(11) NOT NULL AUTO_INCREMENT,
    `review_id` INT(11) NOT NULL,
    `kpi_id` INT(11) NOT NULL,
    `score` DECIMAL(5,2) DEFAULT 0.00,
    `max_score` DECIMAL(5,2) DEFAULT 5.00,
    `comments` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`score_id`),
    KEY `idx_review` (`review_id`),
    KEY `idx_kpi` (`kpi_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

#### fa_perf_feedback
```sql
CREATE TABLE `@TB_PREF@fa_perf_feedback` (
    `feedback_id` INT(11) NOT NULL AUTO_INCREMENT,
    `review_id` INT(11) NOT NULL,
    `feedback_from` VARCHAR(100) NOT NULL,
    `feedback_type` VARCHAR(20) NOT NULL,
    `relationship` VARCHAR(30) DEFAULT NULL,
    `feedback_text` TEXT,
    `rating` DECIMAL(3,2) DEFAULT 0.00,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`feedback_id`),
    KEY `idx_review` (`review_id`),
    KEY `idx_feedback_from` (`feedback_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

#### fa_perf_activity_log
```sql
CREATE TABLE `@TB_PREF@fa_perf_activity_log` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `activity_type` VARCHAR(30) NOT NULL,
    `entity_type` VARCHAR(30) NOT NULL,
    `entity_id` INT(11) NOT NULL,
    `user_id` VARCHAR(100) DEFAULT NULL,
    `action` VARCHAR(50) NOT NULL,
    `details` TEXT,
    `ip_address` VARCHAR(45) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_entity` (`entity_type`, `entity_id`),
    KEY `idx_user` (`user_id`),
    KEY `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## Permissions

The module defines the following permissions:

| Permission | Code | Description |
|------------|------|-------------|
| View KPIs | PERF_VIEW_KPI | View KPI definitions |
| Manage KPIs | PERF_MANAGE_KPI | Create/edit/delete KPIs |
| View Reviews | PERF_VIEW_REVIEW | View performance reviews |
| Manage Reviews | PERF_MANAGE_REVIEW | Create/conduct reviews |
| View Goals | PERF_VIEW_GOAL | View employee goals |
| Manage Goals | PERF_MANAGE_GOAL | Create/edit goals |
| View Reports | PERF_VIEW_REPORTS | View performance reports |
| Admin | PERF_ADMIN | Full administrator access |

### Setting Up Permissions

1. Go to **Setup > Users > Roles**
2. Create or edit a role
3. Assign Performance module permissions
4. Save and assign role to users

## API

### Available Pages

The module provides the following pages:

| Page | Path | Description |
|------|------|-------------|
| Dashboard | `/perf/index.php` | Performance dashboard |
| KPIs | `/perf/kpis.php` | KPI management |
| Reviews | `/perf/reviews.php` | Performance reviews |
| Goals | `/perf/goals.php` | Goal tracking |
| Reports | `/perf/reports.php` | Performance reports |
| Settings | `/perf/settings.php` | Configuration |

### Database Functions

Key database functions in `perf_db.inc`:

```php
// KPI Functions
get_perf_kpis($category = null, $inactive = false)
get_perf_kpi($kpiId)
insert_perf_kpi($data)
update_perf_kpi($kpiId, $data)
delete_perf_kpi($kpiId)

// Review Functions
get_perf_reviews($employeeId = null, $status = null)
get_perf_review($reviewId)
insert_perf_review($data)
update_perf_review($reviewId, $data)
delete_perf_review($reviewId)

// Goal Functions
get_perf_goals($employeeId = null, $status = null)
get_perf_goal($goalId)
insert_perf_goal($data)
update_perf_goal($goalId, $data)
delete_perf_goal($goalId)

// Score Functions
get_perf_scores($reviewId)
insert_perf_score($data)
update_perf_score($scoreId, $data)

// Activity Functions
log_perf_activity($data)
get_perf_recent_activities($limit = 10)
```

### UI Functions

Key UI functions in `perf_ui.inc`:

```php
// Navigation
perf_navigation_menu()

// Display
display_perf_dashboard($stats)
display_perf_stat_cell($label, $value, $type)

// Select Helpers
sel_kpi_category($selected)
sel_review_status($selected)
sel_goal_status($selected)
sel_rating_scale($selected)
sel_employee($selected)

// Status Helpers
get_perf_status_class($status)
get_perf_priority_class($priority)
get_perf_score_color($score)
```

## Module Structure

```
ksf_FA_Performance/
├── FA_Perf_Module.php        # Module class with permissions
├── hooks.php                 # FA lifecycle hooks
├── perf.php                  # API controller
├── composer.json             # Composer metadata
├── _init/
│   └── init.inc             # Module initialization
├── includes/
│   ├── PerfContainer.php    # DI container & services
│   ├── perf_db.inc          # Database functions
│   └── perf_ui.inc          # UI helpers
├── pages/
│   ├── index.php            # Dashboard
│   ├── kpis.php             # KPI management
│   ├── reviews.php          # Performance reviews
│   ├── goals.php            # Goal tracking
│   ├── reports.php          # Reporting
│   └── settings.php         # Settings
├── sql/
│   ├── install.sql         # Schema creation
│   └── uninstall.sql        # Schema removal
└── ProjectDcs/
    ├── Business Requirements.md
    ├── Functional Requirements.md
    ├── Architecture.md
    ├── Test Plan.md
    └── UAT Plan.md
```

## Requirements

- FrontAccounting 2.4.0 or higher
- PHP 8.0 or higher
- MySQL 5.7 or higher

## License

This module is part of the ksf suite for FrontAccounting.
See LICENSE file for details.

## Support

For issues and questions:
- Check the ProjectDcs documentation
- Review FrontAccounting forums

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | Current | Initial release |

---

For detailed technical information, see the ProjectDcs documentation.
