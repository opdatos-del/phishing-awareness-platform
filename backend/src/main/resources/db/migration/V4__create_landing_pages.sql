-- V4: Create landing_pages table
CREATE TABLE landing_pages (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(150) NOT NULL,
    slug        VARCHAR(150) NOT NULL,
    category    VARCHAR(20),
    difficulty  VARCHAR(10),
    html        TEXT         NOT NULL,
    active      BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at  DATETIME     NOT NULL,
    updated_at  DATETIME     NOT NULL,
    CONSTRAINT uq_landing_pages_slug UNIQUE (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
