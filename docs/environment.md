# Environment Contract

## Permanent estate

The permanent estate is `/Volumes/Elise`. It contains:

- production projects;
- long-term memory;
- models;
- automation; and
- infrastructure.

This repository deliberately does not depend on that path. A cloud Linux host
usually cannot see it, and treating a missing mount as an error would make the
environment unsafe and non-portable.

## Cloud environment

A cloud environment contains only the disposable material needed for the current
session:

- experiments;
- pull requests;
- external repositories;
- temporary debugging; and
- architecture reviews.

The default workspace should be outside any production estate. Repositories are
cloned explicitly, and credentials are injected explicitly. The cloud host is
assumed recoverable by deletion and recreation.

## Baseline toolchain

The following commands are baseline checks:

| Tool | Required | Meaning of a pass |
| --- | --- | --- |
| Git | Yes | Git is installed and the checkout can be identified. |
| Python 3.10+ | Yes | A supported Python interpreter is available as `python3`. |
| Node.js 18+ | Yes | A supported Node runtime is available as `node`. |
| Rust | Yes | `rustc` is available for Rust-based tooling. |
| uv | Yes | The fast Python project/package runner is available. |
| npm | Yes | The Node package runner is available. |
| pnpm | Yes | The alternate Node package manager is available. |
| Docker | No | Container operations are available if the daemon is usable. |
| Claude CLI | No | A Claude CLI is present when a task deliberately supplies it. |
| Codex CLI | No | A Codex CLI is present when a task deliberately supplies it. |
| OpenClaw | No | OpenClaw is present when the task deliberately supplies it. |

Required means the base environment contract expects the command. Optional means
the template remains valid without it. `bootstrap.sh` reports an absent optional
tool as `WARNING`, not as a hidden failure.

## Working directories

The template has no hard-coded task checkout path. A host may use `/workspace`,
`/workspaces`, or another disposable directory. The value in
`templates/settings.example.json` is illustrative and must be changed by the
launcher when necessary.

## Network and identity

Network access is a provider decision, not a repository guarantee. GitHub access,
package registries, model providers, MCP servers, and routers must be enabled
per task. The environment must remain useful for offline documentation and
repository verification.

Machine identity and user identity are separate concerns. SSH keys, GitHub
tokens, API keys, and provider session files are supplied deliberately and must
not become part of a snapshot.
