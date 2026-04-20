export const COURSE_STATUSES = [
  'draft',
  'review',
  'published',
  'archived'
] as const;

export type CourseStatus = (typeof COURSE_STATUSES)[number];
