#!/usr/bin/env bash

shopt -s extglob

vers=()

if [ -f shared/automated-updates.sh ]; then
  source shared/automated-updates.sh
else
  echo "Check if submodule was loaded; automated-updates.sh is missing"
  exit 1
fi

versionCleaner () {
  local dirtyVersion=$1

  case $dirtyVersion in
    jdk8u+([0-9]*))
      buildVersion=$(cut -d "-" -f2 <<< "${dirtyVersion}")
      generateVersions "$(cut -d "-" -f1 <<< "${dirtyVersion}")"
      newFullVersion=$(echo "$newVersion" | trimmer "j d k" | sed -r 's/u/.0./g')
      newVersion=${newFullVersion}
      ;;
    jdk-+([0-9])*)
      generateVersions "$(cut -d "-" -f2 <<< "${dirtyVersion}")"
      buildVersion=$(cut -d "+" -f2 <<< "${newVersion}")
      newVer=${newVersion%+*}
      if [[ $newVer =~ ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]) ]]; then
        newVersionExtended=${newVersion%+*}
        newVersion=${newVer%.*}
      else
        newVersion=$newVer
      fi
      ;;
    *)
      echo "Nothing to clean"
      return 1
    ;;
  esac

  majorMinor=${newVersion%.*}

  if [[ $majorMinor =~ ([0-9]+\.[0-9]+\.[0-9]) ]]; then
    majorMinor=${majorMinor%.*}
  fi
}

buildParameter() {
  local newVersionString=$1

  if [[ $newVersionString =~ ^8.0 ]]; then
    export builtParam="#https://github.com/adoptium/temurin8-binaries/releases/download/$dirtyVersion/OpenJDK8U-jdk_x64_linux_hotspot_$newFullVersion$buildVersion.tar.gz"
  else
    export builtParam="#https://github.com/adoptium/temurin$jdkver-binaries/releases/download/jdk-$newVersionString%2B$buildVersion/OpenJDK${jdkver}U-jdk_x64_linux_hotspot_${newVersionString}_$buildVersion.tar.gz"
  fi
}


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
  echo $VERSIONS

  for version in $VERSIONS; do
    if [[ $version =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
      generateVersions "$version"
      generateSearchTerms "SBT_VERSION=" "$templateFile" '"\\" " "'
      replaceVersions "SBT_VERSION=" "$SEARCH_TERM" true
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

  # add or remove tracked openjdk versions here
  openjdk_vers=(8 11 16 17 18 19 20)

  for jdkver in "${openjdk_vers[@]}"; do
    RSS_URL="https://github.com/adoptium/temurin${jdkver}-binaries/tags.atom"
    VERSIONS=$(curl --silent "$RSS_URL" | grep -E '(title)' | tail -n +2 | sed -e 's/^[ \t]*//' | sed -e 's/<title>//' -e 's/<\/title>//')

    for version in $VERSIONS; do
      if [[ $version =~ jdk8u+([0-9])* || $version =~ jdk-[0-9]([0-9])* ]]; then
        versionCleaner "$version"
        if [ "$(eval echo $?)" -eq 1 ]; then
          continue
        fi

        if [[ $newVersionExtended == "$newVersion" ]]; then
          buildParameter "$newVersionExtended"
        else
          buildParameter "$newVersion"
        fi

        generateSearchTerms "JAVA_VERSION" "$majorMinor/Dockerfile"
        directoryCheck "$majorMinor" "$SEARCH_TERM" "$builtParam"

        if [[ $(eval echo $?) -eq 0 ]]; then
          generateVersionString "$newVersion" "$builtParam"
        fi
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
