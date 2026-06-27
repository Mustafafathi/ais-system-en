# Security Policy

## Reporting

Report security issues privately to the project owner. Do not open public issues for vulnerabilities, exposed credentials, production data, authentication bypasses, or SQL injection concerns.

## Secrets

Never commit:

- GitHub personal access tokens.
- SQL Server passwords.
- HMAC/shared integration secrets.
- Real session identifiers or bearer tokens.
- Production `.env` files.
- Database dumps containing personal data.

If a secret is exposed, revoke it immediately and issue a replacement with the minimum required permissions.

## Deployment Baseline

- Use HTTPS in production.
- Set strong database credentials through environment variables.
- Restrict integration endpoints by IP allowlist and shared secret.
- Keep `AIS_DEBUG=false` outside local development.
- Limit write permissions on `runtime/` and `uploads/` to the web server identity.
- Review backup and export files before publishing a repository.
