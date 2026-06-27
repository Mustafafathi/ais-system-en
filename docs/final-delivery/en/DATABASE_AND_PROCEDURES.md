# Database and Procedures

## Database Platform

The system uses Microsoft SQL Server. PHP connects through the `sqlsrv` extension and calls stored procedures through `api.php`.

## SQL Assets

The `Database/` directory contains schema, migration, trigger, integration, report, and administrative SQL scripts. The exact execution order depends on the target database state.

Key files include:

- `Улучшенная.sql`: main database script.
- `Дополнения.sql`: additional database objects.
- `Integration SP.sql`: integration stored procedures.
- `admin_roles_permissions.sql`: administrative role and permission support.
- `scheduled_reports_agent.sql`: scheduled reporting support.
- `password_reset_database_mail.sql`: password reset support.
- `schedule_overview_migration.sql`: schedule overview migration.

## Procedure Gateway

`api.php` receives an `action` value and maps it to a stored procedure with the same name. Parameters can be passed as named JSON properties. The gateway reads metadata from `INFORMATION_SCHEMA.PARAMETERS` and binds inputs dynamically.

## Compatibility Rules

- Do not rename stored procedures without updating all clients.
- Do not translate parameter names unless the SQL procedure signature changes too.
- Keep result set field names stable because PHP and JavaScript pages read them directly.
- Treat role names such as `Студент`, `Преподаватель`, `Куратор`, and `Методист` as database values, not UI copy.

## Backup Before Migration

Always create a database backup before applying scripts to a non-local environment. Validate migrations in a staging database first.
