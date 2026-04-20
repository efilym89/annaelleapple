# ADR-002: Modular Monolith Over Microservices

## Status

Accepted

## Context

The platform is greenfield, internal, and single-company, so early operational complexity would outweigh benefits.

## Decision

Start with a modular monolith that enforces module boundaries inside one backend deployment unit.

## Consequences

The system stays simpler to deliver and operate while preserving a future path to extraction if proven necessary.
