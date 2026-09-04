# Campaigns

## Lifecycle
```
DRAFT → SCHEDULED → RUNNING → COMPLETED
                          ↘ CANCELLED
```

## Event Types
- EMAIL_SENT
- EMAIL_DELIVERED
- EMAIL_OPENED
- LINK_CLICKED
- LANDING_VIEWED
- FORM_SUBMITTED
- EMAIL_REPORTED
- TRAINING_VIEWED
- TRAINING_COMPLETED

## Tracking Flow
```
Recipient → CampaignRecipient → trackingToken → individual email
↓
User clicks link
↓
GET /t/{token}
↓
Backend identifies CampaignRecipient
↓
Registers LINK_CLICKED
↓
Redirects to landing page
```

## Duplicate Events
- `campaign_events` stores ALL events (including repeats)
- `campaign_recipients.*_at` fields store only FIRST event timestamp
