#!/usr/bin/env bash
# Do not edit by hand; please use build scripts/templates to make changes
set -eo pipefail

docker context create cimg
docker buildx create --use cimg
docker buildx build --platform=linux/amd64,linux/arm64 --file 22.0/Dockerfile -t cimg/openjdk:22.0.2 -t cimg/openjdk:22.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 22.0/node/Dockerfile -t cimg/openjdk:22.0.2-node -t cimg/openjdk:22.0-node --push .
docker buildx build --platform=linux/amd64 --file 22.0/browsers/Dockerfile -t cimg/openjdk:22.0.2-browsers -t cimg/openjdk:22.0-browsers --push .
