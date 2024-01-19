#!/usr/bin/env bash
# Do not edit by hand; please use build scripts/templates to make changes
set -eo pipefail

docker context create cimg
docker buildx create --use cimg
docker buildx build --platform=linux/amd64,linux/arm64 --file 8.0/Dockerfile -t cimg/openjdk:8.0.402 -t cimg/openjdk:8.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 8.0/node/Dockerfile -t cimg/openjdk:8.0.402-node -t cimg/openjdk:8.0-node --push .
docker buildx build --platform=linux/amd64 --file 8.0/browsers/Dockerfile -t cimg/openjdk:8.0.402-browsers -t cimg/openjdk:8.0-browsers --push .
