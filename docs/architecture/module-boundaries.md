# Module Boundaries

## Boundary Rules

- one module owns one business context
- modules communicate through explicit contracts and use cases
- avoid direct persistence access across modules
- admin routes live under `/api/v1/admin/...`
- employee routes live under `/api/v1/...`

## Backend Ownership

| Module | Owns | May depend on | Must not own |
| --- | --- | --- | --- |
| `auth` | sign-in, session lifecycle, token rotation, OIDC bridge | `users`, `roles` | profile editing, course access logic |
| `users` | user identity, profile baseline, employment status | `departments`, `roles` | auth sessions, course assignments |
| `roles` + `permissions` | role mapping, permission grants | none | user profile data |
| `departments` | organization tree and assignment scope | `users` | course catalog |
| `courses` | course metadata, versions, publishing state | `files` | progress tracking |
| `modules` + `lessons` + `lesson-content` | learning structure and delivery metadata | `courses`, `files` | assessments and assignments |
| `tests` + `questions` + `answers` | assessment authoring and attempt rules | `courses`, `lessons` | notifications |
| `assignments` | targeting rules, due dates, activation lifecycle | `courses`, `users`, `departments`, `roles` | course content editing |
| `progress` + `completion` | progress state, completion rules, progress events | `assignments`, `tests`, `lessons` | content authoring |
| `notifications` | user-facing alerts and delivery metadata | `assignments`, `progress` | assignment policy |
| `analytics` + `reporting` | projections, dashboards, exports | read access to many modules | source-of-truth writes |
| `audit` | immutable admin activity trail | all admin write modules | business state management |
| `files` | file metadata, signing, access policy | `auth` | course structure or progress logic |

## Frontend Boundaries

- mobile focuses on learning consumption and personal progress
- admin focuses on operations, authoring, assignments, analytics, and audit review
- UI modules consume shared contracts through stable mapping layers, not backend persistence models
