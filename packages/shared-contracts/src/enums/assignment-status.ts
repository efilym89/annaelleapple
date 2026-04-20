export const ASSIGNMENT_STATUSES = [
  'draft',
  'scheduled',
  'active',
  'completed',
  'overdue',
  'cancelled',
  'archived'
] as const;

export type AssignmentStatus = (typeof ASSIGNMENT_STATUSES)[number];
