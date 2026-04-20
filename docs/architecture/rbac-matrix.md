# RBAC Matrix

## Fixed Roles

- `employee`
- `manager`
- `hr`
- `admin`
- `super_admin`

## Role Responsibilities

| Role | Main surface | Core permissions | Scope rule |
| --- | --- | --- | --- |
| Employee | Mobile app | `courses.read_assigned`, `lessons.read_assigned`, `tests.attempt`, `assignments.read_self`, `progress.read_self`, `notifications.read_self`, `profile.read_self`, `profile.update_self`, `files.read` | Self only |
| Manager | Mobile app + limited admin views | Employee permissions plus `dashboard.read`, `users.read`, `users.read_details`, `progress.read_team`, `reports.export` | Managed team or department only |
| HR | Admin panel | Manager permissions plus `departments.read`, `assignments.manage`, `analytics.read` | HR-visible departments only |
| Admin | Admin panel | HR permissions plus `courses.read_catalog`, `courses.manage`, `lessons.manage`, `tests.manage`, `notifications.manage`, `files.manage`, `roles.read` | Company-wide operational scope |
| Super Admin | Admin panel | All permissions including `users.manage`, `roles.manage`, `permissions.read`, `departments.manage`, `audit.read`, `progress.manage` | Full company scope |

## Permission Design Rules

- permissions are action-focused and centrally declared in shared contracts
- role grants define the maximum permission set
- resource-level rules further narrow access by department, target user, or assignment scope
- employee API and admin API must each check permissions independently on the backend

## Initial Bundles

### Employee bundle

- `courses.read_assigned`
- `lessons.read_assigned`
- `tests.attempt`
- `assignments.read_self`
- `progress.read_self`
- `notifications.read_self`
- `profile.read_self`
- `profile.update_self`
- `files.read`

### Admin growth path

- managers add observational scope
- HR adds assignment and analytics scope
- admins add content operations
- super admins add security and audit scope
