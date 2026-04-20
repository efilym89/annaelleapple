export const NOTIFICATION_STATUSES = [
  'unread',
  'read',
  'archived'
] as const;

export type NotificationStatus = (typeof NOTIFICATION_STATUSES)[number];
