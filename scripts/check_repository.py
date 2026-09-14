#!/usr/bin/env python3
"""Check the structural and security invariants of the environment template."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]

REQUIRED_FILES = (
    "README.md",
    "LICENSE",
    "CONTRIBUTING.md",
    "SECURITY.md",
    ".gitignore",
    ".gitattributes",
    ".markdownlint.json",
    "docs/architecture.md",
    "docs/onboarding.md",
    "docs/environment.md",
    "docs/snapshots.md",
    "docs/extensions.md",
    "docs/governance.md",
    "scripts/bootstrap.sh",
    "scripts/verify.sh",
    "scripts/doctor.sh",
    "scripts/cleanup.sh",
    "scripts/lib.sh",
    "scripts/check_repository.py",
    "scripts/check_links.py",
    "templates/.env.example",
    "templates/settings.example.json",
    ".devcontainer/devcontainer.json",
    ".devcontainer/Dockerfile",
    ".github/workflows/quality.yml",
    ".github/workflows/dependency-review.yml",
    ".github/dependabot.yml",
    ".github/PULL_REQUEST_TEMPLATE.md",
    ".github/ISSUE_TEMPLATE/config.yml",
    ".github/ISSUE_TEMPLATE/bug_report.yml",
    ".github/ISSUE_TEMPLATE/environment_change.yml",
)

REQUIRED_DIRECTORIES = (
    "docs",
    "scripts",
    "templates",
    ".github/workflows",
    ".github/ISSUE_TEMPLATE",
    ".devcontainer",
)

SECRET_NAME_PATTERNS = (
    re.compile(r"^\.env$"),
    re.compile(r"\.(pem|key|p12|pfx)$", re.IGNORECASE),
    re.compile(r"^credentials\.json$", re.IGNORECASE),
    re.compile(r"^id_(rsa|ed25519|ecdsa)$"),
)


def fail(message: str, failures: list[str]) -> None:
    failures.append(message)
    print(f"FAILED: {message}")


def main() -> int:
    failures: list[str] = []

    for relative in REQUIRED_DIRECTORIES:
        if not (ROOT / relative).is_dir():
            fail(f"required directory is missing: {relative}", failures)

    for relative in REQUIRED_FILES:
        if not (ROOT / relative).is_file():
            fail(f"required file is missing: {relative}", failures)

    for path in ROOT.rglob("*"):
        if ".git" in path.parts:
            continue
        if not path.is_file():
            continue
        if any(pattern.search(path.name) for pattern in SECRET_NAME_PATTERNS):
            fail(f"secret-shaped file is present: {path.relative_to(ROOT)}", failures)

    for path in (ROOT / "scripts").glob("*.sh"):
        text = path.read_text(encoding="utf-8")
        if "/Volumes/Elise" in text or "/Users/" in text:
            fail(f"shell script contains a machine-specific estate path: {path.relative_to(ROOT)}", failures)
        if not text.startswith("#!/usr/bin/env bash"):
            fail(f"shell script is missing the standard bash shebang: {path.relative_to(ROOT)}", failures)

    readme = " ".join((ROOT / "README.md").read_text(encoding="utf-8").split())
    for phrase in ("not the Cabin application", "PASS", "WARNING", "FAILED", "templates/.env.example"):
        if phrase not in readme:
            fail(f"README.md does not explain required concept: {phrase}", failures)

    quality = (ROOT / ".github/workflows/quality.yml").read_text(encoding="utf-8")
    if "permissions:" not in quality or "contents: read" not in quality:
        fail("quality workflow must use read-only contents permissions", failures)

    if failures:
        print(f"Repository check failed with {len(failures)} issue(s).")
        return 1

    print("Repository structure and safety invariants passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
