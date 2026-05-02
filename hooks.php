<?php
/**
 * FA_Performance Module Hooks for FrontAccounting
 */

define('SS_PERFORMANCE', 130 << 8);

class hooks_fa_performance extends hooks {
    var $module_name = 'fa_performance';

    function install_options($app) {
        global $path_to_root;

        switch($app->id) {
            case 'HR':
                $app->add_lapp_function(0, _("Performance Reviews"),
                    $path_to_root."/modules/".$this->module_name."/reviews.php", 'SA_PERFORMANCEVIEW', MENU_ENTRY);
                $app->add_lapp_function(1, _("Create Review"),
                    $path_to_root."/modules/".$this->module_name."/create.php", 'SA_PERFORMANCECREATE', MENU_ENTRY);
                $app->add_lapp_function(2, _("Goals"),
                    $path_to_root."/modules/".$this->module_name."/goals.php", 'SA_PERFORMANCEMANAGE', MENU_ENTRY);
                break;
        }
    }

    function install_access() {
        $security_sections[SS_PERFORMANCE] = _("Performance Management");
        $security_areas['SA_PERFORMANCEVIEW'] = array(SS_PERFORMANCE | 1, _("View Reviews"));
        $security_areas['SA_PERFORMANCECREATE'] = array(SS_PERFORMANCE | 2, _("Create Reviews"));
        $security_areas['SA_PERFORMANCEMANAGE'] = array(SS_PERFORMANCE | 3, _("Manage Goals"));
        return array($security_areas, $security_sections);
    }

    function activate_extension($company, $check_only=true) {
        $updates = array('sql/update.sql' => array($this->module_name));
        $ok = $this->update_databases($company, $updates, $check_only);
        if ($check_only || !$ok) {
            return $ok;
        }
        $this->ensure_performance_schema();
        return $ok;
    }

    private function table_exists($table) {
        $sql = "SHOW TABLES LIKE " . db_escape($table);
        $res = db_query($sql, 'Failed checking table existence');
        return db_num_rows($res) > 0;
    }

    private function ensure_performance_schema() {
        $tables = array(
            TB_PREF . "fa_performance_reviews" => "
                CREATE TABLE IF NOT EXISTS `" . TB_PREF . "fa_performance_reviews` (
                    `id` INT(11) NOT NULL AUTO_INCREMENT,
                    `employee_id` VARCHAR(100) NOT NULL,
                    `reviewer_id` VARCHAR(100) DEFAULT NULL,
                    `review_period` VARCHAR(50) DEFAULT NULL,
                    `overall_rating` DECIMAL(3,2) DEFAULT 0,
                    `strengths` TEXT,
                    `areas_for_improvement` TEXT,
                    `goals` TEXT,
                    `status` VARCHAR(20) DEFAULT 'Draft',
                    `review_date` DATE DEFAULT NULL,
                    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    PRIMARY KEY (`id`),
                    KEY `idx_employee` (`employee_id`),
                    KEY `idx_status` (`status`),
                    KEY `idx_date` (`review_date`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",

            TB_PREF . "fa_performance_goals" => "
                CREATE TABLE IF NOT EXISTS `" . TB_PREF . "fa_performance_goals` (
                    `id` INT(11) NOT NULL AUTO_INCREMENT,
                    `employee_id` VARCHAR(100) NOT NULL,
                    `goal_title` VARCHAR(255) NOT NULL,
                    `description` TEXT,
                    `target_date` DATE DEFAULT NULL,
                    `progress` DECIMAL(5,2) DEFAULT 0,
                    `status` VARCHAR(20) DEFAULT 'Active',
                    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    PRIMARY KEY (`id`),
                    KEY `idx_employee` (`employee_id`),
                    KEY `idx_status` (`status`),
                    KEY `idx_target_date` (`target_date`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );

        foreach ($tables as $table_name => $sql) {
            db_query($sql, "Could not create Performance table: $table_name");
        }
    }

    function db_prevoid($trans_type, $trans_no) {
        // Handle voiding if needed
    }
}
?>
