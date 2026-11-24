#!/usr/bin/env bash
set -euo pipefail

if [[ ${1:-} == versions ]]; then
  # The orb uses the first two version components to find the Dockerfile directory.
  source ./GEN-CHECK
  {
    printf 'GEN_CHECK=('
    for release in "${GEN_CHECK[@]}"; do
      printf ' %q' "${release%%[#=]*}"
    done
    printf ' )\n'
  } > GEN-CHECK
  exit 0
fi

source "$(dirname "${BASH_SOURCE[0]}")/release-builds.sh"

build_commands=()
metadata_initialized=
while IFS= read -r line; do
  if [[ $line != 'docker buildx build '* ]]; then
    build_commands+=("$line")
    continue
  fi

  parse_release_build "$line"
  source_tree=$(git rev-parse "HEAD:$release_directory")
  staged_version="stage-$source_tree"
  # All variants use the Temurin release pinned in the base Dockerfile.
  dockerfile=$(cat "$release_directory/Dockerfile")
  build_version=$(release_version_from_dockerfile "$release_version" "$dockerfile")
  parent_flags=
  if [[ -z $metadata_initialized ]]; then
    build_commands+=('release_metadata=$(mktemp -d)' 'trap '\''rm -rf -- "$release_metadata"'\'' EXIT')
    metadata_initialized=1
  fi
  metadata_flag="--metadata-file \"\$release_metadata/$staged_version$release_variant.json\""
  if [[ -n $release_variant ]]; then
    if ! grep -Eq "^FROM cimg/openjdk:${release_version//./\\.}(-node)?$" "$release_dockerfile"; then
      echo "Missing release parent in $release_dockerfile" >&2
      exit 1
    fi
    parent_suffix=$(release_parent_suffix "$release_variant")
    parent_image='${RELEASE_PARENT}'
    build_commands+=("parent_digest=\$(jq -er '$release_digest_filter' \"\$release_metadata/$staged_version$parent_suffix.json\")")
    parent_flags="--build-arg \"RELEASE_PARENT=cimg/openjdk@\$parent_digest\" --label \"$release_parent_label=\$parent_digest\""
    {
      printf 'ARG RELEASE_PARENT\n'
      sed -E "s|^FROM cimg/openjdk:${release_version//./\\.}(-node)?$|FROM $parent_image|" "$release_dockerfile"
    } > "$release_dockerfile.tmp"
    mv "$release_dockerfile.tmp" "$release_dockerfile"
  fi
  build_commands+=("${line%% -t *} --label $release_tree_label=$source_tree --label $release_version_label=$build_version ${parent_flags:+$parent_flags }$metadata_flag -t cimg/openjdk:$staged_version$release_variant --push .")
done < build-images.sh

printf '%s\n' "${build_commands[@]}" > build-images.sh
