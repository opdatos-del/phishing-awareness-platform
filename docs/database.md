# Database

## Engine
- MySQL 8.0 (host)
- UTF-8 (utf8mb4_unicode_ci)

## Migrations
Managed by Flyway in `backend/src/main/resources/db/migration/`

## Tables
1. `users` — Admin/analytics accounts
2. `recipients` — Employee contacts
3. `templates` — Email templates
4. `landing_pages` — Phishing landing pages
5. `campaigns` — Campaign definitions
6. `campaign_recipients` — Campaign-to-recipient mapping + tracking
7. `campaign_events` — Detailed event history

## Key Constraints
- `recipients.email` — UNIQUE
- `templates` → categories: ACCOUNT, DOCUMENT, SECURITY, CLOUD, HR, SUPPORT, NOTIFICATION
- `campaign_recipients.tracking_token` — UNIQUE
- `campaign_events.campaign_recipient_id` — FK
