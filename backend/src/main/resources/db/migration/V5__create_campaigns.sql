-- V5: Create campaigns table
CREATE TABLE campaigns (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(200) NOT NULL,
    description     VARCHAR(1000),
    status          VARCHAR(20)  NOT NULL DEFAULT 'DRAFT',
    template_id     BIGINT       NOT NULL,
    landing_page_id BIGINT       NOT NULL,
    scheduled_at    DATETIME,
    started_at      DATETIME,
    completed_at    DATETIME,
    created_at      DATETIME     NOT NULL,
    updated_at      DATETIME     NOT NULL,
    CONSTRAINT fk_campaigns_template FOREIGN KEY (template_id) REFERENCES templates(id),
    CONSTRAINT fk_campaigns_landing  FOREIGN KEY (landing_page_id) REFERENCES landing_pages(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
