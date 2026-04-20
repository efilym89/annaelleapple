# Error Model

## Unified Error Shape

```json
{
  "code": "VALIDATION_FAILED",
  "message": "Не удалось обработать запрос.",
  "traceId": "3f8646a3e5084e7b",
  "timestamp": "2026-04-09T12:00:00.000Z",
  "details": {
    "violations": [
      {
        "field": "email",
        "message": "Укажите корректный адрес электронной почты."
      }
    ]
  }
}
```

## Required Fields

- `code` machine-readable centralized error key
- `message` Russian human-readable message for end-user surfaces
- `traceId` correlation identifier for support and observability
- `timestamp` server-side UTC timestamp
- `details` optional typed payload for validation or resource context

## Initial Error Groups

- authentication: invalid credentials, expired session, invalid refresh token
- authorization: unauthorized, forbidden, file access denied
- validation: malformed payload, rule violation
- business: course not assigned, lesson not available, duplicate assignment
- system: rate limited, internal server error

## Mapping Policy

- backend owns the final mapping from exceptions to common error codes
- admin and mobile UI map common error codes to localized recovery flows
- raw infrastructure errors must not leak to API clients
