# Security Model

AIS Attendance Platform is designed for controlled university environments where attendance data, user accounts, integration events, and audit records must be handled as sensitive institutional information.

The public distribution is anonymized and must remain free of real credentials, personal data, institutional identifiers, internal IP addresses, and local installation paths.

## 1. Secret Handling

Never commit:

- SQL Server passwords;
- HMAC/shared integration secrets;
- real session identifiers or bearer tokens;
- production `.env` files;
- private keys or certificates;
- database dumps containing personal data.

Use `config.example.php` and `.env.example` as templates. Local development must create an ignored `config.php` or `.env` file.

## 2. Authentication

The reference SQL implementation stores password material as SHA-256 hashes with per-user salts. The SQL layer uses `HASHBYTES('SHA2_256', password + salt)` and `CRYPT_GEN_RANDOM` for salt generation.

Password recovery tokens include attempt limiting; the confirmation flow rejects recovery attempts after the configured threshold is reached.

Recommended production hardening:

- replace raw SHA-256 password hashing with Argon2id or bcrypt through PHP `password_hash()`;
- apply login lockout or adaptive throttling for repeated failed password attempts;
- rotate recovery-token and webhook secrets on an institutional schedule.

## 3. Authorization

Authorization is role-based and database-backed. The UI hides unavailable actions, but stored procedures remain the authoritative enforcement layer.

This double-check model protects the product when a user bypasses the interface and calls the API directly:

- UI navigation is generated from role capabilities;
- API calls require session validation except for the public allowlist;
- stored procedures validate permissions before sensitive mutations.

## 4. Dynamic Procedure Gateway

The PHP API validates action names, checks `INFORMATION_SCHEMA.ROUTINES`, reads `INFORMATION_SCHEMA.PARAMETERS`, and binds JSON request data to stored procedure parameters.

The public procedure allowlist is intentionally small:

- `Авторизация`
- `ВосстановитьПароль`
- `ПодтвердитьВосстановлениеПароля`
- `ПроверитьСессию`

All other procedure calls require a valid session token.

## 5. SKUD Webhook Security

The access-control-system integration verifies:

- source IP allowlist;
- `X-SKUD-Signature`;
- `X-SKUD-Timestamp`;
- `X-SKUD-Nonce`;
- HMAC-SHA256 over timestamp, nonce, and raw body;
- nonce replay cache.

The webhook validator rejects stale timestamps outside a 60-second window and uses a 300-second default nonce TTL. Duplicate nonce events are accepted as already handled and are not inserted twice.

## 6. Audit and Logging

The database layer includes 17 unique triggers in the implementation scripts. Audit and log records capture:

- user id;
- action;
- table and record id;
- timestamp;
- IP address;
- device;
- browser;
- parameters/result;
- status;
- execution time.

Integration requests are additionally logged through the integration audit helper, which redacts sensitive headers such as authorization and SKUD signatures.

## 7. Honeypot

`scripts/honeypot.ps1` is an educational TCP 1433 listener for a controlled lab environment. It records connection attempts after moving the real SQL Server service away from the default public-facing port.

This is not production IDS tooling and does not replace firewall rules, SIEM, endpoint monitoring, or network segmentation.

## 8. Publication Checklist

Before publishing a distribution:

- run the secret scan workflow;
- confirm `config.php` is absent from Git;
- keep `runtime/` and `uploads/` empty except `.gitkeep` files;
- remove or anonymize SQL exports that contain real `INSERT` data;
- replace institution-specific names with `[University Name Redacted]`.
