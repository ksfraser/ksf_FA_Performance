-- Performance module database schema for FrontAccounting

CREATE TABLE IF NOT EXISTS `fa_performance_reviews` (
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

CREATE TABLE IF NOT EXISTS `fa_performance_goals` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `employee_id` INT(11) NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT,
    `due_date` DATE DEFAULT NULL,
    `status` ENUM('Pending','In Progress','Completed') NOT NULL DEFAULT 'Pending',
    `rating` INT(1) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `employee_id` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `fa_modules` (`name`, `version`, `enabled`, `installed`) VALUES ('Performance', '1.0.0', 1, NOW()) ON DUPLICATE KEY UPDATE `version` = '1.0.0';

-- ---------------------------------------------------------------------------
-- Module-local employee directory.
--
-- WHY THIS TABLE EXISTS (and why it is not FA core):
--   FA core has no employee entity. In this estate an employee is an FA
--   person (0_crm_persons) plus a crm_categories row of type 'employee' plus
--   a satellite employment table - the satellite belongs to ksf_FA_HRM
--   (0_hrm_contacts_employment). Reaching into another module's table would
--   make this module depend on that module being activated, which
--   AGENTS_ARCH.md 12.2 forbids ("a shared seam must never be gated on
--   another module's activation"). The contact resolver in ksf-fa-common
--   deliberately does not cover the employee intent either.
--   So this module keeps its OWN employee directory, keyed by the same
--   employee_id its own records already carry. It is module-local by design.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `0_ksf_performance_employees` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(120) DEFAULT NULL,
    `active` TINYINT(1) DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;