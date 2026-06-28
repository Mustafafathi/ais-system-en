# Development Governance and AI Use

AIS Attendance Platform was developed with a governed human-led process. AI assistance was used for execution speed, not for architectural ownership.

## Human-Owned Decisions

The system design, database contract, integration model, security posture, and economic assumptions were defined and reviewed by the project owner.

Human-owned work included:

- domain analysis for university attendance workflows;
- thick database architecture;
- SQL Server schema, stored procedure, trigger, and index strategy;
- QR attendance transaction model;
- SKUD webhook security model;
- ERP/1C CSV exchange model;
- RBAC and audit boundaries;
- economic value model;
- final review and correction of implementation output.

## AI-Assisted Work

AI was used as an implementation accelerator for repetitive and specification-driven tasks:

- generating PHP/HTML UI scaffolding from predefined workflows;
- drafting repeated validation and layout patterns;
- generating synthetic mock-data patterns;
- normalizing documentation language;
- assisting with refactoring suggestions.

## Governance Boundary

AI-generated output was treated as implementation material requiring review. It did not define product requirements, database rules, security controls, or economic assumptions.

The repository therefore presents AI use as a controlled engineering tool: useful for throughput, but subordinate to human system design and acceptance criteria.
