-- V6: Create campaign_recipients table
CREATE TABLE campaign_recipients (
    id                 BIGINT AUTO_INCREMENT PRIMARY KEY,
    campaign_id        BIGINT       NOT NULL,
    recipient_id       BIGINT       NOT NULL,
    tracking_token     VARCHAR(36)  NOT NULL,
    sent_at            DATETIME,
    opened_at          DATETIME,
    clicked_at         DATETIME,
    landing_viewed_at  DATETIME,
    submitted_at       DATETIME,
    reported_at        DATETIME,
    training_viewed_at DATETIME,
    created_at         DATETIME     NOT NULL,
    updated_at         DATETIME     NOT NULL,
    CONSTRAINT fk_cr_campaign  FOREIGN KEY (campaign_id)  REFERENCES campaigns(id),
    CONSTRAINT fk_cr_recipient FOREIGN KEY (recipient_id) REFERENCES recipients(id),
    CONSTRAINT uq_cr_tracking_token UNIQUE (tracking_token),
    INDEX idx_cr_campaign_id  (campaign_id),
    INDEX idx_cr_recipient_id (recipient_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
