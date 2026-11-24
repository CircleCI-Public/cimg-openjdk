#!/usr/bin/env bash
set -euo pipefail

if [[ $(git log -1 --format=%s) != *'[release]'* ]]; then
  exit 0
fi

source ./manifest
source .circleci/release-builds.sh
production="$namespace/$repository"
staging="ccitest/$repository"
digest_pattern='^sha256:[0-9a-f]{64}$'

if ! command -v regctl >/dev/null; then
  case $(uname -m) in
    x86_64) arch=amd64 ;;
    aarch64) arch=arm64 ;;
    *) echo 'Unsupported regctl architecture' >&2; exit 1 ;;
  esac
  mkdir -p "$HOME/.local/bin"
  curl -fsSL "https://github.com/regclient/regclient/releases/latest/download/regctl-linux-$arch" -o "$HOME/.local/bin/regctl"
  chmod +x "$HOME/.local/bin/regctl"
  export PATH="$HOME/.local/bin:$PATH"
fi
printf '%s\n' "$DOCKER_TOKEN" | docker login --username "$DOCKER_USER" --password-stdin

image_config() {
  regctl image config "$1" --platform linux/amd64 --format '{{json .Config}}'
}

# Digest lookup errors are inconclusive until the registry confirms absence.
production_digest() {
  local tag=$1 digest matches
  if digest=$(regctl image digest "$production:$tag" 2>/dev/null) && [[ $digest =~ $digest_pattern ]]; then
    printf '%s\n' "$digest"
    return
  fi
  if ! matches=$(regctl tag ls "$production" --include "${tag//./\\.}" --format '{{range .Tags}}{{println .}}{{end}}') || [[ -n $matches ]]; then
    echo "Unable to determine digest for $production:$tag" >&2
    return 1
  fi
}

published_version() {
  image_config "$production@$1" | jq -er --arg label "$release_version_label" '
    if (.Labels // {} | has($label)) then
      .Labels[$label] | strings | select(test("^[0-9]+(\\.[0-9]+)+(\\+[0-9]+(\\.[0-9]+)*)?\\z"))
    else
      [.Env[]? | select(startswith("JAVA_VERSION=")) | ltrimstr("JAVA_VERSION=")]
      | select(length == 1) | .[0] | select(test("^[0-9]+(\\.[0-9]+)+\\z"))
    end'
}

# Return 0 if current is newer, 1 if the candidate may be published, or 2 on error.
is_newer() {
  local current=${1%%+*} candidate=${2%%+*} sorted
  if [[ ${current#*.} == 0.0 ]]; then current=${current%.0}; fi
  if [[ ${candidate#*.} == 0.0 ]]; then candidate=${candidate%.0}; fi
  if [[ $current == "$candidate" ]]; then
    [[ $1 == *+* && $2 == *+* ]] || return 1
    current=${1#*+}
    candidate=${2#*+}
  fi
  [[ $current != "$candidate" ]] || return 1
  sorted=$(printf '%s\n' "$current" "$candidate" | LC_ALL=C sort -V) || return 2
  [[ ${sorted##*$'\n'} == "$current" ]]
}

# Resolve the staged digests and plan all updates before changing any production tag.
previous_directory=
retained=' '
publish_tags=()
publish_digests=()
while IFS= read -r line; do
  [[ $line == 'docker buildx build '* ]] || continue
  parse_release_build "$line"
  if [[ $release_directory != "$previous_directory" ]]; then
    source_tree=$(git rev-parse "HEAD:$release_directory")
    dockerfile=$(git show "HEAD:$release_directory/Dockerfile")
    build_version=$(release_version_from_dockerfile "$release_version" "$dockerfile")
    directory_version=$release_version
    previous_directory=$release_directory
    base_digest=
    node_digest=
  elif [[ $release_version != "$directory_version" ]]; then
    echo "Multiple release versions in $release_directory" >&2
    exit 1
  fi
  staged_tag="stage-$source_tree$release_variant"
  if ! digest=$(regctl image digest "$staging:$staged_tag") || [[ ! $digest =~ $digest_pattern ]]; then
    echo "Missing or unreadable staging image $staging:$staged_tag" >&2
    exit 1
  fi

  case $release_variant in
    '') parent_digest=; base_digest=$digest ;;
    -node) parent_digest=${base_digest:?Missing staged base}; node_digest=$digest ;;
    -browsers) parent_digest=${node_digest:?Missing staged Node image} ;;
    *) echo "Unexpected release variant: $release_variant" >&2; exit 1 ;;
  esac
  if ! image_config "$staging@$digest" | jq -e \
    --arg tree_label "$release_tree_label" --arg tree "$source_tree" \
    --arg version_label "$release_version_label" --arg version "$build_version" \
    --arg parent_label "$release_parent_label" --arg parent "$parent_digest" '
      .Labels[$tree_label] == $tree and .Labels[$version_label] == $version and
      ($parent == "" or .Labels[$parent_label] == $parent)
    ' >/dev/null; then
    echo "Staging image metadata or parent digest does not match $staging:$staged_tag" >&2
    exit 1
  fi

  if [[ ! $release_version =~ ^([0-9]+\.[0-9]+)(\.[0-9]+)?(\.[0-9]+)*$ ]]; then
    echo "Unexpected release version: $release_version" >&2
    exit 1
  fi
  series=${BASH_REMATCH[1]}
  versions=("$release_version")
  if [[ -n ${BASH_REMATCH[3]} ]]; then versions+=("$series${BASH_REMATCH[2]}"); fi
  if [[ $release_version != "$series" ]]; then versions+=("$series"); fi

  for version in "${versions[@]}"; do
    target="$version$release_variant"
    if [[ -n $release_variant ]]; then
      parent_target="$version$(release_parent_suffix "$release_variant")"
      if [[ $retained == *" $parent_target "* ]]; then
        printf 'Skipping %s:%s because parent tag %s was retained\n' "$production" "$target" "$parent_target"
        retained+="$target "
        continue
      fi
    fi
    current=$(production_digest "$target")
    [[ $current != "$digest" ]] || continue
    if [[ -n $current ]]; then
      if ! current_version=$(published_version "$current"); then
        echo "Unable to read release version for $production:$target ($current)" >&2
        exit 1
      fi
      comparison=0
      is_newer "$current_version" "$build_version" || comparison=$?
      case $comparison in
        0)
          printf 'Keeping %s:%s at %s (candidate %s)\n' "$production" "$target" "$current_version" "$build_version"
          retained+="$target "
          continue
          ;;
        2) echo "Unable to compare release versions for $production:$target" >&2; exit 1 ;;
      esac
    fi
    publish_tags+=("$target")
    publish_digests+=("$digest")
  done
done < build-images.sh

if [[ -z $previous_directory ]]; then
  echo 'Release commit contains no build commands' >&2
  exit 1
fi
for index in "${!publish_tags[@]}"; do
  regctl image copy "$staging@${publish_digests[index]}" "$production:${publish_tags[index]}"
done
