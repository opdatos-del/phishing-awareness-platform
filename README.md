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
- Java 25 LTS / Spring Boot 3.5.16
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

- Java 25+
- Node.js 24+
- Maven 3.9+
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

Run `mvn flyway:migrate` or let Spring Boot handle it on startup.

## GoPhish

GoPhish runs as the campaign engine. Configuration:

```
infrastructure/gophish/config.json
```

API integration layer will be added in Phase 3.

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
mvn spring-boot:run

# Frontend only
cd frontend
npm install
npm run dev
```

## Testing

```bash
# Backend tests
cd backend
mvn test

# Frontend tests
cd frontend
npm test
```

## Roadmap

- [x] Phase 0: Infrastructure (GoPhish, Mailpit, Caddy, Docker)
- [x] Phase 1: Backend base (Spring Boot, MySQL, Flyway, Security, Entities)
- [ ] Phase 2: Tracking (tokens, link click, form submit)
- [ ] Phase 3: GoPhish integration (API, webhooks, event mapping)
- [ ] Phase 4: Frontend (dashboard, campaigns, recipients, templates)
- [ ] Phase 5: Templates (5 email + 5 landing page templates)
- [ ] Phase 6: Analytics (rates, historical, comparison)
- [ ] Phase 7: Awareness (training page post-simulation)

## License

Internal use only.
