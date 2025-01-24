#!/usr/bin/env bash
# Do not edit by hand; please use build scripts/templates to make changes
set -eo pipefail

docker context create cimg
docker buildx create --use cimg
docker buildx build --platform=linux/amd64,linux/arm64 --file 8.0/Dockerfile -t cimg/openjdk:8.0.442 -t cimg/openjdk:8.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 8.0/node/Dockerfile -t cimg/openjdk:8.0.442-node -t cimg/openjdk:8.0-node --push .
docker buildx build --platform=linux/amd64 --file 8.0/browsers/Dockerfile -t cimg/openjdk:8.0.442-browsers -t cimg/openjdk:8.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 11.0/Dockerfile -t cimg/openjdk:11.0.26 -t cimg/openjdk:11.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.26-node -t cimg/openjdk:11.0-node --push .
docker buildx build --platform=linux/amd64 --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.26-browsers -t cimg/openjdk:11.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 17.0/Dockerfile -t cimg/openjdk:17.0.14 -t cimg/openjdk:17.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 17.0/node/Dockerfile -t cimg/openjdk:17.0.14-node -t cimg/openjdk:17.0-node --push .
docker buildx build --platform=linux/amd64 --file 17.0/browsers/Dockerfile -t cimg/openjdk:17.0.14-browsers -t cimg/openjdk:17.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 21.0/Dockerfile -t cimg/openjdk:21.0.6 -t cimg/openjdk:21.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 21.0/node/Dockerfile -t cimg/openjdk:21.0.6-node -t cimg/openjdk:21.0-node --push .
docker buildx build --platform=linux/amd64 --file 21.0/browsers/Dockerfile -t cimg/openjdk:21.0.6-browsers -t cimg/openjdk:21.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 23.0/Dockerfile -t cimg/openjdk:23.0.2 -t cimg/openjdk:23.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 23.0/node/Dockerfile -t cimg/openjdk:23.0.2-node -t cimg/openjdk:23.0-node --push .
docker buildx build --platform=linux/amd64 --file 23.0/browsers/Dockerfile -t cimg/openjdk:23.0.2-browsers -t cimg/openjdk:23.0-browsers --push .
