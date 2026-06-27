# Operations

## Deployment Checklist

- Configure Apache/XAMPP document root or virtual host.
- Confirm `AIS_SITE_URL` matches the public base URL.
- Enable required PHP extensions, especially `sqlsrv`.
- Configure SQL Server connectivity and credentials through environment variables.
- Apply database scripts and verify stored procedure availability.
- Ensure `runtime/` and `uploads/` are writable by the web server identity.
- Keep `AIS_DEBUG=false` in production.

## Runtime Directories

- `runtime/sessions/`: fallback PHP session storage.
- `runtime/idempotency/`: API idempotency replay cache.
- `uploads/`: user-provided files.

These directories are ignored by Git except placeholders.

## Backups

Back up the SQL Server database before migrations and on a regular schedule. Store backups outside the web root. Do not commit backups to Git.

## Logs and Monitoring

Review application logs, SQL Server logs, integration audit output, and administrative monitoring pages. Avoid publishing logs because they can contain names, identifiers, IP addresses, or operational details.

## Production Hardening

- Use HTTPS.
- Use unique production secrets.
- Restrict integration endpoints.
- Disable debug output.
- Review upload file policies.
- Keep PHP, SQL Server drivers, and XAMPP components updated.
