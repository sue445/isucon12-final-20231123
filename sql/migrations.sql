ALTER TABLE user_present_all_received_history ADD INDEX index_user_id_and_present_all_id (user_id, present_all_id);

ALTER TABLE present_all_masters ADD INDEX index_registered_start_at_and_registered_end_at (registered_start_at, registered_end_at);

ALTER TABLE user_presents ADD INDEX index_user_id_and_deleted_at_and_created_at (user_id, deleted_at, created_at);

/*
ALTER TABLE login_bonus_masters ADD INDEX index_start_at (start_at);

ALTER TABLE login_bonus_reward_masters ADD INDEX index_login_bonus_id (login_bonus_id);

ALTER TABLE user_cards ADD INDEX index_card_id (card_id);

ALTER TABLE user_items ADD INDEX index_item_id (item_id);

ALTER TABLE user_one_time_tokens_and_token_type ADD INDEX index_token (token, token_type);

ALTER TABLE version_masters ADD INDEX index_status (status);
*/

/* db_sessions */
ALTER TABLE user_sessions ADD INDEX index_session_id (session_id);
