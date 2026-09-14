-- fa_performance_goals table
-- OKR-style goal setting (Objectives and Key Results)
-- Links to PM projects/tasks for execution tracking

CREATE TABLE IF NOT EXISTS `fa_performance_goals` (
    `goal_id` INT(11) NOT NULL AUTO_INCREMENT,
    `person_id` INT(11) NOT NULL COMMENT 'FK to 0_crm_persons (employee)',
    `goal_type` VARCHAR(20) DEFAULT 'Objective' COMMENT 'StrategicInitiative, Objective, KeyResult, Task',
    `parent_goal_id` INT(11) DEFAULT NULL COMMENT 'Parent goal (for OKR hierarchy)',
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT,
    `project_id` VARCHAR(20) DEFAULT NULL COMMENT 'Links to fa_pm_projects',
    `task_id` VARCHAR(20) DEFAULT NULL COMMENT 'Links to fa_pm_tasks',
    `start_date` DATE DEFAULT NULL,
    `target_date` DATE DEFAULT NULL,
    `priority` VARCHAR(20) DEFAULT 'Medium',
    `impact_score` INT(11) DEFAULT NULL COMMENT '1-5 scale for strategic value',
    `progress` DECIMAL(5,2) DEFAULT 0 COMMENT '0-100 percentage',
    `status` VARCHAR(30) DEFAULT 'Active' COMMENT 'Active, Completed, Cancelled, OnHold',
    `measurement` VARCHAR(255) DEFAULT NULL COMMENT 'How progress is measured',
    `baseline_value` DECIMAL(15,2) DEFAULT 0,
    `target_value` DECIMAL(15,2) DEFAULT 0,
    `current_value` DECIMAL(15,2) DEFAULT 0,
    `quarter` VARCHAR(10) DEFAULT NULL COMMENT 'Q1-2026, Q2-2026, etc.',
    `version_id` INT(11) DEFAULT NULL COMMENT 'Links to PM versions/releases',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`goal_id`),
    KEY `idx_person` (`person_id`),
    KEY `idx_type` (`goal_type`),
    KEY `idx_parent` (`parent_goal_id`),
    KEY `idx_project` (`project_id`),
    KEY `idx_status` (`status`),
    KEY `idx_quarter` (`quarter`),
    CONSTRAINT `fk_goal_person` FOREIGN KEY (`person_id`) REFERENCES `0_crm_persons`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_goal_parent` FOREIGN KEY (`parent_goal_id`) REFERENCES `fa_performance_goals`(`goal_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Index for hierarhical queries
CREATE INDEX `idx_goal_hierarchy` ON `fa_performance_goals` (`parent_goal_id`, `goal_type`, `status`);
