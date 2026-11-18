#!/usr/bin/env bash
# Do not edit by hand; please use build scripts/templates to make changes
set -eo pipefail

docker context create cimg
docker buildx create --use cimg
docker buildx build --platform=linux/amd64,linux/arm64 --file 17.0/Dockerfile -t cimg/openjdk:17.0.21 -t cimg/openjdk:17.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 17.0/node/Dockerfile -t cimg/openjdk:17.0.21-node -t cimg/openjdk:17.0-node --push .
docker buildx build --platform=linux/amd64 --file 17.0/browsers/Dockerfile -t cimg/openjdk:17.0.21-browsers -t cimg/openjdk:17.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 21.0/Dockerfile -t cimg/openjdk:21.0.13 -t cimg/openjdk:21.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 21.0/node/Dockerfile -t cimg/openjdk:21.0.13-node -t cimg/openjdk:21.0-node --push .
docker buildx build --platform=linux/amd64 --file 21.0/browsers/Dockerfile -t cimg/openjdk:21.0.13-browsers -t cimg/openjdk:21.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 25.0/Dockerfile -t cimg/openjdk:25.0.5 -t cimg/openjdk:25.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 25.0/node/Dockerfile -t cimg/openjdk:25.0.5-node -t cimg/openjdk:25.0-node --push .
docker buildx build --platform=linux/amd64 --file 25.0/browsers/Dockerfile -t cimg/openjdk:25.0.5-browsers -t cimg/openjdk:25.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 27.0/Dockerfile -t cimg/openjdk:27.0 -t cimg/openjdk:27.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 27.0/node/Dockerfile -t cimg/openjdk:27.0-node -t cimg/openjdk:27.0-node --push .
docker buildx build --platform=linux/amd64 --file 27.0/browsers/Dockerfile -t cimg/openjdk:27.0-browsers -t cimg/openjdk:27.0-browsers --push .
