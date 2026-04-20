# ADR-007: PostgreSQL As Primary Database

## Status

Accepted

## Context

The LMS domain requires strong relational modeling for users, roles, assignments, progress, and reporting.

## Decision

Use PostgreSQL as the primary system of record, with Redis for cache or queue support and S3-compatible storage for files.

## Consequences

Relational integrity remains strong, reporting stays straightforward, and storage concerns remain cleanly separated.
