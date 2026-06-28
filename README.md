# AIS Attendance Platform

AIS Attendance Platform is an on-premise university attendance management system for institutions that need reliable attendance capture, controlled integrations, and auditable governance without introducing a cloud dependency.

The product combines QR-based classroom attendance, role-based workspaces, absence justification workflows, reporting, ERP/1C CSV exchange, and signed access-control-system webhooks. It is designed for environments where Microsoft SQL Server, Windows Server, and strict personal-data handling are operational realities.

This public repository is an anonymized distribution. Institutional names, personal data, internal paths, secrets, and production identifiers have been removed.

## Product Scope

AIS covers the daily attendance lifecycle from schedule to reporting:

- teachers open lessons, generate QR sessions, and mark attendance;
- students scan QR codes, view attendance, and submit absence justifications;
- curators monitor group risk and repeated absences;
- methodists maintain groups, subjects, teachers, and schedule data;
- administrators manage users, roles, imports, exports, monitoring, and maintenance;
- integration endpoints accept signed SKUD events and CSV data exchange with ERP/1C.

## Core Capabilities

| Area | Capability |
| --- | --- |
| Attendance capture | QR sessions, manual marks, duplicate prevention, session validation |
| Absence workflow | Student excuse submission, review states, automatic attendance update on approval |
| Role workspaces | Administrator, methodist, teacher, curator, and student interfaces |
| Reporting | Group, student, teacher, schedule, attendance, and administrative reports |
| Integration | ERP/1C CSV import/export and SKUD webhook ingestion |
| Security | Session validation, dynamic RBAC, HMAC-SHA256 webhooks, nonce replay protection |
| Audit | Database-side logging for operational and security-sensitive actions |
| Operations | Health checks, maintenance actions, index servicing, backup metadata, runtime folders |

## Architecture Snapshot

The platform uses a thick database architecture. Business rules live in SQL Server stored procedures and triggers, while PHP provides transport, session handling, request normalization, and UI delivery.

The original database scripts under `Database/*.sql` contain:

| Object Type | Count |
| --- | ---: |
| Unique tables | 42 |
| Unique stored procedures | 125 |
| Unique triggers | 17 |
| Unique `CREATE INDEX` definitions | 98 |

The public `Database/schema/` folder provides a clean, anonymized skeleton for review and onboarding. The larger database export is preserved as implementation reference after removing exported personal-data rows.

See [ARCHITECTURE.md](ARCHITECTURE.md) for the system design.

## Business Value

The reference economic model values recovered administrative time rather than staff reduction.

| Indicator | Value |
| --- | ---: |
| Annual recovered time | 544 hours |
| Annual recovered time value | 272,000 RUB |
| Annual OPEX | 52,000 RUB |
| Annual net cash flow | 220,000 RUB |
| Reference CAPEX | 0 RUB |
| 5-year NPV | 833,954 RUB |

See [ECONOMICS.md](ECONOMICS.md) for the calculation model.

## Technology Stack

- PHP 8.2 and Apache
- Microsoft SQL Server 2022
- `sqlsrv` / `pdo_sqlsrv`
- HTML5, CSS3, vanilla JavaScript
- CSV exchange for ERP/1C
- HMAC-SHA256 webhooks for SKUD/access-control events
- Docker Compose for disposable local evaluation

## Repository Layout

```text
admin/                  Administrator workspace
assets/                 CSS, JavaScript, images, and client assets
curator/                Curator workspace
Database/               SQL Server implementation scripts and clean schema skeleton
docs/                   Delivery and technical documentation
includes/               Shared layout, auth, navigation, and role helpers
integration/            CSV, SKUD, health, and procedure-gateway helpers
login/                  Login, logout, and session bridge
methodist/              Methodist workspace
runtime/                Runtime storage, ignored except .gitkeep placeholders
student/                Student workspace
teacher/                Teacher workspace
uploads/                User uploads, ignored except .gitkeep placeholders
```

## Run Locally with Docker

1. Copy `.env.example` to `.env`.
2. Replace all `CHANGE_ME_*` values.
3. Start the stack:

```powershell
docker compose up -d
```

The Docker image builds PHP with SQL Server drivers. The application is served on `http://localhost:8080/`.

## Run on Existing Windows/XAMPP Infrastructure

1. Install Apache/PHP and enable the `sqlsrv` extension.
2. Install or connect to Microsoft SQL Server.
3. Copy `config.example.php` to ignored local `config.php`.
4. Configure database and integration secrets through environment variables.
5. Apply the database scripts required by your environment.
6. Open the configured `AIS_SITE_URL`.

## Configuration

The application reads these environment variables:

```text
AIS_SITE_URL
AIS_DEBUG
AIS_TIMEZONE
AIS_SESSION_LIFETIME_MINUTES
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

`config.php`, `.env`, logs, uploads, runtime data, Word documents, Excel workbooks, and local exports are intentionally ignored.

## Security

Start with [SECURITY.md](SECURITY.md). The public baseline includes:

- no committed live configuration;
- no real university data;
- anonymized branding;
- signed SKUD webhooks;
- nonce replay protection;
- database-side audit and authorization boundaries;
- CI checks for PHP syntax and known sensitive patterns.

## Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - system architecture and design trade-offs
- [ECONOMICS.md](ECONOMICS.md) - business value model
- [SECURITY.md](SECURITY.md) - security controls and publication checklist
- [AI_COLLABORATION.md](AI_COLLABORATION.md) - development governance and AI-use disclosure
- [docs/final-delivery/en/START_HERE.md](docs/final-delivery/en/START_HERE.md) - delivery documentation index

## License

No open-source license grant is included by default. Add the license selected by the project owner before distributing the repository publicly.
