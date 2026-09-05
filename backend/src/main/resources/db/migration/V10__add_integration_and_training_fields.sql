-- GoPhish correlation and delivery/training lifecycle fields.
ALTER TABLE campaigns
    ADD COLUMN gophish_campaign_id BIGINT,
    ADD COLUMN sent_at DATETIME,
    ADD CONSTRAINT uq_campaigns_gophish_id UNIQUE (gophish_campaign_id);

ALTER TABLE campaign_recipients
    ADD COLUMN delivered_at DATETIME,
    ADD COLUMN training_completed_at DATETIME,
    ADD COLUMN gophish_recipient_id VARCHAR(100);

CREATE INDEX idx_cr_gophish_recipient_id ON campaign_recipients (gophish_recipient_id);
