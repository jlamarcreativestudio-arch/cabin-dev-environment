#!/usr/bin/env bash

# Local repository quality gate. CI invokes this same entry point.

set -u

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh"

print_header
printf '%s\n\n' "Mode: repository consistency and local-link verification"

if command -v python3 >/dev/null 2>&1; then
  if python3 "${REPO_ROOT}/scripts/check_repository.py"; then
    report_pass "Repository consistency: required files, directories, and safety invariants are present"
  else
    report_failed "Repository consistency: one or more required invariants failed"
  fi
else
  report_failed "Repository consistency: python3 is required to run the standard-library checker"
fi

if command -v python3 >/dev/null 2>&1; then
  if python3 "${REPO_ROOT}/scripts/check_links.py"; then
    report_pass "Markdown links: all local targets and anchors resolve"
  else
    report_failed "Markdown links: one or more local targets or anchors are broken"
  fi
fi

shell_syntax_failed=0
while IFS= read -r -d '' script; do
  if bash -n "${script}"; then
    :
  else
    shell_syntax_failed=1
  fi
done < <(find "${REPO_ROOT}/scripts" -type f -name '*.sh' -print0)

if [ "${shell_syntax_failed}" -eq 0 ]; then
  report_pass "Shell syntax: all scripts parse with bash -n"
else
  report_failed "Shell syntax: at least one shell script could not be parsed"
fi

if git -C "${REPO_ROOT}" diff --check >/dev/null 2>&1; then
  report_pass "Whitespace: Git reports no whitespace errors in tracked changes"
else
  report_failed "Whitespace: Git found whitespace errors in the current diff"
fi

print_summary
