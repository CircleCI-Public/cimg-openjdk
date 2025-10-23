#!/usr/bin/env bash
# Do not edit by hand; please use build scripts/templates to make changes
set -eo pipefail

docker context create cimg
docker buildx create --use cimg
docker buildx build --platform=linux/amd64,linux/arm64 --file 17.0/Dockerfile -t cimg/openjdk:17.0.17 -t cimg/openjdk:17.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 17.0/node/Dockerfile -t cimg/openjdk:17.0.17-node -t cimg/openjdk:17.0-node --push .
docker buildx build --platform=linux/amd64 --file 17.0/browsers/Dockerfile -t cimg/openjdk:17.0.17-browsers -t cimg/openjdk:17.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 21.0/Dockerfile -t cimg/openjdk:21.0.9 -t cimg/openjdk:21.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 21.0/node/Dockerfile -t cimg/openjdk:21.0.9-node -t cimg/openjdk:21.0-node --push .
docker buildx build --platform=linux/amd64 --file 21.0/browsers/Dockerfile -t cimg/openjdk:21.0.9-browsers -t cimg/openjdk:21.0-browsers --push .
