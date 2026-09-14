-- fa_pm_versions table
-- PM versions (Q1-2026, Q2-2026, etc.) for goal/OKR tracking

CREATE TABLE IF NOT EXISTS `fa_pm_versions` (
    `version_id` INT(11) NOT NULL AUTO_INCREMENT,
    `version_name` VARCHAR(50) NOT NULL COMMENT 'Q1-2026, v2.0, etc.',
    `description` TEXT,
    `start_date` DATE DEFAULT NULL,
    `end_date` DATE DEFAULT NULL,
    `is_active` TINYINT(1) DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`version_id`),
    UNIQUE KEY `idx_name` (`version_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Default versions (quarters)
INSERT IGNORE INTO `fa_pm_versions` (`version_name`, `description`, `start_date`, `end_date`) VALUES
('Q1-2026', 'Q1 2026 (Jan-Mar)', '2026-01-01', '2026-03-31'),
('Q2-2026', 'Q2 2026 (Apr-Jun)', '2026-04-01', '2026-06-30'),
('Q3-2026', 'Q3 2026 (Jul-Sep)', '2026-07-01', '2026-09-30'),
('Q4-2026', 'Q4 2026 (Oct-Dec)', '2026-10-01', '2026-12-31');
