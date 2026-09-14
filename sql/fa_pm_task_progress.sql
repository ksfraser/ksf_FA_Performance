-- fa_pm_task_progress table
-- Track progress based on work packages (OpenProject-style)

CREATE TABLE IF NOT EXISTS `fa_pm_task_progress` (
    `progress_id` INT(11) NOT NULL AUTO_INCREMENT,
    `task_id` VARCHAR(20) NOT NULL,
    `progress_mode` VARCHAR(20) DEFAULT 'work_based' COMMENT 'work_based, status_based',
    `work_hours` DECIMAL(10,2) DEFAULT 0,
    `remaining_hours` DECIMAL(10,2) DEFAULT 0,
    `percent_complete` DECIMAL(5,2) DEFAULT 0,
    `status` VARCHAR(30) DEFAULT NULL COMMENT 'Links to PM task status',
    `baseline_hours` DECIMAL(10,2) DEFAULT 0,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`progress_id`),
    UNIQUE KEY `idx_task` (`task_id`),
    CONSTRAINT `fk_progress_task` FOREIGN KEY (`task_id`) REFERENCES `fa_pm_tasks`(`task_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
