#!/usr/bin/env bash
set -euo pipefail

case ${1:-} in
  generate) script=./shared/gen-dockerfiles.sh ;;
  release) script=./shared/release.sh ;;
  *) echo "Usage: $0 {generate|release} <version[#temurin-tag]>..." >&2; exit 1 ;;
esac
shift
if [[ $# -eq 0 ]]; then
  echo 'At least one version is required' >&2
  exit 1
fi

# The shared generator retains the previous parameter when no # is present.
# Pass an explicit empty parameter for each version with no pinned tag.
versions=()
for version in "$@"; do
  case $version in
    -*|*'#'*) versions+=("$version") ;;
    *) versions+=("$version#") ;;
  esac
done

exec "$script" "${versions[@]}"
