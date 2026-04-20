# ADR-009: RBAC And Audit Logging

## Status

Accepted

## Context

The platform contains privileged content operations, assignment flows, and user data that require controlled access and traceability.

## Decision

Enforce RBAC on the backend and record all admin write operations in immutable audit logs.

## Consequences

Security remains a first-class concern, and administrative changes stay reviewable for support and compliance needs.
