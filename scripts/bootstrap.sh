#!/usr/bin/env bash

# Read-only baseline preflight. This script intentionally installs nothing.

set -u

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh"

print_header
printf '%s\n' "Mode: non-mutating toolchain preflight"
printf '%s\n\n' "Production estate access is neither required nor inspected."

if command -v git >/dev/null 2>&1; then
  if git -C "${REPO_ROOT}" rev-parse --show-toplevel >/dev/null 2>&1; then
    report_pass "Git checkout: repository root is identifiable"
  else
    report_failed "Git checkout: ${REPO_ROOT} is not a valid Git work tree"
  fi
else
  report_failed "Git: git is missing; clone and source control operations cannot proceed"
fi

if command -v python3 >/dev/null 2>&1; then
  if python3 -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 10) else 1)' >/dev/null 2>&1; then
    report_pass "Python: python3 is available at version 3.10 or newer ($(python3 --version 2>&1))"
  else
    report_failed "Python: python3 is present but must be version 3.10 or newer"
  fi
else
  report_failed "Python: python3 is missing; repository verification cannot run"
fi

if command -v node >/dev/null 2>&1; then
  if node -e 'process.exit(Number(process.versions.node.split(".")[0]) >= 18 ? 0 : 1)' >/dev/null 2>&1; then
    report_pass "Node.js: node is available at version 18 or newer ($(node --version 2>&1))"
  else
    report_failed "Node.js: node is present but must be version 18 or newer"
  fi
else
  report_failed "Node.js: node is missing; JavaScript-based task tooling cannot run"
fi

check_required_command "Rust" rustc rustc --version
check_required_command "uv" uv uv --version
check_required_command "npm" npm npm --version
check_required_command "pnpm" pnpm pnpm --version

if command -v docker >/dev/null 2>&1; then
  report_pass "Docker CLI: docker is available ($(docker --version 2>&1))"
  if docker info >/dev/null 2>&1; then
    report_pass "Docker daemon: the configured daemon responded"
  else
    report_warning "Docker daemon: the CLI exists but no usable daemon responded; container work is unavailable"
  fi
else
  report_warning "Docker: not installed; container work is optional for this template"
fi

check_optional_command "Claude CLI" claude claude --version
check_optional_command "Codex CLI" codex codex --version
check_optional_command "OpenClaw" openclaw openclaw --version

print_summary
