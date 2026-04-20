# Implementation Roadmap

## Delivery Order

1. Foundation scaffold
2. Backend foundation
3. Mobile foundation
4. Admin foundation
5. Auth slice
6. Courses slice
7. Lessons slice
8. Testing and progress slice
9. Assignments and notifications slice
10. Analytics and reporting slice

## Phase Details

### 1. Foundation scaffold

- repository structure
- docs, ADR, contracts, enums, error model
- root tooling and environment placeholders

### 2. Backend foundation

- NestJS bootstrap
- config and database boundaries
- auth, users, roles skeletons
- common guards, interceptors, pipes, audit base

### 3. Mobile foundation

- Flutter bootstrap
- router, theme, DI, storage, network, app error mapping

### 4. Admin foundation

- Next.js bootstrap
- layout shell, auth shell, admin navigation, API client

### 5. Auth slice

- sign-in flows for employee and admin
- session refresh
- role-aware route protection

### 6. Courses slice

- course list and details
- admin course management skeleton

### 7. Lessons slice

- lesson content delivery
- secure file access
- selective offline cache policy

### 8. Testing and progress slice

- quiz attempts
- progress events
- completion rules

### 9. Assignments and notifications slice

- targeted course assignment
- reminders and due dates
- user notification feed

### 10. Analytics and reporting slice

- dashboards
- exports
- background jobs and projections
