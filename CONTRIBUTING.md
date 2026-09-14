# Contributing

This repository is a long-lived environment contract. A contribution should
make a fresh, disposable cloud Linux environment easier to understand,
reproduce, verify, or extend.

## Before opening a pull request

Run the same checks used by CI:

```bash
bash scripts/bootstrap.sh
bash scripts/verify.sh
bash scripts/doctor.sh
```

Bootstrap warnings are expected when optional tools are not installed. Required
toolchain failures should be fixed or explicitly explained in the pull request.

## Change principles

- Keep the repository independent of `/Volumes/Elise` and any production estate.
- Do not add secrets, credentials, private keys, model weights, or provider state.
- Prefer standard-library or already-present tools in verification scripts.
- Explain the reason for durable files in documentation.
- Add an extension point before adding a provider-specific implementation.
- Keep cloud snapshots and Git releases as separate artifacts.

## Pull requests

Use the pull-request template. State the environment boundary, checks run, and
whether the change alters bootstrap, snapshot, or security behavior. A reviewer
should be able to reproduce the result from the repository and the stated image
or tool versions.
