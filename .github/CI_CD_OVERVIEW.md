# Maintained source CI

The application deployment is retired. CI maintains its source and synthetic verification without starting operators or contacting model providers.

The main workflow runs on pull requests, main pushes and explicit dispatch. It keeps these mandatory producers:

| Job | Project command and result |
| --- | --- |
| backend | Prepare the existing Python channel and requirements, parse tracked Python, run the unchanged mocked API/service suite |
| frontend | Prepare the existing Node/Bun inputs and run the TypeScript/frontend production build |
| hadolint | Lint every maintained Dockerfile at the warning threshold |
| semgrep | Run the existing mandatory rule scan with error handling and metrics disabled |
| workflows | Audit workflow source and scan the complete Git source history |
| merge-stops | Run the released pull-request merge checks |

The required gate always evaluates the producer results. Every mandatory producer must succeed; only pull-request-only merge checks may skip on main or dispatch. Independent security CI keeps Python and JavaScript CodeQL analysis.

Use `just check` for build-free checks. On an admitted execution host, `just setup` installs dependencies into the disposable backend CI environment and the frontend workspace; `just test`, `just build` and `just scan` reproduce the individual execution jobs. `just verify` combines the complete scope.

CI configuration owns its interpreter/tool selectors. Existing application requirements and frontend lock remain unchanged during the command migration; a source-only pass does not qualify a new dependency graph. No workflow starts LM Studio, a model, a bot, a deployment, a Docker workload or a real-data import.
