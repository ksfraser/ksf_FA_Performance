-- Performance module database schema for FrontAccounting
-- Table: 0_ksf_performance_reviews

ALTER TABLE IF EXISTS `fa_performance_reviews` RENAME TO `0_ksf_performance_reviews`;

CREATE TABLE IF NOT EXISTS `0_ksf_performance_reviews` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `employee_id` INT(11) NOT NULL,
    `reviewer_id` INT(11) NOT NULL,
    `period_start` DATE NOT NULL,
    `period_end` DATE NOT NULL,
    `status` ENUM('Draft','Submitted','Completed') NOT NULL DEFAULT 'Draft',
    `overall_rating` DECIMAL(3,2) DEFAULT NULL,
    `strengths` TEXT,
    `improvements` TEXT,
    `goals` TEXT,
    `submitted_at` DATETIME DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `employee_id` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
