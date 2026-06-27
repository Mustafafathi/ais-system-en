# System Overview

## Main Users

- Administrator: manages users, groups, reference data, reports, backups, monitoring, and system settings.
- Methodist: manages groups, subjects, teachers, and schedules.
- Teacher: views schedule, generates QR sessions, records attendance, and builds group reports.
- Curator: monitors assigned groups, students, justifications, and attendance reports.
- Student: views schedule and attendance, scans QR codes, submits justifications, and reads notifications.

## Main Workflows

- Authentication and session validation through the PHP API gateway.
- Role-based routing after login.
- Schedule review by role.
- QR generation by teacher and QR scan by student.
- Attendance journal maintenance.
- Absence justification submission and review.
- Administrative import/export and reports.
- Integration with CSV sources and access-control events.

## Data Contract

The application communicates with SQL Server through stored procedures. Procedure names, input parameters, output fields, and role names use the original Russian naming. They must stay aligned with the database scripts in `Database/`.

## Repository Packaging Goal

This English package is meant for GitHub publication, technical review, onboarding, and maintenance. It does not attempt to localize the running interface.
