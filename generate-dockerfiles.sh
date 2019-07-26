#!/usr/bin/env bash

# example command usage:

# bash generate-dockerfiles.sh -- cimg/base:edge (create openjdk, openjdk-node Dockerfiles)
# bash generate-dockerfiles.sh --variant openjdk -- cimg/base:edge (create openjdk Dockerfiles only)
# bash generate-dockerfiles.sh -v node -- cimg/base:edge (create openjdk-node Dockerfiles only)

die() {
  printf '%s\n' "$1" >&2
  exit 1
}

# Initialize all the option variables
# This ensures we are not contaminated by variables from the environment
VARIANT=

while :; do
	case $1 in
		-v|--variant)
			if [ "$2" ]; then
				case $2 in
					openjdk|node)
						VARIANT="$2"
						echo "Generating $2 Dockerfiles..."
						;;
					?*)
						die "ERROR: unknown option for \`--variant\`: \`$2\`
                        valid options: \`openjdk\`
                                       \`node\`"
						;;
				esac
				shift
			else
				die 'ERROR: `--variant` requires a non-empty option argument'
			fi
			;;
		--)              # End of all options
			shift
			break
			;;
		-?*)
			die "ERROR: unknown option: \`$1\`
            expecting: \`-- BASE/IMAGE:BASE_TAG\`"
			;;
		*)               # Default case: No more options, so break out of the loop
			break
	esac
	shift
done

# Rest of the program here
# If there are arguments (for example) that follow the options, they
# will remain in the "$@" positional parameters

BASE="$1"

source ./manifest

replace_dockerfiles () {
	mkdir -p "$1"

	for (( i=0; i<="${#versions[@]} - 1"; i++ )); do
	  version=${versions[i]}
	  url_snippet=${urls[i]}

	  mkdir -p "$1/$version"
	  cp Dockerfile.template "$1/$version/Dockerfile"

	  # replace base image/tag
	  perl -i -pe 's!%%BASE%%!'"$BASE"'!g' \
	    "$1/$version/Dockerfile"

	  # replace main version
	  perl -i -pe 's!%%VERSION%%!'"$version"'!g' "$1/$version/Dockerfile"

	  # replace major version
	  major_version=$(echo "$version" | cut -f1 -d"." | cut -f1 -d"u")

	  perl -i -pe 's!%%MAJOR%%!'"$major_version"'!g' "$1/$version/Dockerfile"

	  # replace url snippet
	  perl -i -pe 's!%%SNIPPET%%!'"$url_snippet"'!g' "$1/$version/Dockerfile"
	  echo "$1/$version/Dockerfile" complete!
	done
}

if [[ "$VARIANT" ==  node ]]; then
	replace_dockerfiles openjdk-node
elif [[ "$VARIANT" == openjdk ]]; then
	replace_dockerfiles openjdk
else
	replace_dockerfiles openjdk
	BASE="$1-node"
	replace_dockerfiles openjdk-node
fi
