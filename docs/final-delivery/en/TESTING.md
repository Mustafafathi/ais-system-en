# Testing

## Static PHP Syntax Check

Run from the repository root on Windows with XAMPP PHP:

```powershell
Get-ChildItem -Recurse -Filter *.php | ForEach-Object { C:\xampp\php\php.exe -l $_.FullName }
```

## Manual Smoke Tests

- Open the login page.
- Sign in with each supported role.
- Confirm role-based redirect.
- Open dashboard, schedule, profile, and notifications pages.
- Generate a QR session as a teacher.
- Scan a QR code as a student.
- Submit and review an absence justification.
- Run reports for group and teacher workflows.
- Test CSV import in a non-production environment.

## API Smoke Test

Use a known test session and token, then call `api.php` with a safe read-only stored procedure. Do not use production credentials in shared scripts.

## Documentation QA

For documentation-only changes, verify that file paths, environment variables, setup instructions, and GitHub publishing commands are still accurate.
