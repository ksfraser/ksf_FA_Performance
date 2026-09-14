-- fa_performance_review_goals table
-- Links reviews to specific goals with ratings

CREATE TABLE IF NOT EXISTS `fa_performance_review_goals` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `review_id` INT(11) NOT NULL,
    `goal_id` INT(11) NOT NULL,
    `goal_rating` INT(11) DEFAULT NULL COMMENT '1-5 rating for this goal',
    `achievement_notes` TEXT,
    `next_period_goals` TEXT,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_review_goal` (`review_id`, `goal_id`),
    CONSTRAINT `fk_reviewgoal_review` FOREIGN KEY (`review_id`) REFERENCES `fa_performance_reviews`(`review_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_reviewgoal_goal` FOREIGN KEY (`goal_id`) REFERENCES `fa_performance_goals`(`goal_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
