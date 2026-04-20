# ADR-010: Contracts-First Delivery

## Status

Accepted

## Context

The project will be generated iteratively and must avoid divergence between backend, admin, and mobile.

## Decision

Define shared contracts, RBAC, enums, and error models before business module implementation.

## Consequences

Later code generation can reuse stable boundaries instead of inventing new DTOs and conventions per slice.
