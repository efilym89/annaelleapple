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

## О проекте ANNAELLE

Каркас внутренней обучающей платформы (LMS) ANNAELLE: мобильное приложение, сервер и веб-админка. Находится на стадии «Foundation scaffold» — только архитектурные документы, контракты и базовые соглашения (`docs/`, `conventions.md`, `vision.md`, `idea.md`); в бою не работает, серверов нет. Действующие приложения академии — отдельные репозитории `efilym89/annaelle` (iOS + сервер) и `efilym89/annaelle-android`.

> Репозиторий **публичный**: не размещайте здесь ключи, адреса боевых серверов, данные клиентов и сотрудников.

## История изменений

Новое сверху (даты — по git).

- **2026-11-26** — наведён порядок на GitHub: описание проекта, история и `AGENTS.md` (PR из ветки `claude/readme-history-20261126`).
- **2026-04-20** — импорт проекта: монорепозиторий (`apps/`, `packages/`, `docs/`, `infra/`), контракты ролей и прав.
- **2026-04-09** — первая фиксация.
