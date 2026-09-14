<?php
/**
 * DB functions for fa_performance_checkins table
 * Weekly/bi-weekly OKR check-ins
 */

function write_performance_checkin($checkin_id, $data) {
    if ($checkin_id) {
        $sql = "UPDATE `" . TB_PREF . "fa_performance_checkins` SET ";
        $sets = array();
        foreach (array('goal_id', 'checked_by', 'checkin_date', 'progress_update', 'impact_score_update', 'blockers', 'action_items', 'notes') as $field) {
            if (isset($data[$field])) {
                $sets[] = "`$field` = " . db_escape($data[$field]);
            }
        }
        $sql .= implode(', ', $sets) . " WHERE `checkin_id` = " . db_escape($checkin_id);
    } else {
        $sql = "INSERT INTO `" . TB_PREF . "fa_performance_checkins` SET ";
        $sets = array();
        foreach (array('goal_id', 'checked_by', 'checkin_date', 'progress_update', 'impact_score_update', 'blockers', 'action_items', 'notes') as $field) {
            if (isset($data[$field])) {
                $sets[] = "`$field` = " . db_escape($data[$field]);
            }
        }
        $sql .= implode(', ', $sets);
    }
    
    db_query($sql, "Failed to write performance checkin");
    return $checkin_id ? $checkin_id : db_insert_id();
}

function get_performance_checkin($checkin_id) {
    $sql = "SELECT c.*, g.title as goal_title, g.goal_type, p.name as checked_by_name
        FROM `" . TB_PREF . "fa_performance_checkins` c
        LEFT JOIN `" . TB_PREF . "fa_performance_goals` g ON c.goal_id = g.goal_id
        LEFT JOIN `0_crm_persons` p ON c.checked_by = p.id
        WHERE c.`checkin_id` = " . db_escape($checkin_id);
    $result = db_query($sql, "Failed to get performance checkin");
    return db_fetch($result);
}

function get_checkins_by_goal($goal_id, $limit = 20) {
    $sql = "SELECT c.*, p.name as checked_by_name
        FROM `" . TB_PREF . "fa_performance_checkins` c
        LEFT JOIN `0_crm_persons` p ON c.checked_by = p.id
        WHERE c.`goal_id` = " . db_escape($goal_id) . "
        ORDER BY c.`checkin_date` DESC
        LIMIT " . (int)$limit;
    return db_query($sql, "Failed to get checkins by goal");
}

function get_checkins_by_person($person_id, $quarter = null, $limit = 50) {
    $sql = "SELECT c.*, g.title as goal_title, g.goal_type
        FROM `" . TB_PREF . "fa_performance_checkins` c
        LEFT JOIN `" . TB_PREF . "fa_performance_goals` g ON c.goal_id = g.goal_id
        WHERE g.`person_id` = " . db_escape($person_id);
    
    if ($quarter) {
        $sql .= " AND g.`quarter` = " . db_escape($quarter);
    }
    
    $sql .= " ORDER BY c.`checkin_date` DESC
        LIMIT " . (int)$limit;
    return db_query($sql, "Failed to get checkins by person");
}

function delete_performance_checkin($checkin_id) {
    $sql = "DELETE FROM `" . TB_PREF . "fa_performance_checkins` WHERE `checkin_id` = " . db_escape($checkin_id);
    db_query($sql, "Failed to delete performance checkin");
}
?>
