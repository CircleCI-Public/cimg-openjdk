<div align="center">
	<p>
		<img alt="CircleCI Logo" src="https://raw.github.com/CircleCI-Public/cimg-openjdk/main/img/circle-circleci.svg?sanitize=true" width="75" />
		<img alt="Docker Logo" src="https://raw.github.com/CircleCI-Public/cimg-openjdk/main/img/circle-docker.svg?sanitize=true" width="75" />
		<img alt="OpenJDK Logo" src="https://raw.github.com/CircleCI-Public/cimg-openjdk/main/img/circle-openjdk.svg?sanitize=true" width="75" />
	</p>
	<h1>CircleCI Convenience Images => OpenJDK</h1>
	<h3>A Continous Integration focused OpenJDK / Java Docker image built to run on CircleCI</h3>
</div>

[![CircleCI Build Status](https://circleci.com/gh/CircleCI-Public/cimg-openjdk.svg?style=shield)](https://circleci.com/gh/CircleCI-Public/cimg-openjdk) [![Software License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/CircleCI-Public/cimg-openjdk/main/LICENSE) [![Docker Pulls](https://img.shields.io/docker/pulls/cimg/openjdk)](https://hub.docker.com/r/cimg/openjdk) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/circleci-images) [![Repository](https://img.shields.io/badge/github-README-brightgreen)](https://github.com/CircleCI-Public/cimg-openjdk)

***This image is designed to supercede the legacy CircleCI OpenJDK image, `circleci/openjdk`.***

`cimg/openjdk` is a Docker image created by CircleCI with continuous integration builds in mind.
Each tag contains a version of OpenJDK, the Java Development Kit and any binaries and tools that are required for builds to complete successfully in a CircleCI environment.

## Support Policy

The CircleCI Docker Convenience Image support policy can be found on the [CircleCI docs](https://circleci.com/docs/convenience-images-support-policy) site. This policy outlines the release, update, and deprecation policy for CircleCI Docker Convenience Images.

## Table of Contents

- [Getting Started](#getting-started)
- [How This Image Works](#how-this-image-works)
- [Development](#development)
- [Contributing](#contributing)
- [Additional Resources](#additional-resources)
- [License](#license)


## Getting Started

This image can be used with the CircleCI `docker` executor.
For example:

```yaml
jobs:
  build:
    docker:
      - image: cimg/openjdk:15.0
    steps:
      - checkout
      - run: java --version
```

In the above example, the CircleCI OpenJDK Docker image is used for the primary container.
More specifically, the tag `15.0` is used meaning the version of OpenJDK will be v15.0.2.
You can now use OpenJDK within the steps for this job.


## How This Image Works

This image contains the Java programming language packaged as OpenJDK by [Adoptiumn](https://adoptium.net/).

### Variants

Variant images typically contain the same base software, but with a few additional modifications.


#### Node.js

The Node.js variant is the same OpenJDK image but with Node.js also installed.
The Node.js variant can be used by appending `-node` to the end of an existing `cimg/openjdk` tag.

```yaml
jobs:
  build:
    docker:
      - image: cimg/openjdk:15.0-node
    steps:
      - checkout
      - run: java --version
      - run: node --version
```

#### Browsers

The browsers variant is the same OpenJDK image but with Node.js, Selenium, and browser dependencies pre-installed via apt.
The browsers variant can be used by appending `-browser` to the end of an existing `cimg/openjdk` tag.
The browsers variant is designed to work in conjunction with the [CircleCI Browser Tools orb](https://circleci.com/developer/orbs/orb/circleci/browser-tools).
You can use the orb to install a version of Google Chrome and/or Firefox into your build. The image contains all of the supporting tools needed to use both the browser and its driver.

```yaml
orbs:
  browser-tools: circleci/browser-tools@1.1
jobs:
  build:
    docker:
      - image: cimg/openjdk:15.0-browsers
    steps:
      - browser-tools/install-browser-tools
      - checkout
      - run: |
          node --version
          java --version
          google-chrome --version
```

### Tagging Scheme

This image has the following tagging scheme:

```
cimg/openjdk:<openjdk-version>[-variant]
```

`<openjdk-version>` - The version of OpenJDK to use.
Two-component tags such as `25.0` track the latest image published for that JDK series.
When an emergency patch such as `25.0.5.1` is published, the full version gets its own tag and the three-component tag `25.0.5` moves to the same image.
A subsequent release such as `25.0.6` moves `25.0` and leaves `25.0.5` pointing to its last published patch.
Variant tags follow the same rules.

`[-variant]` - Variant tags, if available, can optionally be used.
For example, the Node.js variant could be used like this: `cimg/openjdk:15.0-node`.


## Development

Images can be built and run locally with this repository.
This has the following requirements:

- local machine of Linux (Ubuntu tested) or macOS
- modern version of Bash (v4+)
- modern version of Docker Engine (v19.03+)

### Cloning For Community Users (no write access to this repository)

Fork this repository on GitHub.
When you get your clone URL, you'll want to add `--recurse-submodules` to the clone command in order to populate the Git submodule contained in this repo.
It would look something like this:

```bash
git clone --recurse-submodules <my-clone-url>
```

If you missed this step and already cloned, you can just run `git submodule update --recursive` to populate the submodule.
Then you can optionally add this repo as an upstream to your own:

```bash
git remote add upstream https://github.com/CircleCI-Public/cimg-openjdk.git
```

### Cloning For Maintainers ( you have write access to this repository)

Clone the project with the following command so that you populate the submodule:

```bash
git clone --recurse-submodules git@github.com:CircleCI-Public/cimg-openjdk.git
```

### Generating Dockerfiles

Dockerfiles can be generated for a specific OpenJDK version using the `temurin-release.sh generate` command.
For example, to generate the Dockerfile for Temurin `11.0.33.1+1` with its release tag pinned, run the following from the root of the repo:

```bash
bash ./temurin-release.sh generate 11.0.33.1#jdk-11.0.33.1+1
```

The generated Dockerfile will be located at `./11.0/Dockerfile`.
For JDK 11 and later, an explicit release tag must match the requested JDK version. If omitted, the Dockerfile looks up a stable Temurin build for that version. JDK 8 uses the version alone.
To build this image locally and try it out, you can run the following:

```bash
cd 11.0
docker build -t test/openjdk:11.0.33.1 .
docker run -it test/openjdk:11.0.33.1 bash
```

### Building the Dockerfiles

To build the Docker images locally as this repository does, you'll want to run the `build-images.sh` script:

```bash
./build-images.sh
```

This would need to be run after generating the Dockerfiles first.
When releasing proper images for CircleCI, this script is run from a CircleCI pipeline and not locally.

### Publishing Official Images (for Maintainers only)

The individual scripts (above) can be used to create the correct files for an image, and then added to a new git branch, committed, etc.
A release script is included to make this process easier.
To prepare a release with a pinned Temurin build, run the following from the repo root:

```bash
bash ./temurin-release.sh release 11.0.33.1#jdk-11.0.33.1+1
```

This will automatically create a new Git branch, generate the Dockerfile(s), stage the changes, commit them, and push them to GitHub.
The commit message will end with the string `[release]`.
This string is used by CircleCI to know when to push images to Docker Hub.
All that would need to be done after that is:

- wait for build to pass on CircleCI
- review the PR
- merge the PR

The main branch Deploy job publishes the checked-out release commit using the images staged by Test.
A tag already pointing to a newer JDK version or known Temurin build stays where it is. Its older variant aliases are also left in place.

### Recovering a release

Rerun Deploy only for the latest `[release]` commit on `main`. A previous release with the same JDK version and Temurin build can replace an image published from a later commit.

If a staging image is missing or its parent digest does not match, rebuild the complete staging set for that release first. The recovery workflow supports releases whose original Deploy uses `.circleci/publish-release.sh` to read `stage-<tree>` tags.

Set `CIRCLE_TOKEN` to a CircleCI personal API token, and use the pipeline definition ID and full SHA of the merged `[release]` commit. GitHub OAuth uses a `gh/` or `github/` project slug and requires the CircleCI project ID in `filter[project_id]`. GitHub App uses a `circleci/` project slug and can leave `project_id` empty. [Find your CircleCI IDs](https://circleci.com/docs/guides/toolkit/how-to-find-ids/) · [CircleCI API v3 trigger guide](https://circleci.com/docs/guides/toolkit/api-v1-migration-guide/#replace-trigger-calls-using-api-v3)

```bash
definition_id='<pipeline-definition-id>'
release_sha='<merged-release-commit-sha>'
project_id='' # Set to the CircleCI project ID for GitHub OAuth.
api_url='https://circleci.com/api/v3/runs'
if [[ -n "$project_id" ]]; then
  api_url+="?filter[project_id]=$project_id"
fi

jq -n --arg id "$definition_id" --arg sha "$release_sha" '{
  data: {
    attributes: {
      config: {branch: "main"},
      checkout: {branch: "main"},
      parameters: {"release-sha": $sha}
    },
    references: {pipeline: {id: $id}}
  }
}' | curl --globoff --fail-with-body --silent --show-error \
  --request POST "$api_url" \
  --header "Authorization: Bearer ${CIRCLE_TOKEN:?Set CIRCLE_TOKEN}" \
  --header 'Content-Type: application/json' \
  --data-binary @-
```

Wait for `restage-wf` to succeed. It rebuilds every image in that commit's `build-images.sh` and pushes the complete set to `ccitest`. Then rerun the original workflow for the latest release commit to publish the staged images.

### Incorporating Changes

How changes are incorporated into this image depends on where they come from.

**build scripts** - Changes within the `./shared` submodule happen in its [own repository](https://github.com/CircleCI-Public/cimg-shared).
For those changes to affect this image, the submodule needs to be updated.
Typically like this:

```bash
cd shared
git pull
cd ..
git add shared
git commit -m "Updating submodule for foo."
```

**parent image** - By design, when changes happen to a parent image, they don't appear in existing OpenJDK images.
This is to aid in "determinism" and prevent breaking customer builds.
New OpenJDK images will automatically pick up the changes.

If you *really* want to publish changes from a parent image into the OpenJDK image, you have to build a specific image version as if it was a new image.
This will create a new Dockerfile and once published, a new image.

**OpenJDK specific changes** - Editing the `Dockerfile.template` file in this repo is how to modify the OpenJDK image specifically.
To see these changes locally, run `bash ./temurin-release.sh generate` again with the versions you want to build.


## Contributing

We encourage [issues](https://github.com/CircleCI-Public/cimg-openjdk/issues) and [pull requests](https://github.com/CircleCI-Public/cimg-openjdk/pulls) against this repository.

Please check out our [contributing guide](.github/CONTRIBUTING.md) which outlines best practices for contributions and what you can expect from the images team at CircleCI.

## Additional Resources

[Adoptium](https://adoptium.net/) - Adoptium is a project that builds OpenJDK builds from source. This is where we get our OpenJDK packages from.
[CircleCI Docs](https://circleci.com/docs/) - The official CircleCI Documentation website.
[CircleCI Configuration Reference](https://circleci.com/docs/2.0/configuration-reference/#section=configuration) - From CircleCI Docs, the configuration reference page is one of the most useful pages we have.
It will list all of the keys and values supported in `.circleci/config.yml`.
[Docker Docs](https://docs.docker.com/) - For simple projects this won't be needed but if you want to dive deeper into learning Docker, this is a great resource.


## License

This repository is licensed under the MIT license.
The license can be found [here](./LICENSE).
