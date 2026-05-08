<?php
/**
 * DB functions for fa_performance_goals table
 * OKR-style goal management
 */

function write_performance_goal($goal_id, $data) {
    if ($goal_id) {
        $sql = "UPDATE `" . TB_PREF . "fa_performance_goals` SET ";
        $sets = array();
        foreach (array('person_id', 'goal_type', 'parent_goal_id', 'title', 'description', 'project_id', 'task_id', 'start_date', 'target_date', 'priority', 'impact_score', 'progress', 'status', 'measurement', 'baseline_value', 'target_value', 'current_value', 'quarter', 'version_id') as $field) {
            if (isset($data[$field])) {
                $sets[] = "`$field` = " . db_escape($data[$field]);
            }
        }
        $sql .= implode(', ', $sets) . " WHERE `goal_id` = " . db_escape($goal_id);
    } else {
        $sql = "INSERT INTO `" . TB_PREF . "fa_performance_goals` SET ";
        $sets = array();
        foreach (array('person_id', 'goal_type', 'parent_goal_id', 'title', 'description', 'project_id', 'task_id', 'start_date', 'target_date', 'priority', 'impact_score', 'progress', 'status', 'measurement', 'baseline_value', 'target_value', 'current_value', 'quarter', 'version_id') as $field) {
            if (isset($data[$field])) {
                $sets[] = "`$field` = " . db_escape($data[$field]);
            }
        }
        $sql .= implode(', ', $sets);
    }
    
    db_query($sql, "Failed to write performance goal");
    return $goal_id ? $goal_id : db_insert_id();
}

function get_performance_goal($goal_id) {
    $sql = "SELECT g.*, p.name as employee_name
        FROM `" . TB_PREF . "fa_performance_goals` g
        LEFT JOIN `0_crm_persons` p ON g.person_id = p.id
        WHERE g.`goal_id` = " . db_escape($goal_id);
    $result = db_query($sql, "Failed to get performance goal");
    return db_fetch($result);
}

function get_goals_by_person($person_id, $quarter = null, $goal_type = null) {
    $sql = "SELECT g.*, pg.title as parent_title
        FROM `" . TB_PREF . "fa_performance_goals` g
        LEFT JOIN `" . TB_PREF . "fa_performance_goals` pg ON g.parent_goal_id = pg.goal_id
        WHERE g.`person_id` = " . db_escape($person_id);
    
    if ($quarter) {
        $sql .= " AND g.`quarter` = " . db_escape($quarter);
    }
    if ($goal_type) {
        $sql .= " AND g.`goal_type` = " . db_escape($goal_type);
    }
    
    $sql .= " ORDER BY g.`goal_type`, g.`priority` DESC";
    return db_query($sql, "Failed to get goals by person");
}

function get_goals_by_quarter($quarter, $goal_type = null) {
    $sql = "SELECT g.*, p.name as employee_name
        FROM `" . TB_PREF . "fa_performance_goals` g
        LEFT JOIN `0_crm_persons` p ON g.person_id = p.id
        WHERE g.`quarter` = " . db_escape($quarter);
    
    if ($goal_type) {
        $sql .= " AND g.`goal_type` = " . db_escape($goal_type);
    }
    
    $sql .= " ORDER BY g.`goal_type`, g.`priority` DESC";
    return db_query($sql, "Failed to get goals by quarter");
}

function get_okr_hierarchy($quarter) {
    // Get all Strategic Initiatives
    $sql = "SELECT * FROM `" . TB_PREF . "fa_performance_goals`
        WHERE `quarter` = " . db_escape($quarter) . "
        AND `goal_type` = 'StrategicInitiative'
        AND `status` != 'Cancelled'
        ORDER BY `priority` DESC";
    $initiatives = db_query($sql, "Failed to get OKR hierarchy");
    
    $hierarchy = array();
    while ($initiative = db_fetch($initiatives)) {
        $initiative['children'] = get_child_goals($initiative['goal_id']);
        $hierarchy[] = $initiative;
    }
    
    return $hierarchy;
}

function get_child_goals($parent_id) {
    $sql = "SELECT * FROM `" . TB_PREF . "fa_performance_goals`
        WHERE `parent_goal_id` = " . db_escape($parent_id) . "
        AND `status` != 'Cancelled'
        ORDER BY `goal_type`, `priority` DESC";
    $result = db_query($sql, "Failed to get child goals");
    
    $children = array();
    while ($child = db_fetch($result)) {
        $child['children'] = get_child_goals($child['goal_id']);
        $children[] = $child;
    }
    
    return $children;
}

function update_goal_progress($goal_id, $progress) {
    $sql = "UPDATE `" . TB_PREF . "fa_performance_goals` 
        SET `progress` = " . db_escape($progress) . "
        WHERE `goal_id` = " . db_escape($goal_id);
    db_query($sql, "Failed to update goal progress");
}

function delete_performance_goal($goal_id) {
    // Delete children first
    $sql = "DELETE FROM `" . TB_PREF . "fa_performance_goals` WHERE `parent_goal_id` = " . db_escape($goal_id);
    db_query($sql, "Failed to delete child goals");
    
    // Delete the goal itself
    $sql = "DELETE FROM `" . TB_PREF . "fa_performance_goals` WHERE `goal_id` = " . db_escape($goal_id);
    db_query($sql, "Failed to delete performance goal");
}
?>
