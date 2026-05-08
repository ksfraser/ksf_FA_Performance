<?php
/**
 * DB functions for fa_performance_reviews table
 */

function write_performance_review($review_id, $data) {
    if ($review_id) {
        $sql = "UPDATE `" . TB_PREF . "fa_performance_reviews` SET ";
        $sets = array();
        foreach (array('person_id', 'reviewer_person_id', 'review_period_start', 'review_period_end', 'review_type', 'overall_rating', 'strengths', 'improvements', 'goals_summary', 'employee_comments', 'manager_comments', 'status', 'submitted_at', 'completed_at') as $field) {
            if (isset($data[$field])) {
                $sets[] = "`$field` = " . db_escape($data[$field]);
            }
        }
        $sql .= implode(', ', $sets) . " WHERE `review_id` = " . db_escape($review_id);
    } else {
        $sql = "INSERT INTO `" . TB_PREF . "fa_performance_reviews` SET ";
        $sets = array();
        foreach (array('person_id', 'reviewer_person_id', 'review_period_start', 'review_period_end', 'review_type', 'overall_rating', 'strengths', 'improvements', 'goals_summary', 'employee_comments', 'manager_comments', 'status', 'submitted_at', 'completed_at') as $field) {
            if (isset($data[$field])) {
                $sets[] = "`$field` = " . db_escape($data[$field]);
            }
        }
        $sql .= implode(', ', $sets);
    }
    
    db_query($sql, "Failed to write performance review");
    return $review_id ? $review_id : db_insert_id();
}

function get_performance_review($review_id) {
    $sql = "SELECT r.*, 
            e.name as employee_name, 
            rv.name as reviewer_name
        FROM `" . TB_PREF . "fa_performance_reviews` r
        LEFT JOIN `0_crm_persons` e ON r.person_id = e.id
        LEFT JOIN `0_crm_persons` rv ON r.reviewer_person_id = rv.id
        WHERE r.`review_id` = " . db_escape($review_id);
    $result = db_query($sql, "Failed to get performance review");
    return db_fetch($result);
}

function get_reviews_by_person($person_id, $status = null) {
    $sql = "SELECT r.*, rv.name as reviewer_name
        FROM `" . TB_PREF . "fa_performance_reviews` r
        LEFT JOIN `0_crm_persons` rv ON r.reviewer_person_id = rv.id
        WHERE r.`person_id` = " . db_escape($person_id);
    
    if ($status) {
        $sql .= " AND r.`status` = " . db_escape($status);
    }
    
    $sql .= " ORDER BY r.`review_period_end` DESC";
    return db_query($sql, "Failed to get reviews by person");
}

function get_reviews_by_reviewer($reviewer_person_id, $status = null) {
    $sql = "SELECT r.*, e.name as employee_name
        FROM `" . TB_PREF . "fa_performance_reviews` r
        LEFT JOIN `0_crm_persons` e ON r.person_id = e.id
        WHERE r.`reviewer_person_id` = " . db_escape($reviewer_person_id);
    
    if ($status) {
        $sql .= " AND r.`status` = " . db_escape($status);
    }
    
    $sql .= " ORDER BY r.`review_period_end` DESC";
    return db_query($sql, "Failed to get reviews by reviewer");
}

function update_review_status($review_id, $status, $additional_data = array()) {
    $sql = "UPDATE `" . TB_PREF . "fa_performance_reviews` SET `status` = " . db_escape($status);
    
    if ($status == 'Submitted' && empty($additional_data['submitted_at'])) {
        $sql .= ", `submitted_at` = NOW()";
    }
    if ($status == 'Completed' && empty($additional_data['completed_at'])) {
        $sql .= ", `completed_at` = NOW()";
    }
    
    foreach ($additional_data as $field => $value) {
        $sql .= ", `$field` = " . db_escape($value);
    }
    
    $sql .= " WHERE `review_id` = " . db_escape($review_id);
    db_query($sql, "Failed to update review status");
}

function delete_performance_review($review_id) {
    // Delete linked goals first
    $sql = "DELETE FROM `" . TB_PREF . "fa_performance_review_goals` WHERE `review_id` = " . db_escape($review_id);
    db_query($sql, "Failed to delete review goals");
    
    // Delete the review
    $sql = "DELETE FROM `" . TB_PREF . "fa_performance_reviews` WHERE `review_id` = " . db_escape($review_id);
    db_query($sql, "Failed to delete performance review");
}
?>
