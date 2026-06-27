# Architecture

## High-Level Structure

The system is a server-rendered PHP application with plain JavaScript enhancements. PHP pages render role-specific workspaces, while JavaScript calls `api.php` for data operations.

## Layers

- Presentation: PHP templates, role pages, shared navigation, CSS, and JavaScript.
- Application gateway: `api.php`, session validation, request parsing, idempotency cache, and stored procedure execution.
- Integration helpers: CSV normalizers, ACS/SKUD event handling, health checks, and procedure gateway helpers.
- Database: SQL Server schema, stored procedures, triggers, and migrations.
- Runtime storage: session fallback storage, upload folders, and idempotency cache files.

## Request Flow

1. User signs in through `login/index.php`.
2. Login JavaScript calls `api.php` with the public authorization procedure.
3. PHP session and browser local storage receive session identifiers.
4. Role-based pages call `api.php` with `session_id` and token.
5. `api.php` validates the session through SQL Server.
6. `api.php` executes the requested stored procedure and returns JSON.

## Design Decision: Preserve Russian Runtime Identifiers

The database and API contract use Russian identifiers. Translating those identifiers only in source files would break procedure calls, parameter binding, and response parsing. English documentation therefore explains the contract without changing it.
