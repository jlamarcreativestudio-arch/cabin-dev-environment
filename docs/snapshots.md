# Snapshot Workflow

Snapshots are provider-specific images or volumes captured after the base
environment is ready. They save significant setup time because package
installation, compiler setup, and cache warming happen once instead of on every
cloud launch.

## Lifecycle

### 1. Launch environment

Launch from the approved base image. Choose a disposable workspace and record
the provider, image, architecture, and operating-system version.

### 2. Bootstrap

Clone this repository and run:

```bash
bash scripts/bootstrap.sh
```

Install or configure only the approved baseline tools for the snapshot. The
template does not prescribe provider-specific installers because that would make
the repository responsible for credentials, privilege escalation, and unrelated
runtime state.

### 3. Verify

Run:

```bash
bash scripts/verify.sh
bash scripts/doctor.sh
```

Save the output as operational evidence after redacting machine names, tokens,
private paths, and other sensitive context. A snapshot should not be promoted
when required checks fail.

### 4. Snapshot

Before capture:

- remove task repositories that are not part of the approved base;
- remove `.env` files, SSH private keys, cloud credentials, and provider session
  state;
- clear shell history and transient logs according to the provider policy;
- record `git rev-parse HEAD` for this repository;
- record tool versions, OS image, architecture, and snapshot purpose; and
- confirm that `/Volumes/Elise` was not required or copied into the image.

Capture the provider snapshot and give it a dated, human-readable identifier.
Keep the source commit and snapshot identifier together in the launch record.

### 5. Reuse snapshot

Launch a new disposable environment from the snapshot. Re-run `bootstrap.sh`,
`verify.sh`, and `doctor.sh`; snapshots are point-in-time artifacts and can
drift, expire, or be changed by provider maintenance. Refresh the snapshot when
the checks, security baseline, or supported tool versions change.

## What a snapshot is and is not

| Snapshot captures | Snapshot does not establish |
| --- | --- |
| OS and installed baseline tools | Cabin application authority |
| Approved package caches | Production parity |
| Repository checkout, if deliberately included | Permission to access private estate data |
| Provider image configuration | Correctness of future task changes |
| A point-in-time environment state | A replacement for Git history or review |

## Snapshot naming

Use a predictable identifier such as:

```text
cabin-dev-<os>-<arch>-<YYYYMMDD>-<toolchain-major>
```

Do not put secrets, user tokens, or private repository names in the identifier.

## Refresh policy

Refresh on a planned cadence and after material changes to the base toolchain,
security baseline, or provider image. Retain the previous known-good snapshot
until the replacement has passed the full verification gate. Retirement of old
snapshots is provider-specific and should follow a recoverable deletion policy.
