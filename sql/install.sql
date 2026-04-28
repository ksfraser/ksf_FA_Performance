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