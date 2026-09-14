#!/usr/bin/env bash

# Read-only diagnostics for a human investigating a cloud launch.

set -u

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh"

print_header
printf '%s\n\n' "Mode: diagnostic inspection; no files or provider state will be changed"

if git -C "${REPO_ROOT}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  report_pass "Git state: checkout is a work tree"
  printf '         branch: %s\n' "$(git -C "${REPO_ROOT}" branch --show-current 2>/dev/null || printf '%s' detached)"
  if commit="$(git -C "${REPO_ROOT}" rev-parse --verify HEAD 2>/dev/null)"; then
    printf '         commit: %s\n' "${commit}"
  else
    printf '         commit: unavailable (no commit exists yet)\n'
  fi
  if [ -n "$(git -C "${REPO_ROOT}" status --short 2>/dev/null)" ]; then
    report_warning "Git state: checkout has uncommitted or untracked changes"
  else
    report_pass "Git state: checkout is clean"
  fi
else
  report_failed "Git state: ${REPO_ROOT} is not a work tree"
fi

if df -P "${REPO_ROOT}" >/dev/null 2>&1; then
  disk_line="$(df -P "${REPO_ROOT}" | tail -n 1)"
  report_pass "Disk: filesystem information is available"
  printf '         %s\n' "${disk_line}"
else
  report_warning "Disk: filesystem headroom could not be inspected"
fi

if [ -r "${REPO_ROOT}/templates/.env.example" ]; then
  report_pass "Secret template: only the non-secret example file is expected in the checkout"
fi

secret_files="$(find "${REPO_ROOT}" -path "${REPO_ROOT}/.git" -prune -o -type f \( -name '.env' -o -name '*.pem' -o -name '*.key' -o -name '*.p12' -o -name '*.pfx' -o -name 'credentials.json' \) -print 2>/dev/null)"
if [ -n "${secret_files}" ]; then
  report_failed "Secret-shaped files: review these filenames and remove them before snapshotting"
  printf '%s\n' "${secret_files}"
else
  report_pass "Secret-shaped files: none found"
fi

if [ -n "${HOME:-}" ] && [ -d "${HOME}/.ssh" ]; then
  report_warning "SSH directory: ${HOME}/.ssh exists on this host; do not include it in a snapshot"
else
  report_pass "SSH directory: no local SSH directory was detected"
fi

if git -C "${REPO_ROOT}" diff --check >/dev/null 2>&1; then
  report_pass "Whitespace: current Git diff has no whitespace errors"
else
  report_failed "Whitespace: current Git diff contains whitespace errors"
fi

printf '\n%s\n' "Diagnostic note: this report is point-in-time evidence, not a production qualification."
print_summary
