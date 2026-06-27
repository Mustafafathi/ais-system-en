# Contributing

## Ground Rules

- Keep changes small and focused.
- Do not translate stored procedure names, SQL identifiers, role values, API action names, or response field names unless the database contract is migrated at the same time.
- Do not commit secrets, personal access tokens, database passwords, dumps with real personal data, or production configuration.
- Prefer environment variables for deployment-specific settings.
- Keep generated runtime files out of Git.

## Development Checks

Before opening a pull request, run PHP syntax checks across the project:

```powershell
Get-ChildItem -Recurse -Filter *.php | ForEach-Object { C:\xampp\php\php.exe -l $_.FullName }
```

For documentation-only changes, verify links, paths, and deployment instructions.

## Pull Request Expectations

A useful pull request includes:

- A short summary of the change.
- A clear note about affected roles or workflows.
- Test or verification notes.
- Screenshots for visible UI changes.
- Database migration notes when SQL changes are included.
