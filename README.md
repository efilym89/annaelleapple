# Company LMS

Greenfield monorepo foundation for an internal corporate LMS / EdTech platform.

Current phase: `Step 1 - Foundation scaffold`

Core decisions fixed for the project:
- one-company internal platform only
- Russian-language end-user UI
- English naming for code, DTOs, API, classes, and files
- backend as a modular monolith
- mobile-first product shape with a separate admin panel
- contracts first, implementation second

Planned stack:
- `Flutter` for mobile
- `NestJS` for backend
- `Next.js + React + TypeScript` for admin
- `PostgreSQL`, `Redis`, and S3-compatible object storage

Repository areas:
- `apps/` application entry points
- `packages/` shared contracts and tooling
- `docs/` architecture, ADR, API, and working rules
- `infra/` infrastructure placeholders for local and production delivery

The repository intentionally starts from architecture documents, contracts, and base conventions before framework bootstrapping.
