# Start Here

## Purpose

AIS Attendance System is a role-based attendance platform for an educational organization. It combines schedules, QR attendance, access-control integration, absence justifications, notifications, reports, and administrative tools.

## Local Launch Checklist

1. Start Apache in XAMPP.
2. Start SQL Server.
3. Confirm that SQL Server is reachable at the configured host and port.
4. Enable the PHP `sqlsrv` extension.
5. Apply the database scripts from `Database/`.
6. Configure environment variables using `.env.example` as a checklist.
7. Open the application URL configured in `AIS_SITE_URL`.

## Default Development URL

```text
http://localhost/ais-system-ru/
```

The copied repository can live under any Git folder, but the runtime application has public paths that were originally prepared for `/ais-system-ru/`.

## First Files to Review

- `README.md`
- `.env.example`
- `config.php`
- `api.php`
- `includes/auth_check.php`
- `includes/role_helpers.php`
- `docs/final-delivery/en/ARCHITECTURE.md`
