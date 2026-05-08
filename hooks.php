<?php
/**
 * FA_Performance Module Hooks for FrontAccounting
 * OKR-style performance management (like OpenProject)
 * Integrates with Project Management module
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
                    $path_to_root."/modules/".$this->module_name."/create_review.php", 'SA_PERFORMANCECREATE', MENU_ENTRY);
                $app->add_lapp_function(2, _("OKR Goals"),
                    $path_to_root."/modules/".$this->module_name."/goals.php", 'SA_PERFORMANCEMANAGE', MENU_ENTRY);
                $app->add_lapp_function(3, _("Check-ins"),
                    $path_to_root."/modules/".$this->module_name."/checkins.php", 'SA_PERFORMANCEVIEW', MENU_ENTRY);
                break;
            case 'Projects':
                $app->add_rapp_function(0, _("Linked Goals"),
                    $path_to_root."/modules/".$this->module_name."/project_goals.php", 'SA_PERFORMANCEVIEW', MENU_ENTRY);
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
        // FA's update_databases handles multiple SQL files automatically
        $updates = array(
            // PM versions (quarters: Q1-2026, etc.)
            'sql/fa_pm_versions.sql' => array($this->module_name),
            // OKR Goals (StrategicInitiative, Objective, KeyResult, Task)
            'sql/fa_performance_goals.sql' => array($this->module_name),
            // Performance reviews
            'sql/fa_performance_reviews.sql' => array($this->module_name),
            // Review-Goal linkage
            'sql/fa_performance_review_goals.sql' => array($this->module_name),
            // Regular check-ins (weekly/bi-weekly)
            'sql/fa_performance_checkins.sql' => array($this->module_name),
            // PM task progress tracking (OpenProject-style)
            'sql/fa_pm_task_progress.sql' => array($this->module_name)
        );
        return $this->update_databases($company, $updates, $check_only);
    }

    function db_prevoid($trans_type, $trans_no) {
        // Handle voiding if needed
    }
}
?>
