-- V3: Create templates table
CREATE TABLE templates (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(150) NOT NULL,
    description VARCHAR(500),
    category    VARCHAR(20)  NOT NULL,
    difficulty  VARCHAR(10)  NOT NULL,
    subject     VARCHAR(500) NOT NULL,
    html        TEXT         NOT NULL,
    active      BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at  DATETIME     NOT NULL,
    updated_at  DATETIME     NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
