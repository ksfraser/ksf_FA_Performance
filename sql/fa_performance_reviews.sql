-- fa_performance_reviews table
-- Performance reviews linked to goals

CREATE TABLE IF NOT EXISTS `fa_performance_reviews` (
    `review_id` INT(11) NOT NULL AUTO_INCREMENT,
    `person_id` INT(11) NOT NULL COMMENT 'FK to 0_crm_persons (employee being reviewed)',
    `reviewer_person_id` INT(11) NOT NULL COMMENT 'FK to 0_crm_persons (reviewer)',
    `review_period_start` DATE NOT NULL,
    `review_period_end` DATE NOT NULL,
    `review_type` VARCHAR(30) DEFAULT 'Quarterly' COMMENT 'Quarterly, Annual, MidYear, Probation',
    `overall_rating` DECIMAL(3,2) DEFAULT NULL COMMENT '1.0-5.0 scale',
    `strengths` TEXT,
    `improvements` TEXT,
    `goals_summary` TEXT COMMENT 'Auto-generated from linked goals',
    `employee_comments` TEXT,
    `manager_comments` TEXT,
    `status` VARCHAR(20) DEFAULT 'Draft' COMMENT 'Draft, Submitted, InReview, Completed',
    `submitted_at` DATETIME DEFAULT NULL,
    `completed_at` DATETIME DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`review_id`),
    KEY `idx_person` (`person_id`),
    KEY `idx_reviewer` (`reviewer_person_id`),
    KEY `idx_status` (`status`),
    KEY `idx_period` (`review_period_start`, `review_period_end`),
    CONSTRAINT `fk_review_person` FOREIGN KEY (`person_id`) REFERENCES `0_crm_persons`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_review_reviewer` FOREIGN KEY (`reviewer_person_id`) REFERENCES `0_crm_persons`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
