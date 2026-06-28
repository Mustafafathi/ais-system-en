# Architecture Deep Dive: Thick Database Under Real Constraints

This repository documents an anonymized university attendance management system built for a constrained, legacy-friendly environment: PHP, Microsoft SQL Server, Windows Server, CSV exchange with ERP/1C, and signed webhooks from an access control system.

The original database scripts under `Database/*.sql` contain 42 unique SQL tables, 125 unique stored procedures, 17 unique triggers, and 98 unique `CREATE INDEX` definitions. The clean `Database/schema/` folder is a publication-safe skeleton and is not included in those counts. The main SQL Server export alone contains 34 tables, 90 stored procedures, 17 triggers, and 92 indexes.

## 1. The Core Trade-off

Most modern web applications put most business logic in an application service layer and use an ORM to persist state. I rejected that as the primary architecture here because the system had to fit a university environment with strict database access controls, limited deployment flexibility, and high reporting load.

The database is the enforcement boundary:

- Stored procedures validate actions before data changes.
- Triggers enforce audit and consistency rules close to the data.
- PHP acts as transport, session validation, request normalization, and UI delivery.
- Reporting queries stay inside SQL Server, reducing network round-trips and avoiding repeated aggregation in PHP.

This does not mean "put everything in SQL" blindly. It means the rules that must remain true even when the web layer changes are placed in the database contract.

## 2. Query and Index Strategy

The project is an attendance system operationally, but it becomes a reporting system very quickly. Curators, teachers, and administrators need fast answers for:

- students with repeated absences over a recent period;
- group attendance summaries;
- teacher workload and lesson status;
- QR scan history;
- SKUD event reconciliation;
- unresolved absence justifications;
- administrative audit review.

The original SQL source contains 98 unique `CREATE INDEX` definitions across the publication-audited database scripts. These indexes are not decorative. They target repeated reporting and lookup paths used by the PHP pages and stored procedures.

Key patterns:

- Composite indexes for group/date/status filters.
- Covering indexes for dashboard and report views.
- Filtered indexes for active workflow states, such as pending password recovery or unread notifications.
- Unique constraints for integrity, such as preventing duplicate QR scans and duplicate attendance records.
- Full-text support is enabled through `ftCatalog`, avoiding the worst cases of `LIKE '%term%'` for search-oriented features.

The source also includes an index maintenance stored procedure using `sys.dm_db_index_physical_stats`, with different behavior for reorganizing or rebuilding indexes based on fragmentation.

## 3. Partitioning and Audit Retention

The source defines:

- `pf_LogDate` as a SQL Server partition function;
- `ps_LogDate` as a partition scheme.

This shows the intended strategy for date-based log management. Audit and operational logs can grow quickly in an attendance system because every login, import, QR scan, attendance change, and integration event may produce a record.

Important limitation from the current source audit: the partition function and scheme are present, but the existing technical review notes that no attached partitioned table/index was found. In a production hardening pass, the next step is to bind the audit/log table to the partition scheme and define retention jobs.

## 4. Dynamic API Gateway

The gateway is the maintenance-saving part of the PHP layer.

Instead of writing a new PHP endpoint for every new feature, `api.php` validates an `action`, checks that a stored procedure exists in `INFORMATION_SCHEMA.ROUTINES`, reads parameter metadata from `INFORMATION_SCHEMA.PARAMETERS`, builds SQL Server bindings, and executes the procedure through `sqlsrv_prepare`.

The result:

- adding a feature usually means adding or changing a stored procedure;
- PHP does not need a new controller for every operation;
- procedure parameter metadata drives request binding;
- unauthorized actions still fail in the database layer when stored procedures check permissions.

The current UI references 67 unique API actions, and every referenced action has a matching SQL procedure definition in the database scripts.

## 5. Integration Resilience

### SKUD / Access Control

The SKUD endpoint is implemented as a signed webhook flow:

- source IP allowlist;
- `X-SKUD-Signature`;
- `X-SKUD-Timestamp`;
- `X-SKUD-Nonce`;
- `HMAC-SHA256` over timestamp, nonce, and the exact raw body;
- nonce cache to prevent replay.

The current implementation rejects stale timestamps outside a 60-second window and stores nonce hashes with a default 300-second TTL. Duplicate nonce events are treated as already handled rather than inserted twice.

An important business rule remains: a building entry event is not the same as classroom attendance. SKUD data is supplementary context for reconciliation, not an automatic "present" mark.

### ERP / 1C CSV Exchange

ERP integration is intentionally conservative. The source supports CSV import/export actions through the same procedure gateway:

- group import;
- student import;
- attendance export.

CSV normalization removes UTF-8 BOM, normalizes line endings, and uses semicolon-separated parsing for the import procedures. The current code also has delimiter detection support for headers. I did not find Windows-1251 conversion in the source, so this repository documents UTF-8 as the confirmed implementation and treats Windows-1251 as a possible future compatibility extension.

## 6. Operational Shape

The runtime is intentionally simple:

- PHP 8.x;
- SQL Server with `sqlsrv`;
- vanilla JavaScript;
- no mandatory PHP framework;
- file-backed local runtime cache for sessions, idempotency, and SKUD nonce tracking.

This is not a cloud-native microservice architecture. It is an institution-fit architecture: simple to deploy on Windows/XAMPP, strict at the database boundary, and explicit about integrations.


