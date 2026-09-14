# Architecture - ksf_FA_Performance

## Overview

This document describes the technical architecture for the Performance Management module, including the layered architecture, component design, database schema, and integration patterns.

---

## 1. System Architecture

### 1.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                      │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │
│  │Dashboard │ │  KPIs   │ │ Reviews  │ │  Goals  │   │
│  │   Page   │ │  Page   │ │  Page   │ │  Page   │   │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘   │
│       │           │           │           │           │         │
│       └───────────┴───────────┴───────────┘           │
│                         │                             │
├─────────────────────────┼─────────────────────────────┤
│                    Service Layer                      │
│  ┌──────────────────────────────────────────────────┐  │
│  │                perf_db.inc                       │  │
│  │   Database functions (CRUD operations)          │  │
│  └──────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────┐  │
│  │                perf_ui.inc                       │  │
│  │   UI helper functions and display logic          │  │
│  └──────────────────────────────────────────────────┘  │
├──────────────────────────────────────────────────────────┤
│                    Business Layer                       │
│  ┌──────────────────────────────────────────────────┐  │
│  │              PerfContainer (DI Container)         │  │
│  │   - PerformanceService                           │  │
│  │   - EmployeeService                              │  │
│  │   - DatabaseAdapter                             │  │
│  └──────────────────────────────────────────────────┘  │
├──────────────────────────────────────────────────────────┤
│                    Data Layer                          │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐│
│  │  KPIs    │ │ Reviews  │ │  Goals   │ │ Scores   ││
│  │  Table   │ │  Table   │ │  Table   │ │  Table   ││
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘│
├──────────────────────────────────────────────────────────┤
│                  Integration Layer                      │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐              │
│  │FA HRM    │ │Employee │ │ksf-PM   │              │
│  │(Employee)│ │  Mgmt   │ │ Library  │              │
│  └──────────┘ └──────────┘ └──────────┘              │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Module Structure

```
ksf_FA_Performance/
├── FA_Perf_Module.php        # Module class with permissions
├── hooks.php                 # FA lifecycle hooks
├── perf.php                 # API controller
├── _init/
│   └── init.inc            # Module initialization
├── includes/
│   ├── PerfContainer.php   # DI container & services
│   ├── perf_db.inc         # Database functions
│   └── perf_ui.inc         # UI helpers
├── pages/
│   ├── index.php           # Dashboard
│   ├── kpis.php           # KPI CRUD
│   ├── reviews.php        # Review CRUD
│   ├── goals.php          # Goal CRUD
│   ├── reports.php        # Reporting
│   ├── settings.php       # Settings
│   └── feedback.php       # 360-degree feedback
└── sql/
    ├── install.sql        # Schema creation
    └── uninstall.sql       # Schema removal
```

---

## 2. Component Design

### 2.1 Core Components

#### PerfContainer
The DI container provides service instantiation and dependency management.

**Purpose**: Central service locator implementing PSR-11 ContainerInterface

**Services Provided**:
- `DatabaseAdapterInterface` - FADatabaseAdapter
- `EmployeeServiceInterface` - FAEmployeeService
- `PerformanceServiceInterface` / `PerformanceService` - Core business logic
- `EventDispatcherInterface` - FAEventDispatcher (PSR-14)
- `LoggerInterface` - NullLogger (PSR-3)

**Responsibilities**:
- Service instantiation on demand
- Dependency injection into services
- Service lifecycle management

```php
class PerfContainer implements ContainerInterface
{
    public function get(string $id): mixed
    public function has(string $id): bool
}
```

#### FADatabaseAdapter
Wraps FA database functions for use by services.

**Methods**:
```php
interface DatabaseAdapterInterface
{
    public function fetchAssoc(string $sql, array $params = []): ?array
    public function fetchAll(string $sql, array $params = []): array
    public function executeUpdate(string $sql, array $params = []): int
    public function lastInsertId(): string|false
}
```

#### FAEmployeeService
Provides employee data access.

**Methods**:
```php
interface EmployeeServiceInterface
{
    public function getEmployee(string $employeeId): array
    public function employeeExists(string $employeeId): bool
    public function getEmployeesByDepartment(string $department): array
    public function getAllEmployees(): array
}
```

#### PerformanceService
Provides performance-specific business logic.

**Methods**:
```php
interface PerformanceServiceInterface
{
    public function calculateOverallScore(int $reviewId): float
    public function getEmployeePerformanceHistory(string $employeeId): array
    public function getGoalCompletionRate(string $employeeId): float
    public function getKPIAchievementRate(): array
}
```

### 2.2 Database Functions (perf_db.inc)

Provides procedural database operations for CRUD.

#### KPI Functions
- `get_perf_kpis($category, $inactive)` - List KPIs with filtering
- `get_perf_kpi($kpiId)` - Get single KPI
- `get_perf_kpi_categories()` - List categories
- `insert_perf_kpi($data)` - Create KPI
- `update_perf_kpi($kpiId, $data)` - Update KPI
- `delete_perf_kpi($kpiId)` - Delete KPI

#### Review Functions
- `get_perf_reviews($employeeId, $status)` - List reviews
- `get_perf_review($reviewId)` - Get single review
- `get_perf_reviews_by_reviewer($reviewerId)` - Get reviews by reviewer
- `insert_perf_review($data)` - Create review
- `update_perf_review($reviewId, $data)` - Update review
- `delete_perf_review($reviewId)` - Delete review

#### Score Functions
- `get_perf_scores($reviewId)` - List scores for review
- `get_perf_score($scoreId)` - Get single score
- `insert_perf_score($data)` - Create score
- `update_perf_score($scoreId, $data)` - Update score
- `delete_perf_scores_by_review($reviewId)` - Delete scores for review

#### Goal Functions
- `get_perf_goals($employeeId, $status)` - List goals
- `get_perf_goal($goalId)` - Get single goal
- `get_perf_goal_count($status)` - Count by status
- `get_perf_overdue_goal_count()` - Count overdue goals
- `insert_perf_goal($data)` - Create goal
- `update_perf_goal($goalId, $data)` - Update goal
- `delete_perf_goal($goalId)` - Delete goal

#### Feedback Functions
- `get_perf_feedback($reviewId)` - Get feedback for review
- `insert_perf_feedback($data)` - Create feedback
- `delete_perf_feedback($feedbackId)` - Delete feedback

#### Activity Functions
- `log_perf_activity($data)` - Log activity
- `get_perf_recent_activities($limit)` - Get activity log

### 2.3 UI Functions (perf_ui.inc)

Provides presentation logic and helpers.

#### Navigation
- `perf_navigation_menu()` - Main menu tabs

#### Display
- `display_perf_dashboard_stats($stats)` - Dashboard statistics
- `display_perf_stat_cell($label, $value, $type)` - Stat cell with icon
- `display_perf_recent_activities()` - Recent activity list
- `display_perf_progress_bar($progress)` - Progress bar

#### Select Helpers
- `sel_kpi_category($selected)` - KPI category dropdown
- `sel_review_status($selected)` - Review status dropdown
- `sel_goal_status($selected)` - Goal status dropdown
- `sel_goal_priority($selected)` - Priority dropdown
- `sel_rating_scale($selected)` - Rating scale dropdown
- `sel_employee($selected)` - Employee dropdown
- `sel_feedback_type($selected)` - Feedback type dropdown

#### Status Helpers
- `get_perf_status_class($status)` - CSS class for status
- `get_perf_priority_class($priority)` - CSS class for priority
- `get_perf_score_color($score)` - Color based on score

---

## 3. Database Schema

### 3.1 Entity Relationship Diagram

```
┌─────────────────┐       ┌─────────────────┐
│    employees    │       │      kpi        │
│   (FA HRM)     │       │    categories    │
└────────┬────────┘       └────────┬────────┘
         │                         │
         │ 1:N                     │ 1:N
         ▼                         ▼
┌─────────────────────────────────────────────────┐
│                fa_perf_kpis                     │
│ ┌────────────────────────────────────────────┐ │
│ │ kpi_id (PK)                                 │ │
│ │ name                                         │ │
│ │ description                                  │ │
│ │ category_id (FK) ───────────► kpi_categories│ │
│ │ target_value                                 │ │
│ │ weight                                       │ │
│ │ measurement_unit                             │ │
│ │ inactive                                     │ │
│ └────────────────────────────────────────────┘ │
└──────────────────────────┬──────────────────────┘
                          │
                          │ 1:N
                          ▼
┌─────────────────────────────────────────────────┐
│             fa_perf_scores                     │
│ ┌────────────────────────────────────────────┐ │
│ │ score_id (PK)                              │ │
│ │ review_id (FK) ────────────► fa_perf_reviews│
│ │ kpi_id (FK) ──────────────► fa_perf_kpis   │ │
│ │ score                                       │ │
│ │ max_score                                   │ │
│ │ comments                                    │ │
│ └────────────────────────────────────────────┘ │
└──────────────────────────┬──────────────────────┘
                          │
                          │ N:1
                          ▼
┌─────────────────────────────────────────────────┐
│             fa_perf_reviews                    │
│ ┌────────────────────────────────────────────┐ │
│ │ review_id (PK)                             │ │
│ │ employee_id (FK) ─────────► employees      │ │
│ │ reviewer_id (FK) ─────────► employees      │ │
│ │ review_period                               │ │
│ │ review_date                                 │ │
│ │ status                                      │ │
│ │ overall_score                               │ │
│ │ comments                                    │ │
│ │ strengths                                   │ │
│ │ areas_for_improvement                       │ │
│ └────────────────────────────────────────────┘ │
└──────────────────────────┬──────────────────────┘
                          │
                          │ 1:N
                          ▼
┌─────────────────────────────────────────────────┐
│           fa_perf_feedback                     │
│ ┌────────────────────────────────────────────┐ │
│ │ feedback_id (PK)                           │ │
│ │ review_id (FK) ────────────► fa_perf_reviews│
│ │ feedback_from (FK) ───────► employees      │ │
│ │ feedback_type                               │ │
│ │ relationship                                │ │
│ │ feedback_text                               │ │
│ │ rating                                      │ │
│ └────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│              fa_perf_goals                     │
│ ┌────────────────────────────────────────────┐ │
│ │ goal_id (PK)                               │ │
│ │ employee_id (FK) ─────────► employees      │ │
│ │ title                                       │ │
│ │ description                                 │ │
│ │ category                                    │ │
│ │ target_date                                 │ │
│ │ progress                                    │ │
│ │ status                                      │ │
│ │ priority                                    │ │
│ └────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────┘
```

### 3.2 Table Details

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

#### fa_perf_kpi_categories
```sql
CREATE TABLE `@TB_PREF@fa_perf_kpi_categories` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    `inactive` TINYINT(1) DEFAULT 0,
    `sort_order` INT(11) DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_sort` (`sort_order`)
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

#### fa_perf_review_templates
```sql
CREATE TABLE `@TB_PREF@fa_perf_review_templates` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `description` TEXT,
    `kpi_ids` TEXT,
    `questions` TEXT,
    `default_max_score` DECIMAL(5,2) DEFAULT 5.00,
    `inactive` TINYINT(1) DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_inactive` (`inactive`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

#### fa_perf_rating_scales
```sql
CREATE TABLE `@TB_PREF@fa_perf_rating_scales` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `min_value` DECIMAL(3,2) NOT NULL,
    `max_value` DECIMAL(3,2) NOT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    `sort_order` INT(11) DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_sort` (`sort_order`)
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

---

## 4. Integration Patterns

### 4.1 FA Integration

The module integrates with FrontAccounting core:

#### Database Integration
- Uses FA's `db_query()`, `db_fetch_assoc()`, etc.
- Uses `TB_PREF` for table prefix
- Uses `TB_PREF . "employee"` for employees

#### Session Integration
- Uses `$session->check_access()` for permission checks
- Defines permissions in `FA_Perf_Module.php`

#### UI Integration
- Uses FA's `page()`, `start_table()`, `end_table()`
- Uses FA's form helpers

### 4.2 Service Integration

The module provides services for external consumption:

```php
// Using the DI container
$container = new PerfContainer();
$performanceService = $container->get(PerformanceServiceInterface::class);
```

### 4.3 Event Integration

PSR-14 event dispatcher for decoupled operations:

```php
$dispatcher = $container->get(EventDispatcherInterface::class);
$dispatcher->dispatch(new ReviewCreatedEvent($reviewId));
```

---

## 5. Security Architecture

### 5.1 Permission Model

Defined in FA_Perf_Module.php:

| Permission | Description |
|------------|-------------|
| PERF_VIEW_KPI | View KPI list |
| PERF_MANAGE_KPI | Create/edit/delete KPIs |
| PERF_VIEW_REVIEW | View performance reviews |
| PERF_MANAGE_REVIEW | Create/edit/delete reviews |
| PERF_VIEW_GOAL | View employee goals |
| PERF_MANAGE_GOAL | Create/edit/delete goals |
| PERF_VIEW_REPORTS | View performance reports |
| PERF_ADMIN | Full admin |

### 5.2 Data Validation

- SQL injection prevention via `db_escape()`
- Input sanitization via `htmlspecialchars()`
- Required field validation in business logic

---

## 6. Design Patterns

### 6.1 Patterns Used

| Pattern | Implementation |
|--------|---------------|
| Service Locator | PerfContainer |
| Data Access Object | perf_db.inc functions |
| Helper Object | perf_ui.inc functions |
| Event Dispatcher | FAEventDispatcher |
| Factory | Container service creation |

### 6.2 Dependency Management

The PerfContainer provides:
- Lazy-loaded services
- Singleton instances for shared services
- Constructor injection for dependent services

---

## 7. Configuration

### 7.1 Module Configuration

Located in pages/settings.php:
- Review periods (monthly, quarterly, annually)
- Rating scales
- Notification settings
- KPI default weights

### 7.2 Initial Data

Rating scale defaults:
- 1: Poor (1.0)
- 2: Below Average (2.0)
- 3: Average (3.0)
- 4: Above Average (4.0)
- 5: Excellent (5.0)

KPI default categories:
- Sales Performance
- Customer Service
- Productivity
- Quality
- Teamwork

---

## 8. Deployment

### 8.1 Installation

1. Copy module to `/modules/ksf_FA_Performance`
2. Activate via FA Modules admin
3. SQL creates tables and inserts initial data
4. Permissions created in FA security

### 8.2 Initialization

_init/init.inc handles:
- Menu registration
- Permission setup
- Version tracking

### 8.3 Uninstallation

sql/uninstall.sql removes:
- All performance tables
- Module-specific data
- Cleans up permissions
