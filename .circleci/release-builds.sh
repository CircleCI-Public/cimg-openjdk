#!/usr/bin/env bash

release_tree_label=com.circleci.release-tree
release_parent_label=com.circleci.release-parent
release_version_label=com.circleci.release-version
release_digest_filter='."containerimage.digest" | select(type == "string" and test("^sha256:[0-9a-f]{64}$"))'

release_parent_suffix() {
  case $1 in
    -node) return 0 ;;
    -browsers) printf '%s' -node ;;
    *) echo "Unexpected release variant: $1" >&2; return 1 ;;
  esac
}

# Generated commands name the Dockerfile and list the full version first.
parse_release_build() {
  if [[ ! $1 =~ [[:space:]]--file[[:space:]]([^[:space:]]+)[[:space:]]-t[[:space:]]cimg/openjdk:([0-9]+(\.[0-9]+)+)(-[^[:space:]]+)?[[:space:]] ]]; then
    echo "Unexpected generated image build command: $1" >&2
    return 1
  fi

  release_dockerfile=${BASH_REMATCH[1]}
  release_directory=${release_dockerfile%%/*}
  release_version=${BASH_REMATCH[2]}
  release_variant=${BASH_REMATCH[4]}
}

release_version_from_dockerfile() {
  local version=$1 dockerfile=$2 tag prefix=$1 major=${1%%.*}
  if ! grep -Eq "^ENV[[:space:]]+JAVA_VERSION(=|[[:space:]]+)${version//./\\.}[[:space:]]*$" <<< "$dockerfile"; then
    echo "Build tag version $version does not match the base Dockerfile" >&2
    return 1
  fi
  tag=$(sed -n 's/^ARG TEMURIN_RELEASE_TAG=//p' <<< "$dockerfile") || return 1
  if [[ -z $tag || $major == 8 ]]; then
    printf '%s\n' "$version"
    return
  fi
  if [[ $version == "$major".0 || $version == "$major".0.0 ]]; then
    prefix=$major
  fi
  if [[ ! $tag =~ ^"jdk-$prefix+"([0-9]+(\.[0-9]+)*)$ ]]; then
    echo "Invalid Temurin release tag $tag for version $version" >&2
    return 1
  fi
  printf '%s+%s\n' "$version" "${BASH_REMATCH[1]}"
}
