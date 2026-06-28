# AI Collaboration Strategy

This project used a "Human Architect, AI Executor" model.

## My Role

The human-owned work was the architectural and analytical core:

- domain analysis of the university attendance workflow;
- thick database architecture;
- SQL Server schema, stored procedure, trigger, and index strategy;
- QR attendance transaction design;
- SKUD webhook integration model;
- CSV exchange model for ERP/1C;
- security layers and audit requirements;
- economic model and feasibility narrative;
- review and correction of generated implementation code.

The original database scripts under `Database/*.sql` contain 42 unique SQL tables, 125 unique stored procedures, 17 unique triggers, and 98 unique `CREATE INDEX` definitions. The clean `Database/schema/` folder is a publication-safe skeleton and is not included in those counts.

## AI's Role

AI was used as an implementation assistant for repetitive and mechanical work:

- scaffolding responsive PHP/HTML pages from already-defined workflows;
- drafting UI blocks and validation patterns;
- helping normalize documentation wording;
- generating synthetic test-data patterns where real personal data must not be used;
- refactoring repetitive client-side and PHP helper code.

The current role-based UI contains 45 PHP workspace pages across administrator, student, teacher, curator, and methodist areas.

## Boundary

AI did not decide the architecture. It did not define the database contract, the economic model, the integration security model, or the compliance requirements.

Using AI here is comparable to delegating implementation tasks to a junior developer after the architecture, constraints, and acceptance criteria are already defined. The engineering value is in the decisions, review, and system fit, not in pretending every line was typed manually.

