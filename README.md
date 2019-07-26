# `cimg/openjdk` [![CircleCI Build Status](https://circleci.com/gh/CircleCI-Public/cimg-openjdk.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/CircleCI-Public/cimg-openjdk) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/CircleCI-Public/cimg-openjdk/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/images)

Prototype CircleCI images for OpenJDK, extending CircleCI's [prototype `cimg/base` image](https://github.com/CircleCI-Public/cimg-base).

## Purpose

Stub text.

## Variants

Currently, there is only a Node variant of this image. The Node variant includes the latest LTS version of Node, [installed via the `n` Node version manager](https://github.com/tj/n). To use a different Node version, see [Installing/Activating Node Versions](https://github.com/tj/n#installingactivating-node-versions), or use [CircleCI's Node orb](http://circleci.com/orbs/registry/orb/circleci/node#commands-install-node) to manually install a different version of Node. See below for explanation of specific `-node` (and other) tags.

To create the functionality of a `-browsers` variant, use [CircleCI's `browser-tools` orb](http://github.com/circleci-public/browser-tools-orb/) to install browsers at runtime.

## Tags

### `<openjdk-version>-<year>.<month>`, `<openjdk-version>-<year>.<month>-node`
Mostly immutable (except in the case of CVEs or severe bugs) monthly release tags for this image and its Node variant. Any new or removed tools from the base image in the last month will be reflected in this image release. For example, the `11.0.4-2019.04`/`11.0.4-2019.04-node` tags would include any changes to this repo/image that occurred in March 2019. Monthly releases are built on the 3rd of every month.

### `<openjdk-version>-stable`, `<openjdk-version>-stable-node`
Mutable tags representing the most recent monthly release of this image and its Node variant. For example, if today's date was April 15th, 2019, then the `11.0.4-stable`/`11.0.4-stable-node` tags would be aliases for the `11.0.4-2019.04`/`11.0.4-2019.04-node` tags.

### `<openjdk-version>-edge`, `<openjdk-version>-edge-node`
Mutable tags representing the builds of this image and its Node variant following the most recent successful commit to this repository's `master` branch.

### `latest`
Mutable tag that represents the latest non-Node-variant, vanilla `cimg/openjdk` image of any version, functionally duplicating whichever is the most recent Ruby version pushed to either the `edge` or `stable` tags. Anyone calling the `cimg/openjdk` image without specifying a tag will get this version of the image.

## Resources

Stub text.

## Development with CI

Working on CircleCI Docker images.

### Adding new OpenJDK versions
To add a new version of OpenJDK, add it to the [`versions` array in the `manifests` file](https://github.com/CircleCI-Public/cimg-ruby/blob/master/manifest#L8). Then add its [unique AdoptOpenJDK URL snippet](https://github.com/CircleCI-Public/cimg-ruby/blob/master/manifest#L10-L12) to the [`urls` array in the `manifests` file](https://github.com/CircleCI-Public/cimg-ruby/blob/master/manifest#L13).

### Commits to non-master branches
Upon successful commits to non-master branches of this repository, OpenJDK versions of this image and its Node variant will be pushed to `ccitest/openjdk` for any requisite post-deployment testing. Tags there will represent the branch and commit hash that triggered them. For example, a successful commit to a branch of this repository called `dev` would result in the creation of the following image/tag: `ccitest/openjdk:<openjdk-version>-dev-${CIRCLE_SHA1:0:7}"`, where `${CIRCLE_SHA1:0:7}"` represents the first six characters of that particular commit hash.

### Patching bugs and vulnerabilities
Monthly release tags can be manually re-published to patch vulnerabilities or severe bugs via a pushing a `git` tag that contains the string `monthly`. This tag will trigger a workflow that will rebuild all current `<openjdk-version>-<year>.<month>` and `<openjdk-version>-<year>.<month>-node` tags, as well as the `<openjdk-version>-stable`, `<openjdk-version>-stable-node`, and `latest` alias tags.

## Local development

Images can also be built and tested locally.

### Generating Dockerfiles
To generate Dockerfiles, use the `generate-dockerfiles.sh` script:

```shell
# use `-v` or `--variant` to pass either `openjdk` or `node`
bash generate-dockerfiles.sh --variant openjdk -- cimg/base:edge # create openjdk Dockerfiles only
bash generate-dockerfiles.sh -v node -- cimg/base:edge-node # create openjdk-node Dockerfiles only

# without flags, the script will generate both openjdk and openjdk-node Dockerfiles
bash generate-dockerfiles.sh -- cimg/base:edge

# pass cimg/base:stable or cimg/base:stable-node to the script for monthly releases
# pass cimg/base:edge or cimg/base:edge-node when working on master or any other branch
```

### Linting Dockerfiles
`cimg` images use `hadolint` to lint Dockerfiles ([installation instructions](https://github.com/hadolint/hadolint#install)).

Once `hadolint` is available locally, use the `shared/lint.sh` script to lint Dockerfiles:

```shell
# use `-i` or `--ignore-rule` to pass a comma-separated list of Docker/Shellcheck lint rules to ignore
bash shared/lint.sh -i DL3000,SC1010 -- app/test.Dockerfile,app/deploy.Dockerfile

# use `-t` or `--trusted-registries` to pass a comma-separated list of trusted registries
bash shared/lint.sh --ignore-rules SC1010 -t docker.io -- "$(find */Dockerfile | tr '\n' ',')"
bash shared/lint.sh --trusted-registries my.registry:5000 -- Dockerfile

# pass a comma-separated list of Dockerfiles to lint, or an expression that resolves to such a list
# if a `.hadolint.yaml` file is present in the working directory, the script will use it automatically
bash shared/lint.sh -- "$(find */*/Dockerfile | tr '\n' ',')"
```

### Contributing
We welcome [issues](https://github.com/CircleCI-Public/cimg-openjdk/issues) to and [pull requests](https://github.com/CircleCI-Public/cimg-openjdk/pulls) against this repository!

This image is maintained by the Community & Partner Engineering Team.
