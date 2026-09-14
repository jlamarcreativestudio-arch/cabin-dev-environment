# Onboarding a Fresh Environment

This is the normal launch sequence for a new cloud Linux machine or disposable
container. It is written for a human operator and for an AI agent that needs a
clear stopping point when a prerequisite is missing.

## 1. Launch

Start from the approved provider image or a snapshot whose trust boundary is
known. Use a non-production workspace path such as `/workspace` or the provider
default. Do not mount `/Volumes/Elise` as an implicit convenience.

Record the provider, image or snapshot identifier, region, architecture, and
launch timestamp. The record is useful later when a snapshot is reused or
retired.

## 2. Clone

Clone this repository first:

```bash
git clone https://github.com/OWNER/cabin-dev-environment.git
cd cabin-dev-environment
```

Then run the baseline preflight:

```bash
bash scripts/bootstrap.sh
```

Required toolchain failures are a stop condition for work that depends on that
tool. Optional warnings are recorded and reviewed against the task scope.

## 3. Supply task inputs deliberately

Provide only the external repository, branch, issue, design reference, or
artifact approved for this session. If a credential is needed, inject it through
the provider's secret facility or a masked local mechanism. Do not place it in a
command argument, Git remote URL, shell history, snapshot, or committed file.

Copy the example only when needed:

```bash
cp templates/.env.example .env
```

Populate the resulting ignored file outside version control. The example is a
checklist, not an invitation to populate every provider credential.

## 4. Verify before work

Run:

```bash
bash scripts/verify.sh
bash scripts/doctor.sh
```

The first command checks the repository. The second supplies context if the
environment is unusual. Keep the output with the task record, but do not include
secret values or private provider responses.

## 5. Work in the task checkout

Keep the task repository separate from this template. The environment repository
defines the launch contract; it is not the place to copy production source or
long-term memory. Re-run verification after changing tool configuration or
adding an extension.

## 6. Finish and hand off

Before ending the session:

1. Run verification again.
2. Record the resulting commit and toolchain evidence.
3. Remove task credentials and provider session state.
4. Decide whether the environment should be discarded or snapshotted.
5. Keep only approved Git artifacts, such as a branch, patch, or review link.

An unattended prompt does not authorize irreversible bulk effects. Destructive,
production-facing, or publication actions need their own explicit scope and
approval.
