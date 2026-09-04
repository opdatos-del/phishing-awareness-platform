-- V1: Create users table
CREATE TABLE users (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role        VARCHAR(20)  NOT NULL,
    active      BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at  DATETIME     NOT NULL,
    updated_at  DATETIME     NOT NULL,
    CONSTRAINT uq_users_username UNIQUE (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
