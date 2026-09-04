# Deployment

## Development
```bash
./scripts/dev-up.sh
```

## Production (planned)
- `docker-compose.prod.yml` for production overrides
- Mailpit replaced by corporate SMTP
- GoPhish with TLS enabled
- Caddy with real certificates
- MySQL credentials rotation
- Environment-specific profiles

## Services
| Service    | Port  | Purpose              |
|------------|-------|----------------------|
| Caddy      | 80/443| Reverse proxy        |
| Frontend   | 80    | React SPA (nginx)    |
| Backend    | 8080  | Spring Boot API      |
| GoPhish    | 3333  | Campaign engine      |
| Mailpit    | 8025  | Email viewer (dev)   |
| Mailpit    | 1025  | SMTP server (dev)    |
| MySQL      | 3306  | Database (host)      |
