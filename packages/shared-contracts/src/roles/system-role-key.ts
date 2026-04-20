export const SYSTEM_ROLE_KEYS = [
  'employee',
  'manager',
  'hr',
  'admin',
  'super_admin'
] as const;

export type SystemRoleKey = (typeof SYSTEM_ROLE_KEYS)[number];
