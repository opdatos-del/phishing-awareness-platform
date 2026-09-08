ALTER TABLE campaigns
    ADD COLUMN send_by_at DATETIME NULL,
    ADD INDEX idx_campaigns_running_send_by (status, send_by_at);

ALTER TABLE campaign_events
    ADD INDEX idx_ce_event_time_type (event_time, event_type);

ALTER TABLE campaign_recipients
    ADD INDEX idx_cr_opened_clicked (opened_at, clicked_at);
