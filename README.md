# `cimg/openjdk` [![CircleCI Build Status](https://circleci.com/gh/CircleCI-Public/cimg-openjdk.svg?style=shield&circle-token=7b0f77be6efffc5f6143846a8b9e066298288180 "CircleCI Build Status")](https://circleci.com/gh/CircleCI-Public/cimg-openjdk) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/CircleCI-Public/cimg-openjdk/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/images)

Introduction text.


## Purpose

Stub text.


## Tags

Stub text.


## Resources

Stub text.


## Development

When building new image versions, the release script can't currently be used.
Use the `gen-dockerfiles.sh` script directly by creating your branch first.
The full Java version and the download URL needs to be provided:

```
git checkout -b openjdk-v12.0.1
./shared/gen-dockerfiles.sh 12.0.1 https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_linux-x64_bin.tar.gz
git add .
git commit -m "Add OpenJDK v12.0.1."
git push -u origin openjdk-v12.0.1
```

### Contributing
We welcome [issues](https://github.com/cci-images/base/issues) to and [pull requests](https://github.com/cci-images/base/pulls) against this repository!

### Publishing
Merging to `master` publishes a new image to the `edge` tag.
The Scheduled Workflow promotes `edge` to a `<year>.<month>` tag on the 2nd of every month.
The month tags can be manually updated due to security fixes or severe bugs via a Git Tag matching the Docker tag.


This image is maintained by the Community & Partner Engineering Team.
