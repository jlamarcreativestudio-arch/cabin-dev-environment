# Security Policy

## Scope

This repository contains environment documentation and bootstrap utilities. It
does not contain the Cabin application, production credentials, model weights,
or long-term memory.

## Never commit secrets

Do not commit API keys, GitHub tokens, Anthropic or OpenAI credentials, SSH
private keys, cloud-provider credentials, copied `.env` files, or machine
identity files. Use a secret manager, an ephemeral environment injection, or an
interactive masked prompt provided by the host.

The examples in `templates/` are intentionally empty or non-sensitive. A
snapshot must exclude credentials and provider session state.

## Reporting

If you find a security issue, do not open a public issue with exploit details.
Use the repository owner's private security-reporting channel and include the
minimum information needed to reproduce the issue. If private reporting is not
configured yet, contact the repository owner before disclosure.

## Recovery

If a secret is committed, treat it as compromised: revoke or rotate it at the
provider, remove it from active branches, and review repository history. Editing
the latest file alone does not revoke a credential or remove historical copies.
