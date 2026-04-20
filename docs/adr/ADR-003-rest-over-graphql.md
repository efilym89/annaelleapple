# ADR-003: REST Over GraphQL

## Status

Accepted

## Context

The project needs explicit, stable, AI-friendly contracts and clear separation between employee and admin APIs.

## Decision

Adopt REST API first with OpenAPI as the primary contract artifact.

## Consequences

Endpoint ownership, permissions, and DTO evolution stay easier to reason about than a shared GraphQL graph at this stage.
