#!/usr/bin/env bash

shopt -s extglob

vers=()

if [ -f shared/automated-updates.sh ]; then
  source shared/automated-updates.sh
else
  echo "Check if submodule was loaded; automated-updates.sh is missing"
  exit 1
fi

getGradleVersion() {
  local templateFile=$1

  RSS_URL="https://github.com/gradle/gradle/releases.atom"
  VERSIONS=$(curl --silent "$RSS_URL" | grep -E '(link)' | grep -E 'v[0-9]' | cut -d "/" -f9 | tr -d "\"")

  for version in $VERSIONS; do
    if [[ $version =~ ^v[0-9]+(\.[0-9]+)*$ ]]; then
      generateVersions "$(cut -d "v" -f2 <<< "${version}")"
      generateSearchTerms "GRADLE_VERSION=" "$templateFile" '"\\" " "'
      # because Gradle (and Go) do not track the patch version if it ends in .0, this is necessary to account for the download URL
      if [[ ${newVersion:(-2)} == ".0" ]]; then
        newVersion=${newVersion%.*}
      fi
      replaceVersions "GRADLE_VERSION=" "$SEARCH_TERM" true
    fi
  done
}

getMavenVersion() {
  local templateFile=$1

  RSS_URL="https://github.com/apache/maven/tags.atom"
  VERSIONS=$(curl --silent "$RSS_URL" | grep -E '(title)' | tail -n +2 | sed -e 's/^[ \t]*//' | sed -e 's/<title>//' -e 's/<\/title>//')

  for version in $VERSIONS; do
    if [[ $version =~ ^[0-9]+(\.[0-9]+)*$  || $version =~ ^maven-[0-9]+(\.[0-9]+)*$ ]]; then
      generateVersions "$(cut -d "-" -f2 <<< "${version}")"
      generateSearchTerms "MAVEN_VERSION=" "$templateFile" '"\\" " "'
      replaceVersions "MAVEN_VERSION=" "$SEARCH_TERM" true
    fi
  done
}

getSbtVersion () {
  local templateFile=$1

  RSS_URL="https://github.com/sbt/sbt/tags.atom"
  VERSIONS=$(curl --silent "$RSS_URL" | grep -E '(title)' | tail -n +2 | sed -e 's/^[ \t]*//' | sed -e 's/<title>//' -e 's/<\/title>//')

  for version in $VERSIONS; do
    if [[ $version =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
      generateVersions "$version"
      generateSearchTerms "SBT_VERSION=" "$templateFile" '"\\" " "'
      replaceVersions "SBT_VERSION=" "$SEARCH_TERM" true
    fi
  done
}

getMillVersion () {
  local templateFile=$1

  RSS_URL="https://github.com/com-lihaoyi/mill/tags.atom"
  VERSIONS=$(curl --silent "$RSS_URL" | grep -E '(title)' | tail -n +2 | sed -e 's/^[ \t]*//' | sed -e 's/<title>//' -e 's/<\/title>//')

  for version in $VERSIONS; do
    if [[ $version =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
      generateVersions "$version"
      generateSearchTerms "MILL_VERSION=" "$templateFile"
      replaceVersions "MILL_VERSION=" "$SEARCH_TERM" true
    fi
  done
}

getJava8 () {
  JAVA_VERSIONS=$(curl -s "https://api.github.com/repos/adoptium/temurin8-binaries/releases" | jq -r ".[] | select(.tag_name | test(\"jdk8u[^-]\")) | .tag_name");
  for version in $JAVA_VERSIONS; do

    if [[ $version == *"-beta"* ]]; then
      echo "Skipping beta version $version"
      break
    fi

    patch=$(echo "$version" | cut -d 'u' -f2 | cut -d '-' -f1)
    generateSearchTerms "JAVA_VERSION" "8.0/Dockerfile"
    versionEqual "$patch" "${SEARCH_TERM#*.*.}"
    if [[ $(eval echo $?) -eq 0 ]]; then
      vers+=("8.0.$patch")
      break
    fi
  done
}

getOpenJDKVersion() {
  echo "Getting latest Gradle version..."
  getGradleVersion "Dockerfile.template"

  echo "Getting latest Maven version..."
  getMavenVersion "Dockerfile.template"

  echo "Getting latest sbt version..."
  getSbtVersion "Dockerfile.template"

  echo "Getting latest Mill version..."
  getMillVersion "Dockerfile.template"

  echo "Getting Java 8 Updates..."
  getJava8

  # add or remove tracked openjdk versions here
  openjdk_vers=(11 16 17 18 19 20 21 22 23)

  for jdkver in "${openjdk_vers[@]}"; do
    JAVA_VERSIONS=$(curl -s "https://api.github.com/repos/adoptium/temurin${jdkver}-binaries/releases" | jq -r ".[] | select(.tag_name | test(\"jdk-\")) | .tag_name")

    for version in $JAVA_VERSIONS; do
      if [[ $version =~ [0-9]+\.[0-9]+\.[0-9]+\.[0-9] ]]; then
        continue
      fi
      JAVA_VERSION=$(echo "$version" | cut -d '-' -f 2 | cut -d '+' -f 1)
      JAVA_MAJOR=$(echo "$JAVA_VERSION" | cut -d '.' -f 1)
      generateSearchTerms "JAVA_VERSION" "$JAVA_MAJOR.0/Dockerfile"
      versionEqual "$JAVA_VERSION" "$SEARCH_TERM"
      if [[ $(eval echo $?) -eq 0 ]]; then
        vers+=("$JAVA_VERSION")
        break
      fi
    done
  done
}

getOpenJDKVersion

if [ -n "${vers[*]}" ]; then
  echo "Included version updates: ${vers[*]}"
  echo "Running release script"
  ./shared/release.sh "${vers[@]}"
else
  echo "No new version updates"
  exit 0
fi
