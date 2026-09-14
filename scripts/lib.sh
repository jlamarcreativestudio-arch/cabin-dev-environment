#!/usr/bin/env bash

# Shared reporting and command checks for the repository's shell entry points.

set -u

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
PASS_COUNT=0
WARNING_COUNT=0
FAILED_COUNT=0

print_header() {
  printf '%s\n' "Cabin Development Environment"
  printf '%s\n' "Repository: ${REPO_ROOT}"
  printf '%s\n\n' "Timestamp: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
}

report_pass() {
  PASS_COUNT=$((PASS_COUNT + 1))
  printf '%-7s %s\n' "PASS" "$1"
}

report_warning() {
  WARNING_COUNT=$((WARNING_COUNT + 1))
  printf '%-7s %s\n' "WARNING" "$1"
}

report_failed() {
  FAILED_COUNT=$((FAILED_COUNT + 1))
  printf '%-7s %s\n' "FAILED" "$1"
}

version_line() {
  local output
  output="$("$@" 2>&1 | head -n 1)" || output="version probe did not complete"
  printf '%s' "${output:-command is present}"
}

check_required_command() {
  local label="$1"
  local command_name="$2"
  shift 2

  if command -v "${command_name}" >/dev/null 2>&1; then
    report_pass "${label}: ${command_name} is available ($(version_line "$@"))"
  else
    report_failed "${label}: ${command_name} is missing; install it in the base image or snapshot"
  fi
}

check_optional_command() {
  local label="$1"
  local command_name="$2"
  shift 2

  if command -v "${command_name}" >/dev/null 2>&1; then
    report_pass "${label}: ${command_name} is available ($(version_line "$@"))"
  else
    report_warning "${label}: ${command_name} is not installed; this optional extension is inactive"
  fi
}

print_summary() {
  printf '\n%s\n' "Summary: ${PASS_COUNT} PASS, ${WARNING_COUNT} WARNING, ${FAILED_COUNT} FAILED"
  if [ "${FAILED_COUNT}" -gt 0 ]; then
    printf '%s\n' "Result: required environment checks need attention."
    return 1
  fi
  printf '%s\n' "Result: no required checks failed."
  return 0
}
