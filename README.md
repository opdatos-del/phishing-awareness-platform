# Phishing Awareness Platform

Internal phishing simulation platform for employee security awareness training.

## Architecture

```
                       ADMIN USER
                            │
                            ▼
                         CADDY
                            │
              ┌─────────────┴─────────────┐
              │                           │
              ▼                           ▼
           React                      Spring Boot
                                        │
                                        ▼
                                   MySQL local


                         GoPhish
                            │
                            ▼
                          SMTP
                            │
                            ▼
                         Mailpit
                            │
                            ▼
                     Test emails
```

## Stack

### Backend
- Java 21 LTS / Spring Boot 4.1.1
- Gradle 8.14 (Kotlin DSL)
- Spring Security + JWT (jjwt 0.13.0)
- Spring Data JPA + Hibernate
- Flyway (schema migrations)
- MySQL

### Frontend
- React 19.2 + TypeScript 5.8
- Vite 8.2
- Tailwind CSS 4.3
- React Router 8.3
- TanStack Query 5.102
- Recharts 3.10

### Infrastructure
- Docker + Docker Compose
- GoPhish (campaign engine)
- Mailpit (dev SMTP catcher)
- Caddy (reverse proxy)

## Requirements

- Java 21+
- Node.js 24+
- pnpm
- Gradle 8.14+ (or use wrapper)
- Docker + Docker Compose
- MySQL 8.0+ (installed on host)

## MySQL Setup

```sql
CREATE DATABASE phishing_awareness
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

CREATE USER 'phishing_app'@'%' IDENTIFIED BY 'CHANGE_ME';
GRANT ALL PRIVILEGES ON phishing_awareness.* TO 'phishing_app'@'%';
FLUSH PRIVILEGES;
```

## Configuration

```bash
cp .env.example .env
# Edit .env with your MySQL credentials and secrets
```

## Quick Start

```bash
# Start all services
./scripts/dev-up.sh

# Or manually
docker compose up -d --build

# View logs
docker compose logs -f
```

### URLs

| Service   | URL                          |
|-----------|------------------------------|
| App       | http://localhost              |
| API       | http://localhost/api/v1       |
| GoPhish   | http://localhost:3333         |
| Mailpit   | http://localhost:8025         |

### Default Credentials

| User  | Password |
|-------|----------|
| admin | admin123 |

## Flyway Migrations

Schema changes are managed via Flyway in:

```
backend/src/main/resources/db/migration/
```

Run `./gradlew flywayMigrate` or let Spring Boot handle it on startup.

## GoPhish

GoPhish runs as the campaign engine. The backend provisions templates, safe
landing pages, SMTP profiles, groups and campaigns through its API. Tracking
tokens remain local to Paware and are carried in the target `position` field;
the GoPhish landing page redirects to the local training flow. Configuration:

```
infrastructure/gophish/config.json
```

The API integration layer provisions GoPhish resources and receives webhooks in Phase 3.

## Mailpit

Mailpit catches all SMTP emails in development. View at http://localhost:8025.

No real emails are sent in dev mode.

## Security

- Password hashing with BCrypt
- JWT authentication for dashboard
- Flyway-managed schema (no hibernate auto-DDL)
- No credential capture in simulations
- Tracking tokens via UUID (no sequential IDs)
- No emails in URLs
- CORS limited
- Security headers via Caddy
- No stack traces exposed

## Development

```bash
# Backend only (requires MySQL running on host)
cd backend
./gradlew bootRun

# Frontend only
cd frontend
pnpm install
pnpm dev
```

## Testing

```bash
# Backend tests
cd backend
./gradlew test

# Frontend tests
cd frontend
pnpm test
```

## Roadmap

- [x] Phase 0: Infrastructure (GoPhish, Mailpit, Caddy, Docker)
- [x] Phase 1: Backend base (Spring Boot, MySQL, Flyway, Security, Entities)
- [x] Phase 2: Tracking (tokens, open pixel, click, landing, submit, training)
- [x] Phase 3: GoPhish integration (API provisioning, scheduling, webhooks, event mapping)
- [x] Phase 4: Frontend (login, admin layout, CRUD, campaigns and funnel)
- [x] Phase 5: Templates (5 seeded email + 5 seeded landing page templates)
- [x] Phase 6: Analytics (dashboard funnel, campaign rates, timeline and CSV export)
- [~] Phase 7: Awareness (training content, quiz and `TRAINING_COMPLETED`; report button included)

### Architecture decisions

- GoPhish sends email through the configured SMTP sending profile. Mailpit is the
  development SMTP target. Spring Mail is not used while GoPhish is enabled.
- Set `GOPHISH_API_KEY` to enable campaign launch. Without it, CRUD and local
  tracking remain available but launch returns a clear configuration error.
- GoPhish admin is exposed on `3333`; its phishing server is exposed on `8081`.

## License

Internal use only.
