# Architecture

## Purpose

This repository is a small control plane for disposable cloud development
environments. It provides a stable human-and-agent contract without becoming a
second Cabin application.

The architecture is intentionally layered:

```text
provider image or snapshot
        |
        v
repository checkout --> bootstrap --> verify --> task-specific project
        |                 |             |
        |                 |             +--> CI quality gate
        |                 +--> toolchain evidence
        +--> docs, scripts, templates, extension points
```

The provider supplies compute, Linux, networking, and snapshot primitives. This
repository supplies policy, checks, and documentation. The task checkout is
provided separately and remains the object of the coding session.

## Components

### Documentation

`docs/` is the durable explanation layer. It records boundaries, assumptions,
workflow, and future extension seams so that a successor can understand the
design without reconstructing intent from shell history.

### Bootstrap

`scripts/bootstrap.sh` is a read-only preflight. It tests the expected baseline
toolchain and reports `PASS`, `WARNING`, or `FAILED`. It does not install
packages, authenticate to providers, launch agents, mount private storage, or
modify a task checkout.

### Verification

`scripts/verify.sh` is the repository contract test. It validates required paths,
safe file naming, shell syntax, local Markdown links, and basic repository
consistency. CI runs the same script so local and hosted evidence share one
entry point.

### Diagnostics

`scripts/doctor.sh` is for investigation after a launch or failed check. It
reports paths, versions, disk headroom, Git state, and visible secret-shaped
filenames without printing credential values.

### Cleanup

`scripts/cleanup.sh` is a deliberately narrow, opt-in cleanup tool. It can remove
only known generated directories inside this repository and requires an explicit
`--apply`. It cannot target the permanent estate or arbitrary paths.

### Templates

`templates/` contains examples, not active configuration. The environment file
is ignored by Git, and the JSON file makes defaults inspectable without implying
that an agent should inherit production settings.

### Dev Container

`.devcontainer/` is a convenience definition for hosts that support the
Development Containers specification. It establishes a neutral Linux baseline;
it does not include Cabin source, models, provider credentials, or production
mounts.

## Invariants

1. The application is not vendored into this repository.
2. `/Volumes/Elise` is never required for bootstrap, verification, or CI.
3. No secret is needed for a clean checkout to pass repository verification.
4. Optional AI and infrastructure tools may be absent without making the base
   template unusable.
5. A successful check describes the checked environment at a point in time; it
   does not prove production qualification or semantic authority.
6. Snapshots capture disposable environment state, while Git commits capture
   source and documentation state. Neither replaces the other.

## Evidence model

Every environment run should be attributable to:

- repository commit;
- provider image or snapshot identifier;
- operating system and architecture;
- tool versions reported by bootstrap;
- task checkout and branch, if one was supplied;
- verification result and timestamp.

This is operational evidence. It should not be interpreted as authority to ingest,
publish, deploy, or alter the permanent Cabin estate.
