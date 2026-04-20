# Coding Conventions

## Language Rules

- end-user UI strings must be in Russian
- code-level names stay in English
- do not mix Russian and English inside the same UI surface

## Naming

- modules use short business names such as `auth`, `courses`, `progress`
- use cases use `Verb + Object + OptionalContext`
- DTOs use `CreateXRequestDto`, `UpdateXRequestDto`, `XResponseDto`
- controllers use explicit module names such as `AdminCoursesController`
- endpoint naming stays REST-oriented and plural where appropriate

## Layering

- presentation never reaches infrastructure directly
- domain stays framework-agnostic
- repository interfaces live in domain or application contracts
- repository implementations live in infrastructure or data
- UI consumes mapped view models, not raw DTOs

## Module Discipline

- one module owns one business context
- avoid large unstructured shared folders
- add dependencies only when a module cannot express its boundary without them
- do not generate multiple business slices in one step

## API Conventions

- employee and admin routes are separated
- write operations that change admin-owned state must be auditable
- permission checks are enforced on the backend
- common errors map to a centralized error model
