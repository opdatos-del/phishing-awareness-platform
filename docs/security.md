# Security

## Simulation Constraints
- NO password capture
- NO cookie capture
- NO token capture
- NO session capture
- NO MFA capture
- NO credential harvesting
- NO reverse proxy auth
- NO malware/payloads
- Form submissions record only: `FORM_SUBMITTED`

## Authentication
- BCrypt password hashing
- JWT tokens (HS256)
- Stateless sessions
- Role-based access: ADMIN, ANALYST

## Tracking
- UUID-based tokens (not sequential IDs)
- No emails in URLs
- Token format: `/t/{uuid}`

## Infrastructure
- Caddy security headers
- CORS limited
- No stack traces in responses
- No sensitive data in logs
- Prepared statements via JPA
- Rate limiting (planned)
