# Repository Governance Recommendations

This document records the recommended GitHub configuration for the golden
environment template. It is guidance for the repository owner; it is not an
automated change to GitHub settings.

## Repository metadata

Recommended description:

> Canonical, disposable cloud development environment for The Cabin and future AI coding agents.

Recommended topics:

`cabin`, `dev-environment`, `cloud-development`, `developer-experience`,
`devcontainer`, `reproducible-environments`, `ai-agents`,
`snapshot-workflow`

## License

Apache-2.0 is included and recommended for this reusable infrastructure
template. It permits reuse while providing an explicit patent license. Confirm
the final ownership and contributor policy before the first external
contribution.

## Branch protection

Protect `main` with a repository ruleset or branch protection rule:

- require a pull request before merging;
- require one approving review, increasing to two for security or release work;
- dismiss stale approvals when new commits change the reviewed diff;
- require the `quality` workflow to pass;
- require conversation resolution;
- block force pushes and branch deletion;
- allow administrators to bypass only for documented recovery; and
- enable signed commits when the contributor workflow can support them.

Keep required checks strict enough to prevent a stale branch from merging, but
review the build-time cost as the repository grows. GitHub's rulesets are a good
future home when separate rules for branches, tags, or sensitive files are
needed.

## Labels

Start with these labels:

| Label | Use |
| --- | --- |
| `type: bug` | A reproducible defect in scripts or docs. |
| `type: feature` | A new capability or extension point. |
| `type: docs` | Documentation-only improvement. |
| `type: security` | Security boundary, secret hygiene, or hardening. |
| `type: maintenance` | Dependency, action, or housekeeping work. |
| `area: bootstrap` | Toolchain detection and onboarding. |
| `area: snapshots` | Image and snapshot workflow. |
| `area: ci` | GitHub Actions and quality gates. |
| `area: extensions` | Future AI, MCP, router, or orchestration seams. |
| `priority: now` | Needed for the current baseline. |
| `priority: next` | Valuable near-term improvement. |
| `status: blocked` | Waiting on an external decision or dependency. |
| `good first issue` | Small, well-scoped contribution. |

## Milestones

- `v0.1 Baseline`: first repository, scripts, docs, CI, and GitHub settings.
- `v0.2 Snapshot contract`: provider-neutral capture record and reuse checks.
- `v0.3 Agent extension seams`: documented, optional integration contracts.
- `v1.0 Golden template`: stable contract with an explicit compatibility policy.

## First ten issues

Create these as the initial backlog, adjusting ownership and priority after the
first real cloud launch:

1. Configure the `main` branch ruleset and required `quality` check.
2. Add repository topics, description, and the Apache-2.0 license metadata.
3. Run the first clean Linux launch and record the baseline tool versions.
4. Build and verify the `.devcontainer` on a supported host.
5. Choose the first provider snapshot format and store a redacted launch record.
6. Add a small machine-readable snapshot manifest schema.
7. Decide which required tool versions define the v0.1 compatibility window.
8. Add Dependabot review ownership and an action-update cadence.
9. Define the private security-reporting channel and update `SECURITY.md`.
10. Draft the first approved extension contract without implementing a model or
    agent integration.

## Project board

Use a single project at first with these columns:

`Inbox` -> `Ready` -> `In progress` -> `Review` -> `Verified` -> `Released`

Add `Blocked` as a visible side column. Every item should carry a type, area,
priority, and milestone. Move an item to `Verified` only after the relevant
script and CI evidence exists; moving to `Released` means the change is merged
and included in a Git release or documented baseline update.

## Releases

Use Semantic Versioning for the repository contract:

- `0.y.z` while bootstrap behavior and file layout may change;
- minor versions for compatible documentation, checks, or extension additions;
- patch versions for corrections that do not change the contract; and
- `1.0.0` only after a compatibility window and snapshot workflow are proven.

Tag releases as `vX.Y.Z` and use GitHub Releases for human-readable notes. Each
release should list changed checks, supported baseline versions, migration notes,
and verification evidence. Provider snapshots should have their own dated
identifiers and must not be confused with Git tags.
