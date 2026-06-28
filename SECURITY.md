# Security Model

This repository is an anonymized portfolio version of a university attendance management system. It must not contain real credentials, personal data, institutional identifiers, internal IP addresses, or local installation paths.

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

The SQL source stores password material as SHA-256 hashes with per-user salts. The source contains repeated use of `HASHBYTES('SHA2_256', password + salt)` and `CRYPT_GEN_RANDOM` for salt generation.

Important source-derived limitation: the current `Авторизация` procedure logs failed login attempts, but the source does not implement account lockout after 5 failed login attempts in the normal login flow. The `>= 5` attempt limit exists in the password recovery token confirmation flow. This repository documents the current code honestly rather than overstating the control.

For a new production build, PHP `password_hash()` with Argon2id or bcrypt should replace raw SHA-256 password hashing.

## 3. Authorization

The system uses role-based access control through database roles, permissions, and stored procedures. The UI hides unauthorized navigation items, but the stronger control is procedure-level validation inside SQL Server.

This matters because UI-only authorization can be bypassed by direct API calls. Database-side checks keep the rule close to the data mutation.

## 4. Dynamic Procedure Gateway

The PHP API validates an action name, checks `INFORMATION_SCHEMA.ROUTINES`, reads `INFORMATION_SCHEMA.PARAMETERS`, and binds JSON request data to stored procedure parameters. Non-public procedures require a valid session token.

The current public procedure list is limited to:

- `Авторизация`
- `ВосстановитьПароль`
- `ПодтвердитьВосстановлениеПароля`
- `ПроверитьСессию`

## 5. SKUD Webhook Security

The access-control-system integration verifies:

- source IP allowlist;
- `X-SKUD-Signature`;
- `X-SKUD-Timestamp`;
- `X-SKUD-Nonce`;
- HMAC-SHA256 over timestamp, nonce, and raw body;
- nonce replay cache.

The current implementation rejects timestamps outside a 60-second window and uses a 300-second default nonce TTL.

## 6. Audit and Logging

The current SQL source contains 17 unique triggers. The audit/log table records fields for:

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

Before publishing:

- run the secret scan workflow;
- confirm `config.php` is absent from Git;
- keep `runtime/` and `uploads/` empty except `.gitkeep` files;
- remove or anonymize any SQL export that contains real `INSERT` data;
- replace institution-specific names with `[University Name Redacted]`.
