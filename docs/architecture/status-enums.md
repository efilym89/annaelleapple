# Status Enums

## Centralized Statuses Fixed In Foundation

### Course status

- `draft`
- `review`
- `published`
- `archived`

### Assignment status

- `draft`
- `scheduled`
- `active`
- `completed`
- `overdue`
- `cancelled`
- `archived`

### Completion status

- `not_started`
- `in_progress`
- `completed`
- `failed`
- `expired`

### Notification status

- `unread`
- `read`
- `archived`

## Enum Policy

- enums are declared centrally in shared contracts
- UI surfaces use localized labels mapped from enum values
- new enums are added only when a module boundary clearly requires them
