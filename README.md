# AIS Attendance System

AIS Attendance System is a PHP and SQL Server web application for managing student attendance, schedule visibility, QR-based attendance capture, absence justifications, notifications, reports, and administrative operations.

This repository is prepared as an English, GitHub-ready package. The runtime application source remains in its original Russian-language domain model because stored procedure names, database columns, roles, and API action names are part of the working SQL Server contract.

## Project Status

- Runtime UI and database contract: kept unchanged.
- Repository documentation: English.
- Original Russian delivery documentation: preserved under `docs/final-delivery/ru/`.
- English delivery documentation: available under `docs/final-delivery/en/`.

## Core Capabilities

- Role-based workspaces for administrator, methodist, teacher, curator, and student users.
- QR attendance sessions and student QR scanning.
- Schedule views for students, teachers, curators, methodists, and administrators.
- Attendance journals, reports, absence justification workflows, and notifications.
- CSV and access-control-system integration endpoints.
- Offline request queue support for unstable network conditions.
- SQL Server stored procedure gateway with session validation and idempotency support.

## Technology Stack

- PHP 8.x on Apache/XAMPP.
- Microsoft SQL Server with the `sqlsrv` PHP extension.
- Plain JavaScript, HTML, and CSS.
- Local QR libraries in `assets/vendor/`.
- File-based runtime folders for sessions, temporary files, and idempotency cache.

## Repository Layout

```text
admin/                  Administrator workspace
assets/                 CSS, JavaScript, images, and local vendor assets
curator/                Curator workspace
Database/               SQL Server schema, procedures, triggers, and migrations
docs/final-delivery/en/ English delivery documentation
docs/final-delivery/ru/ Original Russian delivery documentation
includes/               Shared layout, auth, navigation, and role helpers
integration/            CSV, ACS/SKUD, health, and procedure gateway helpers
login/                  Login, logout, and PHP session bridge
methodist/              Methodist workspace
runtime/                Local runtime storage, ignored by Git except placeholders
student/                Student workspace
teacher/                Teacher workspace
uploads/                User uploads, ignored by Git except placeholders
```

## Quick Start

1. Install and start Apache through XAMPP.
2. Install SQL Server and make it reachable at `localhost,15432`, or override the host and port through environment variables.
3. Enable the PHP `sqlsrv` extension.
4. Import or apply the SQL scripts from `Database/` in the expected order for your environment.
5. Configure environment variables based on `.env.example`.
6. Open the application at the configured `AIS_SITE_URL`.

Default local URL used by the original package:

```text
http://localhost/ais-system-ru/
```

If you deploy the application under another folder, review the hardcoded public paths before using it in production.

## Configuration

The application reads these environment variables when available:

```text
AIS_SITE_URL
AIS_DEBUG
AIS_DB_HOST
AIS_DB_PORT
AIS_DB_NAME
AIS_DB_USER
AIS_DB_PASSWORD
AIS_DB_ENCRYPT
AIS_DB_TRUST_SERVER_CERT
AIS_SKUD_SECRET
AIS_HEALTH_SECRET
AIS_INTEGRATION_ALLOWLIST
```

Use `.env.example` as a checklist. Copy `config.example.php` to `config.php` for local non-Docker development. Do not commit real credentials, GitHub tokens, database passwords, signing secrets, or production allowlists.


## Engineering Deep Dives

- `ARCHITECTURE.md` explains the thick database trade-off, gateway design, indexing strategy, partitioning status, and integration resilience.
- `ECONOMICS.md` translates the economic workbook into auditable NPV and cash-flow figures.
- `AI_COLLABORATION.md` documents how AI was used as an implementation assistant while architecture and review remained human-owned.

## Docker Compose

For a disposable local environment, copy `.env.example` to `.env`, replace `CHANGE_ME_*` values, then run:

```powershell
docker compose up -d
```

The current Compose file reflects the existing repository layout where the PHP application lives at the repository root. The container mounts `config.example.php` as `config.php`; for non-Docker local development, create your own ignored `config.php` copy.
## Documentation

Start here:

- `docs/final-delivery/en/START_HERE.md`
- `docs/final-delivery/en/SYSTEM_OVERVIEW.md`
- `docs/final-delivery/en/ARCHITECTURE.md`
- `docs/final-delivery/en/OPERATIONS.md`
- `docs/final-delivery/en/SECURITY.md`

## Security Notice

Never paste personal access tokens into chat, issues, commits, documentation, or source code. If a token was exposed, revoke it in GitHub immediately and create a new one with the minimum required scopes.

## GitHub Publishing

```powershell
cd [INSTALL_PATH]/ais-university-attendance-system
git remote add origin https://github.com/<your-user>/<your-repo>.git
git push -u origin main
```

Use a fresh token only when Git prompts for credentials. Do not store the token in repository files.

## License

No open-source license grant is included by default. Add the license selected by the project owner before distributing the repository publicly.
