# Maintenance boundaries

The application deployment is retired. Source, dependency and CI maintenance continues.

- `just check` parses tracked Python without importing the application, checks all maintained Dockerfiles, audits workflows and scans Git history. Prepare the declared source tools first.
- `just setup`, `just test`, `just build`, `just scan` and `just verify` belong on execution hosts or admitted CI. Backend setup owns only `backend/.venv-ci`; it clears that disposable environment before reinstalling requirements.
- The backend suite uses the existing mocked LLM boundary and synthetic SQLite configuration. Do not replace it with a running LM Studio, model, provider, Telegram bot, personal environment or real database.
- The interpreter selector under `.github/` is for CI. Application requirements, frontend lock and product minimums remain their own inputs; qualify coherent updates through ordinary dependency proposals.
- `.github/workflows/security.yml` independently retains both CodeQL languages. Passing source checks does not establish native test, frontend build, scanner or installed acceptance.

See [the CI guide](.github/CI_CD_OVERVIEW.md) for the actual jobs.
