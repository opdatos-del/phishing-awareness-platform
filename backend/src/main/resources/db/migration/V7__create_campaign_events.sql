-- V7: Create campaign_events table
CREATE TABLE campaign_events (
    id                      BIGINT AUTO_INCREMENT PRIMARY KEY,
    campaign_recipient_id   BIGINT       NOT NULL,
    event_type              VARCHAR(30)  NOT NULL,
    event_time              DATETIME     NOT NULL,
    user_agent              VARCHAR(500),
    metadata                JSON,
    created_at              DATETIME     NOT NULL,
    updated_at              DATETIME     NOT NULL,
    CONSTRAINT fk_ce_campaign_recipient FOREIGN KEY (campaign_recipient_id) REFERENCES campaign_recipients(id),
    INDEX idx_ce_campaign_recipient_id (campaign_recipient_id),
    INDEX idx_ce_event_type (event_type),
    INDEX idx_ce_event_time (event_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
