<div align="center">
	<p>
		<img alt="CircleCI Logo" src="https://raw.github.com/CircleCI-Public/cimg-openjdk/master/img/circle-circleci.svg?sanitize=true" width="75" />
		<img alt="Docker Logo" src="https://raw.github.com/CircleCI-Public/cimg-openjdk/master/img/circle-docker.svg?sanitize=true" width="75" />
		<img alt="OpenJDK Logo" src="https://raw.github.com/CircleCI-Public/cimg-openjdk/master/img/circle-openjdk.svg?sanitize=true" width="75" />
	</p>
	<h1>CircleCI Convenience Images => OpenJDK</h1>
	<h3>A Continous Integration focused OpenJDK / Java Docker image built to run on CircleCI</h3>
</div>

[![CircleCI Build Status](https://circleci.com/gh/CircleCI-Public/cimg-openjdk.svg?style=shield)](https://circleci.com/gh/CircleCI-Public/cimg-openjdk) [![Software License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/CircleCI-Public/cimg-openjdk/master/LICENSE) [![Docker Pulls](https://img.shields.io/docker/pulls/cimg/openjdk)](https://hub.docker.com/r/cimg/openjdk) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/circleci-images)

***This image is designed to supercede the legacy CircleCI OpenJDK image, `circleci/openjdk`.***

`cimg/openjdk` is a Docker image created by CircleCI with continuous integration builds in mind.
Each tag contains a version of OpenJDK, the Java Development Kit and any binaries and tools that are required for builds to complete successfully in a CircleCI environment.


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
      - image: cimg/openjdk:11.0
    steps:
      - checkout
      - run: java --version
```

In the above example, the CircleCI OpenJDK Docker image is used for the primary container.
More specifically, the tag `11.0` is used meaning the version of OpenJDK will be v11.0.x where 'x' is the latest patch release.
You can now use OpenJDK within the steps for this job.


## How This Image Works

This image contains the Java programming language packaged as OpenJDK by [AdoptOpenJDK](https://adoptopenjdk.net/).

### Variants

Variant images typically contain the same base software, but with a few additional modifications.


## Node.js

The Node.js variant is the same OpenJDK image but with Node.js also installed.
The Node.js variant can be used by appending `-node` to the end of an existing `cimg/openjdk` tag.

```yaml
jobs:
  build:
    docker:
      - image: cimg/openjdk:1.14-node
    steps:
      - checkout
      - run: java --version
      - run: node --version
```

### Tagging Scheme

This image has the following tagging scheme:

```
cimg/openjdk:<openjdk-version>[-variant]
```

`<openjdk-version>` - The version of OpenJDK to use.
This can be a full SemVer point release (such as `11.0.2`) or just the minor release (such as `11.0`).
If you use the minor release tag, it will automatically point to future patch updates as they are released by AdoptOpenJDK & Oracle.
For example, the tag `11.0` points to OpenJDK v11.0.5 now, but when the next release comes out, it will point to OpenJDK v11.0.6.

`[-variant]` - Variant tags, if available, can optionally be used.
For example, the Node.js variant could be used like this: `cimg/openjdk:14.0-node`.


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

Dockerfiles can be generated for a specific OpenJDK version using the `gen-dockerfiles.sh` script.
For example, to generate the Dockerfile for OpenJDK v11.0.5, you would run the following from the root of the repo:

```bash
./shared/gen-dockerfiles.sh 11.0.5#https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.5%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.5_10.tar.gz
```

The generated Dockerfile will be located at `./11.0/Dockefile`.
Unlike most of the CircleCI Convenience Images, the OpenJDK image requires not only the version number to be passed but the AdoptOpenJDK download URL as well.
This is due to inconsistencies with the extra build number they add to their version numbers, which doesn't fit the SemVer scheme.
To build this image locally and try it out, you can run the following:

```bash
cd 11.0
docker build -t test/openjdk:11.0.5 .
docker run -it test/openjdk:11.0.5 bash
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
To make a proper release for this image, let's use the fake OpenJDK version of OpenJDK v9.9.9 and a fake release URL, you would run the following from the repo root:

```bash
./shared/release.sh 9.9.9#https://github.com/AdoptOpenJDK/openjdk9-binaries/releases/download/jdk-9.9.9%2B10/OpenJDK9U-jdk_x64_linux_hotspot_9.9.9_10.tar.gz
```

This will automatically create a new Git branch, generate the Dockerfile(s), stage the changes, commit them, and push them to GitHub.
The commit message will end with the string `[release]`.
This string is used by CircleCI to know when to push images to Docker Hub.
All that would need to be done after that is:

- wait for build to pass on CircleCI
- review the PR
- merge the PR

The master branch build will then publish a release.

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
Don't forget that to see any of these changes locally, the `gen-dockerfiles.sh` script will need to be run again (see above).


## Contributing

We encourage [issues](https://github.com/CircleCI-Public/cimg-openjdk/issues) to and [pull requests](https://github.com/CircleCI-Public/cimg-openjdk/pulls) against this repository however, in order to value your time, here are some things to consider:

1. We won't include just anything in this image. In order for us to add a tool within the OpenJDK image, it has to be something that is maintained and useful to a large number of Java developers. Every tool added makes the image larger and slower for all users so being thorough on what goes in the image will benefit everyone.
1. PRs are welcome. If you have a PR that will potentially take a large amount of time to make, it will be better to open an issue to discuss it first to make sure it's something worth investing the time in.
1. Issues should be to report bugs or request additional/removal of tools in this image. For help with images, please visit [CircleCI Discuss](https://discuss.circleci.com/c/ecosystem/circleci-images).


## Additional Resources

[AdoptOpenJDK](https://adoptopenjdk.net/) - AdoptOpenJDK is a project that builds OpenJDK builds from source. This is where we get our OpenJDK packages from.
[CircleCI Docs](https://circleci.com/docs/) - The official CircleCI Documentation website.
[CircleCI Configuration Reference](https://circleci.com/docs/2.0/configuration-reference/#section=configuration) - From CircleCI Docs, the configuration reference page is one of the most useful pages we have.
It will list all of the keys and values supported in `.circleci/config.yml`.
[Docker Docs](https://docs.docker.com/) - For simple projects this won't be needed but if you want to dive deeper into learning Docker, this is a great resource.


## License

This repository is licensed under the MIT license.
The license can be found [here](./LICENSE).
