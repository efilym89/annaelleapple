# ADR-001: Monorepo Over Polyrepo

## Status

Accepted

## Context

The product includes backend, mobile, admin, shared contracts, and architecture docs that must evolve in lockstep.

## Decision

Use a monorepo with `apps/`, `packages/`, `docs/`, and `infra/`.

## Consequences

Shared contracts and architecture rules stay versioned together, and AI-driven generation remains predictable across surfaces.
