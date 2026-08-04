#!/usr/bin/env bash
# Do not edit by hand; please use build scripts/templates to make changes
set -eo pipefail

docker context create cimg
docker buildx create --use cimg
docker buildx build --platform=linux/amd64,linux/arm64 --file 17.0/Dockerfile -t cimg/openjdk:17.0.20 -t cimg/openjdk:17.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 17.0/node/Dockerfile -t cimg/openjdk:17.0.20-node -t cimg/openjdk:17.0-node --push .
docker buildx build --platform=linux/amd64 --file 17.0/browsers/Dockerfile -t cimg/openjdk:17.0.20-browsers -t cimg/openjdk:17.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 21.0/Dockerfile -t cimg/openjdk:21.0.12 -t cimg/openjdk:21.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 21.0/node/Dockerfile -t cimg/openjdk:21.0.12-node -t cimg/openjdk:21.0-node --push .
docker buildx build --platform=linux/amd64 --file 21.0/browsers/Dockerfile -t cimg/openjdk:21.0.12-browsers -t cimg/openjdk:21.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 25.0/Dockerfile -t cimg/openjdk:25.0.4 -t cimg/openjdk:25.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 25.0/node/Dockerfile -t cimg/openjdk:25.0.4-node -t cimg/openjdk:25.0-node --push .
docker buildx build --platform=linux/amd64 --file 25.0/browsers/Dockerfile -t cimg/openjdk:25.0.4-browsers -t cimg/openjdk:25.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 26.0/Dockerfile -t cimg/openjdk:26.0.2 -t cimg/openjdk:26.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 26.0/node/Dockerfile -t cimg/openjdk:26.0.2-node -t cimg/openjdk:26.0-node --push .
docker buildx build --platform=linux/amd64 --file 26.0/browsers/Dockerfile -t cimg/openjdk:26.0.2-browsers -t cimg/openjdk:26.0-browsers --push .
