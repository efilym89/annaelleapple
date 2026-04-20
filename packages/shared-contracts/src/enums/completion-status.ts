export const COMPLETION_STATUSES = [
  'not_started',
  'in_progress',
  'completed',
  'failed',
  'expired'
] as const;

export type CompletionStatus = (typeof COMPLETION_STATUSES)[number];
