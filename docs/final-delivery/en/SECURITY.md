# Security

## Authentication

The system uses SQL-backed authentication and session validation. Browser code stores session identifiers and tokens in local storage and mirrors the session into PHP where needed.

## Authorization

Role checks are enforced by `includes/auth_check.php` and role-specific pages. Navigation also depends on database-provided role and permission data.

## Sensitive Data

Do not publish:

- GitHub personal access tokens.
- SQL Server credentials.
- Session IDs and bearer tokens.
- Production `.env` files.
- Database dumps with real user data.
- Uploads containing personal documents.

## Token Exposure Response

If a GitHub token is pasted into chat, committed, logged, or shared accidentally:

1. Revoke it in GitHub immediately.
2. Create a new token with only the scopes needed.
3. Check repository history and logs for accidental persistence.
4. Rotate any downstream secrets that may have been accessed.

## SQL Safety

The API gateway validates action names and uses SQL Server parameter binding. Continue using stored procedures and parameterized calls for new database operations.
