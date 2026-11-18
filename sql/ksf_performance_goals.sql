-- Performance module database schema for FrontAccounting
-- Table: 0_ksf_performance_goals

ALTER TABLE IF EXISTS `fa_performance_goals` RENAME TO `0_ksf_performance_goals`;

CREATE TABLE IF NOT EXISTS `0_ksf_performance_goals` (
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
