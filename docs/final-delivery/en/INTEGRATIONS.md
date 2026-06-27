# Integrations

## API Gateway

All normal application calls go through `api.php`. Requests are JSON by default:

```json
{
  "action": "ProcedureName",
  "params": {},
  "session_id": "...",
  "token": "..."
}
```

The actual production procedure names are the original Russian stored procedure names.

## CSV Import

CSV integration helpers live in `integration/csv/`:

- `mapping.php`
- `normalizers.php`

The API includes special handling for configured CSV import actions before falling back to the generic procedure gateway.

## ACS/SKUD Events

Access-control-system integration helpers live in `integration/skud/`:

- `auth_ip_hmac.php`
- `event.php`
- `mapping.php`

Use `AIS_SKUD_SECRET` and `AIS_INTEGRATION_ALLOWLIST` to restrict access.

## Health Endpoint

Health checks are implemented in `integration/system/health.php`. Use `AIS_HEALTH_SECRET` for protected deployment checks.

## Idempotency

The API supports idempotency keys and stores replay data under `runtime/idempotency/`. Runtime cache data must not be committed.
