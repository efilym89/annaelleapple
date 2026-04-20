# Codex Working Rules

Repository-local summary derived from the external master prompt.

## Non-Negotiable Defaults

- treat the project as greenfield
- keep the backend as a modular monolith
- keep the repository as a monorepo
- prioritize contracts before implementation
- keep end-user UI text in Russian
- keep code identifiers in English
- avoid microservices, GraphQL, CQRS, and event sourcing unless a later ADR explicitly justifies them

## Delivery Style

- generate work in bounded vertical slices
- do not rewrite architecture casually between steps
- keep one module responsible for one business context
- prefer simple, explainable decisions over fashionable complexity

## Security Baseline

- backend owns authorization
- RBAC is mandatory
- all admin write actions are auditable
- access tokens are short-lived
- refresh tokens rotate
- files use secure signed access patterns
