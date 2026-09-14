## Summary

<!-- What changed, and why does the environment contract need it? -->

## Scope and safety

- [ ] This change remains separate from the Cabin application.
- [ ] This change does not require `/Volumes/Elise` or production state.
- [ ] No secrets, credentials, private keys, model weights, or provider state are included.
- [ ] Any new mutation is explicit, narrow, and documented.

## Verification

```text
Paste relevant PASS / WARNING / FAILED output here, with secrets redacted.
```

- [ ] `bash scripts/bootstrap.sh`
- [ ] `bash scripts/verify.sh`
- [ ] `bash scripts/doctor.sh` (when environment behavior changed)
- [ ] CI `quality` workflow

## Documentation

- [ ] The documentation explains why the new file or behavior exists.
- [ ] Snapshot, release, and extension behavior is described if applicable.
