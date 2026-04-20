# ADR-012: Greenfield With No Legacy Assumptions

## Status

Accepted

## Context

The repository starts empty and should not inherit accidental constraints from hypothetical prior systems.

## Decision

Treat the project as a clean greenfield build with no assumed modules, migrations, or hidden infrastructure.

## Consequences

Architecture choices stay explicit, and generated code will not carry phantom compatibility layers.
