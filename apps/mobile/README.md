# Mobile App

`apps/mobile` contains the MVP Flutter application for the staff learning product.

## Why Flutter

The repository already fixed `Flutter` as the mobile stack, so the MVP implementation stays aligned with the accepted architecture while keeping one codebase for `iOS` and `Android`.

## Current Scope

The mobile MVP includes:

- home dashboard with company news and non-course materials;
- course catalog based on local storage data;
- course details and lesson list;
- lesson screen with metadata, materials, and progress actions;
- profile screen with integrated progress summary;
- loading, empty, and error states.

## Layers

- `lib/data` reads and maps local content;
- `lib/domain` contains entities and repository contracts;
- `lib/features` contains UI screens and presentation widgets;
- `lib/core` contains theme and shared UI helpers.

## Local Content Source

During MVP the app does not use a cloud backend. Instead, a small import script reads:

`C:\Users\efily\Downloads\anaelacademy\anaelacademy\storage`

and generates:

`assets/data/local_content_manifest.json`

Run the import from the repository root:

```bash
node apps/mobile/scripts/sync-local-content.mjs
```

or:

```bash
npm run mobile:sync-content
```

## Assumptions

- storage currently contains lesson metadata and local files, but not a question bank;
- quiz logic is therefore postponed and the lesson screen focuses on learning materials;
- company news and non-course materials are seeded locally for the home dashboard until backend APIs appear.

## Future Backend Migration

The app already depends on repository interfaces instead of file paths. To move to cloud later:

1. keep the domain entities unchanged;
2. replace the local repository implementation with an API-backed one;
3. keep the UI layer untouched except for dependency wiring;
4. gradually replace local seeded news and progress persistence with backend endpoints.
