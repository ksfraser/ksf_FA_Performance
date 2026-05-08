-- fa_performance_checkins table
-- Regular OKR check-ins (weekly/bi-weekly)

CREATE TABLE IF NOT EXISTS `fa_performance_checkins` (
    `checkin_id` INT(11) NOT NULL AUTO_INCREMENT,
    `goal_id` INT(11) NOT NULL,
    `checked_by` INT(11) NOT NULL COMMENT 'FK to 0_crm_persons',
    `checkin_date` DATE NOT NULL,
    `progress_update` DECIMAL(5,2) DEFAULT NULL COMMENT 'Updated progress %',
    `impact_score_update` INT(11) DEFAULT NULL COMMENT 'Updated impact score',
    `blockers` TEXT,
    `action_items` TEXT,
    `notes` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`checkin_id`),
    KEY `idx_goal` (`goal_id`),
    KEY `idx_checked_by` (`checked_by`),
    KEY `idx_date` (`checkin_date`),
    CONSTRAINT `fk_checkin_goal` FOREIGN KEY (`goal_id`) REFERENCES `fa_performance_goals`(`goal_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_checkin_person` FOREIGN KEY (`checked_by`) REFERENCES `0_crm_persons`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
