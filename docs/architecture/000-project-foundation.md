# Project Foundation

## Goal Of The Step

Fix the architecture before framework code appears, so backend, mobile, and admin can be generated incrementally without boundary drift.

## What Is Fixed

- greenfield repository with no legacy assumptions
- one-company internal LMS, not multi-tenant SaaS
- Russian language for all end-user UI copy
- English naming for code, contracts, endpoints, classes, and files
- mobile-first product shape with a separate admin panel and shared backend API
- backend as a modular monolith
- REST API first
- monorepo as the repository strategy
- contracts first, implementation second
- selective offline support only where it improves lesson consumption

## Final Architecture Fixation

### Product contour

- `apps/mobile` will host the employee learning application
- `apps/admin` will host the internal admin panel for HR, admins, and super admins
- `apps/backend` will expose employee API and admin API under clear route separation

### Fixed stack

- mobile: `Flutter`
- backend: `NestJS`
- admin: `Next.js + React + TypeScript`
- data: `PostgreSQL`, `Redis`, S3-compatible storage
- auth: `OIDC / SSO` first, `JWT + refresh rotation` as fallback
- infra: `Docker`, CI/CD, feature flags, observability

### Core architecture rules

- one module owns one business context
- employee API and admin API stay separated
- domain does not depend on framework
- DTOs do not live in domain
- ORM entities never leak directly into responses
- controllers stay thin, application use cases stay explicit
- permissions, enums, and error codes remain centralized
- all admin write operations must be audit logged

## Module List

### Backend modules

- `auth`
- `users`
- `roles`
- `permissions`
- `departments`
- `courses`
- `modules`
- `lessons`
- `lesson-content`
- `tests`
- `questions`
- `answers`
- `assignments`
- `progress`
- `completion`
- `notifications`
- `analytics`
- `reporting`
- `audit`
- `files`

### Mobile feature modules

- `auth`
- `users`
- `courses`
- `lessons`
- `testing`
- `progress`
- `notifications`
- `profile`
- `admin_entry_optional`
- `offline_sync`
- `shared_ui`
- `core`

### Admin modules

- `auth`
- `dashboard`
- `users`
- `user-details`
- `courses`
- `course-editor`
- `lessons-editor`
- `tests-editor`
- `assignments`
- `analytics`
- `reports`
- `roles`
- `audit-log`

## Monorepo Structure

```txt
company-lms/
  apps/
    mobile/
    admin/
    backend/
  packages/
    shared-contracts/
    tooling/
    design-system/   # introduced at mobile/admin foundation
  docs/
    architecture/
    adr/
    api/
    prompts/
  infra/
    docker/
    compose/
    nginx/
    monitoring/
```

## Recommended Implementation Order

1. architecture fixation and ADR baseline
2. shared contracts, RBAC constants, error model, and status enums
3. backend foundation
4. mobile foundation
5. admin foundation
6. auth slice
7. courses slice
8. lessons slice
9. testing and progress slice
10. assignments and notifications slice
11. analytics and reporting slice

## ADR To Ratify

- `ADR-001` monorepo over polyrepo
- `ADR-002` modular monolith over microservices
- `ADR-003` REST API over GraphQL
- `ADR-004` Flutter for mobile
- `ADR-005` NestJS for backend
- `ADR-006` Next.js for admin
- `ADR-007` PostgreSQL as primary database
- `ADR-008` selective offline strategy
- `ADR-009` RBAC plus audit logging
- `ADR-010` contracts-first delivery
- `ADR-011` Russian UI as default
- `ADR-012` greenfield baseline with no legacy assumptions

## Step 1 Foundation Scaffold

The foundation scaffold created in this phase contains:
- root repository conventions and environment placeholders
- application directories without premature framework bootstrap
- `packages/shared-contracts` for roles, permissions, status enums, and errors
- `packages/tooling` for future shared TypeScript, ESLint, and Prettier configs
- architecture docs, ADRs, API base skeleton, and prompt-derived working rules
- `infra/` placeholders for delivery assets

## Next Step

`Step 2 - Backend foundation`: bootstrap `NestJS`, wire config and database boundaries, and introduce `auth`, `users`, and `roles` skeletons that consume the contracts fixed here.
