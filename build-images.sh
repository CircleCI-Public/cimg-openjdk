#!/usr/bin/env bash
# Do not edit by hand; please use build scripts/templates to make changes
set -eo pipefail

docker context create cimg
docker buildx create --use cimg
docker buildx build --platform=linux/amd64,linux/arm64 --file 8.0/Dockerfile -t cimg/openjdk:8.0.412 -t cimg/openjdk:8.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 8.0/node/Dockerfile -t cimg/openjdk:8.0.412-node -t cimg/openjdk:8.0-node --push .
docker buildx build --platform=linux/amd64 --file 8.0/browsers/Dockerfile -t cimg/openjdk:8.0.412-browsers -t cimg/openjdk:8.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 11.0/Dockerfile -t cimg/openjdk:11.0.23 -t cimg/openjdk:11.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.23-node -t cimg/openjdk:11.0-node --push .
docker buildx build --platform=linux/amd64 --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.23-browsers -t cimg/openjdk:11.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 17.0/Dockerfile -t cimg/openjdk:17.0.11 -t cimg/openjdk:17.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 17.0/node/Dockerfile -t cimg/openjdk:17.0.11-node -t cimg/openjdk:17.0-node --push .
docker buildx build --platform=linux/amd64 --file 17.0/browsers/Dockerfile -t cimg/openjdk:17.0.11-browsers -t cimg/openjdk:17.0-browsers --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 21.0/Dockerfile -t cimg/openjdk:21.0.3 -t cimg/openjdk:21.0 --push .
docker buildx build --platform=linux/amd64,linux/arm64 --file 21.0/node/Dockerfile -t cimg/openjdk:21.0.3-node -t cimg/openjdk:21.0-node --push .
docker buildx build --platform=linux/amd64 --file 21.0/browsers/Dockerfile -t cimg/openjdk:21.0.3-browsers -t cimg/openjdk:21.0-browsers --push .
