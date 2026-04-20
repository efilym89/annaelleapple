# Entities And Relationships

## Security And Organization

- `User` belongs to one `Department`
- `User` can have multiple `Role`
- `Role` aggregates multiple `Permission`

## Learning Catalog

- `Course` contains multiple `Module`
- `Module` contains multiple `Lesson`
- `Lesson` contains multiple `LessonContent`
- `CourseVersion` snapshots a publishable version of a `Course`

## Assessment

- `Test` belongs to a `Course` or `Lesson`
- `Test` contains multiple `Question`
- `Question` contains multiple `AnswerOption`
- `QuizAttempt` belongs to one `User` and one `Test`

## Assignment And Progress

- `Assignment` points to one `Course`
- `Assignment` targets a `User`, `Department`, or `Role` scope
- `UserProgress` belongs to one `User` and references `Course`, `Module`, or `Lesson` state
- `ProgressEvent` belongs to one `User` and captures meaningful state change
- `CompletionRecord` confirms completion or failure for `Course`, `Lesson`, or `Test`

## Operations And Support

- `Notification` belongs to one `User`
- `FileAsset` attaches to course content, submissions, or profile-owned artifacts
- `AdminAuditLog` captures one admin actor and one target entity reference

## Aggregate Guidance

- catalog aggregate: `Course -> Module -> Lesson -> LessonContent`
- assessment aggregate: `Test -> Question -> AnswerOption`
- assignment aggregate: `Assignment -> target scope + Course`
- progress aggregate: `UserProgress + ProgressEvent + CompletionRecord + QuizAttempt`
- security aggregate: `User + Role + Permission + Department`
