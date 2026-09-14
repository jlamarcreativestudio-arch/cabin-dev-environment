#!/usr/bin/env bash

# Narrow, opt-in cleanup of known generated directories inside this repository.

set -u

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
# shellcheck source=lib.sh
source "${SCRIPT_DIR}/lib.sh"

if [ "${1:-}" != "--apply" ]; then
  printf '%s\n' "Dry run. Pass --apply to remove only known repo-local generated paths."
  printf '%s\n' "No files were changed."
  exit 0
fi

cleanup_targets=(
  "${REPO_ROOT}/.cache"
  "${REPO_ROOT}/.pytest_cache"
  "${REPO_ROOT}/.ruff_cache"
  "${REPO_ROOT}/coverage"
  "${REPO_ROOT}/dist"
  "${REPO_ROOT}/build"
  "${REPO_ROOT}/node_modules"
)

for target in "${cleanup_targets[@]}"; do
  case "${target}" in
    "${REPO_ROOT}"/*) ;;
    *)
      printf '%s\n' "Refusing to clean a path outside the repository: ${target}"
      exit 1
      ;;
  esac

  if [ -e "${target}" ]; then
    # The case guard above limits this deletion to explicit repo-local targets.
    # shellcheck disable=SC2115
    rm -rf -- "${target}"
    printf '%s\n' "Removed repo-local generated path: ${target}"
  fi
done

printf '%s\n' "Cleanup complete. Source files, Git metadata, and credentials were not targeted."
