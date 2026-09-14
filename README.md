# Cabin Development Environment

`cabin-dev-environment` is the canonical, disposable cloud development
environment for The Cabin. It is an environment template, not the Cabin
application.

The repository gives OpenClaw and future AI coding agents a small, repeatable
contract for turning a fresh cloud Linux machine into a useful workspace in
minutes. It defines the checks, documentation, safe defaults, and extension
points that should exist before an agent touches application code.

## The boundary

The permanent estate at `/Volumes/Elise` contains production projects,
long-term memory, models, automation, and infrastructure. A cloud environment
must not assume that path exists, be mounted, or be writable.

Cloud environments are for experiments, pull requests, external repositories,
temporary debugging, and architecture reviews. They are disposable by design.
Source checkout, issue context, and approved artifacts are supplied deliberately
for each session.

GitHub is source and evidence custody for this repository. A passing CI run or a
cloud snapshot does not establish Cabin authority, production admission, or
parity with the permanent estate.

## Quick start

```bash
git clone https://github.com/OWNER/cabin-dev-environment.git
cd cabin-dev-environment
bash scripts/bootstrap.sh
bash scripts/verify.sh
bash scripts/doctor.sh
```

`bootstrap.sh` checks the expected toolchain and never installs packages or
prints secret values. `verify.sh` checks repository structure, Markdown links,
and shell syntax. `doctor.sh` adds environment diagnostics for a human or an
agent investigating a failed launch.

## Repository map

| Path | Why it exists |
| --- | --- |
| `docs/` | Durable explanations for operators who inherit this repository. |
| `scripts/bootstrap.sh` | Fast, non-mutating toolchain preflight. |
| `scripts/verify.sh` | Local equivalent of the required repository quality gate. |
| `scripts/doctor.sh` | Deeper diagnosis of the current disposable environment. |
| `scripts/cleanup.sh` | Opt-in removal of known repo-local generated caches. |
| `scripts/check_repository.py` | Enforces required files and safety invariants. |
| `scripts/check_links.py` | Finds broken local Markdown links and anchors. |
| `templates/` | Safe examples for environment variables and agent settings. |
| `.devcontainer/` | Optional container definition for a consistent local or cloud launch. |
| `.github/` | CI, issue intake, pull-request guidance, and dependency update policy. |

## Typical session

1. Launch a disposable Linux environment from a known image or provider snapshot.
2. Clone this repository and run `scripts/bootstrap.sh`.
3. Supply only the approved checkout and credentials for the current task.
4. Run `scripts/verify.sh` before and after changes.
5. Record the image, tool versions, commit, and task scope before snapshotting.
6. Reuse the snapshot only for work with the same trust and toolchain boundary.

See [docs/onboarding.md](docs/onboarding.md) and
[docs/snapshots.md](docs/snapshots.md) for the full workflow.

## Security baseline

No secret belongs in Git. Copy `templates/.env.example` to a deliberately
ignored local `.env` only when a task needs a credential. API keys, GitHub
tokens, Anthropic and OpenAI credentials, SSH keys, and agent configuration must
be supplied deliberately by the environment owner. They are not bootstrap
inputs, repository defaults, or snapshot contents.

## Future extension points

The repository reserves documented locations for MLX, Qwen, llama.cpp, OpenClaw,
Claude, Codex, MCP servers, router infrastructure, and agent orchestration. The
initial template only verifies whether relevant CLIs are present; it does not
install models, connect providers, run agents, or implement a router.

Read [docs/extensions.md](docs/extensions.md) before adding one of those rails.

## Status vocabulary

Scripts use three outcomes:

- `PASS`: the check completed and the expected condition is true.
- `WARNING`: the condition is optional, unavailable, or needs human judgment.
- `FAILED`: a required invariant is not satisfied.

The process exits non-zero when a required check fails. Warnings are visible but
do not make a disposable environment unusable.

## Contributing

Keep changes small, explain why a file exists, and preserve the distinction
between an environment template and the Cabin application. Start with
[CONTRIBUTING.md](CONTRIBUTING.md), [SECURITY.md](SECURITY.md), and
[docs/governance.md](docs/governance.md).
