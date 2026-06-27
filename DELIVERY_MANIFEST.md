# Delivery Manifest

## Package

AIS Attendance System, English repository package.

## Included

- PHP application source.
- SQL Server scripts and migrations.
- Local frontend assets and QR libraries.
- Original Russian documentation in `docs/final-delivery/ru/`.
- English repository and delivery documentation in `docs/final-delivery/en/`.
- GitHub repository metadata and CI lint workflow.

## Not Included

- Production credentials.
- GitHub personal access tokens.
- Production database dumps.
- Runtime session/cache/upload data.

## Important Compatibility Note

The application source keeps Russian stored procedure names, database fields, role names, and API actions. These values are runtime contracts and must match the deployed SQL Server database.
