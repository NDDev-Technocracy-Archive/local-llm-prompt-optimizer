set shell := ["bash", "-euo", "pipefail", "-c"]

# Lists the maintained source and execution commands.
default:
    @just --list

# Installs backend and frontend dependencies on an execution host.
setup: setup-backend setup-frontend

# Installs the unchanged backend requirements in an owned disposable CI environment.
[group('ci')]
setup-backend:
    uv venv --python "$(command -v python)" --clear backend/.venv-ci
    uv pip install --python backend/.venv-ci/bin/python -r backend/requirements.txt

# Preserves frontend dependency resolution without writing a new lock.
[group('ci')]
[working-directory('frontend')]
setup-frontend:
    bun install --no-save

# Runs build-free Python, container-source, workflow and history checks.
check: check-python check-docker check-workflows

# Parses tracked Python source without importing or running the application.
[group('checks')]
check-python:
    just --fmt --check
    python tools/check_sources.py

# Preserves warning-level linting of every maintained Dockerfile.
[group('checks')]
check-docker:
    git ls-files -z -- '*Dockerfile*' | xargs -0 --no-run-if-empty hadolint --failure-threshold warning

# Checks workflows and the complete Git source history without fetching objects.
[group('checks')]
check-workflows:
    actionlint
    zizmor --offline --no-progress .github
    GIT_NO_LAZY_FETCH=1 gitleaks git --no-banner --redact --log-opts=--all .

# Formats the task commands.
fix:
    just --fmt

# Runs the existing isolated API/service suite with its mocked LLM boundary.
[working-directory('backend')]
test:
    DATABASE_URL='sqlite:///test.db' LM_STUDIO_BASE_URL='http://localhost:1234/v1' .venv-ci/bin/python -m pytest tests/ -v --tb=short

# Runs the existing TypeScript and frontend production build.
[working-directory('frontend')]
build:
    bun run build

# Preserves the mandatory remote-rule scan with the existing tool constraint.
[group('security')]
scan:
    uvx --constraints .github/ci-requirements.txt semgrep scan --error --metrics off --config p/ci

# Runs the complete existing source, synthetic test, build and scanner scope.
verify: check test build scan
