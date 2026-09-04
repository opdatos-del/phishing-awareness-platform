# Architecture

See README.md for high-level architecture diagram.

## Module Structure (Backend)

```
com.company.phishingawareness/
├── auth/           # JWT authentication, users
├── recipient/      # Employee contacts
├── campaign/       # Campaigns, recipients, events
├── tracking/       # Token-based tracking
├── template/       # Email templates
├── landing/        # Landing pages
├── analytics/      # Dashboard metrics (Phase 6)
├── gophish/        # GoPhish integration (Phase 3)
└── shared/         # Base entities, exceptions, config
```

## Data Flow

1. Admin creates campaign with template + landing page
2. Admin assigns recipients to campaign
3. GoPhish sends emails via SMTP
4. Recipient clicks link → `GET /t/{token}`
5. Backend records `LINK_CLICKED`, redirects to landing
6. Landing records `LANDING_VIEWED`
7. If form submitted → `FORM_SUBMITTED`
8. Redirect to training page → `TRAINING_VIEWED`
9. Dashboard shows aggregated metrics

## Security Model

- No credential capture (MVP)
- No emails in URLs (UUID tokens only)
- BCrypt password hashing
- JWT for API authentication
- Stateless sessions
