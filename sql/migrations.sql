/*
ALTER TABLE login_bonus_masters ADD INDEX index_start_at (start_at);

ALTER TABLE login_bonus_reward_masters ADD INDEX index_login_bonus_id (login_bonus_id);

ALTER TABLE present_all_masters ADD INDEX index_registered_start_at (registered_start_at);

ALTER TABLE user_cards ADD INDEX index_card_id (card_id);

ALTER TABLE user_items ADD INDEX index_item_id (item_id);

ALTER TABLE user_one_time_tokens_and_token_type ADD INDEX index_token (token, token_type);

ALTER TABLE user_present_all_received_history ADD INDEX index_user_id (user_id);

ALTER TABLE version_masters ADD INDEX index_status (status);
*/

/* db_sessions */
ALTER TABLE user_sessions ADD INDEX index_session_id (session_id);
