<?php
/**
 * DB functions for fa_pm_versions table
 * PM versions/quarters for OKR tracking
 */

function write_pm_version($version_id, $data) {
    if ($version_id) {
        $sql = "UPDATE `" . TB_PREF . "fa_pm_versions` SET ";
        $sets = array();
        foreach (array('version_name', 'description', 'start_date', 'end_date', 'is_active') as $field) {
            if (isset($data[$field])) {
                $sets[] = "`$field` = " . db_escape($data[$field]);
            }
        }
        $sql .= implode(', ', $sets) . " WHERE `version_id` = " . db_escape($version_id);
    } else {
        $sql = "INSERT INTO `" . TB_PREF . "fa_pm_versions` SET ";
        $sets = array();
        foreach (array('version_name', 'description', 'start_date', 'end_date', 'is_active') as $field) {
            if (isset($data[$field])) {
                $sets[] = "`$field` = " . db_escape($data[$field]);
            }
        }
        $sql .= implode(', ', $sets);
    }
    
    db_query($sql, "Failed to write PM version");
    return $version_id ? $version_id : db_insert_id();
}

function get_pm_version($version_id) {
    $sql = "SELECT * FROM `" . TB_PREF . "fa_pm_versions` WHERE `version_id` = " . db_escape($version_id);
    $result = db_query($sql, "Failed to get PM version");
    return db_fetch($result);
}

function get_all_pm_versions($active_only = true) {
    $sql = "SELECT * FROM `" . TB_PREF . "fa_pm_versions`";
    if ($active_only) {
        $sql .= " WHERE `is_active` = 1";
    }
    $sql .= " ORDER BY `start_date` DESC";
    return db_query($sql, "Failed to get PM versions");
}

function get_version_by_name($version_name) {
    $sql = "SELECT * FROM `" . TB_PREF . "fa_pm_versions` WHERE `version_name` = " . db_escape($version_name);
    $result = db_query($sql, "Failed to get version by name");
    return db_fetch($result);
}

function get_current_quarter() {
    $sql = "SELECT * FROM `" . TB_PREF . "fa_pm_versions` 
        WHERE `start_date` <= CURDATE() 
        AND (`end_date` IS NULL OR `end_date` >= CURDATE())
        AND `is_active` = 1
        ORDER BY `start_date` DESC
        LIMIT 1";
    $result = db_query($sql, "Failed to get current quarter");
    return db_fetch($result);
}

function delete_pm_version($version_id) {
    $sql = "UPDATE `" . TB_PREF . "fa_pm_versions` SET `is_active` = 0 WHERE `version_id` = " . db_escape($version_id);
    db_query($sql, "Failed to delete PM version");
}
?>
