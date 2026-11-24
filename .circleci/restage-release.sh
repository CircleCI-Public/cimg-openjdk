#!/usr/bin/env bash
set -euo pipefail

release_sha=${1:-}
if [[ ! $release_sha =~ ^[0-9a-f]{40}$ ]] ||
  ! git merge-base --is-ancestor "$release_sha" HEAD; then
  echo 'release-sha must be the full SHA of a commit on the checked-out main branch' >&2
  exit 1
fi

# Use the current staging scripts even if the selected commit predates them.
staging_scripts=$(mktemp -d)
trap 'rm -rf -- "$staging_scripts"' EXIT
cp .circleci/{prepare-release,release-builds}.sh "$staging_scripts/"
git checkout --detach "$release_sha"
if [[ $(git log -1 --format=%s) != *'[release]'* ]]; then
  echo "Commit $release_sha is missing [release] in its subject" >&2
  exit 1
fi
if ! git cat-file -e "$release_sha:.circleci/publish-release.sh" 2>/dev/null; then
  echo "Commit $release_sha uses the legacy Deploy workflow and cannot be restaged" >&2
  exit 1
fi
bash "$staging_scripts/prepare-release.sh"
if ! grep -Eq '^docker buildx build .* -t cimg/openjdk:stage-[0-9a-f]{40}(-node|-browsers)? --push \.$' build-images.sh; then
  echo "Commit $release_sha produced no staging image builds" >&2
  exit 1
fi
