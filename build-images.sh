#!/usr/bin/env bash
# Do not edit by hand; please use build scripts/templates to make changes

docker build --file 11.0/Dockerfile -t cimg/openjdk:11.0.20 -t cimg/openjdk:11.0 --platform linux/amd64 .
docker build --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.20-node -t cimg/openjdk:11.0-node --platform linux/amd64 .
docker build --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.20-browsers -t cimg/openjdk:11.0-browsers --platform linux/amd64 .
docker build --file 17.0/Dockerfile -t cimg/openjdk:17.0.8 -t cimg/openjdk:17.0 --platform linux/amd64 .
docker build --file 17.0/node/Dockerfile -t cimg/openjdk:17.0.8-node -t cimg/openjdk:17.0-node --platform linux/amd64 .
docker build --file 17.0/browsers/Dockerfile -t cimg/openjdk:17.0.8-browsers -t cimg/openjdk:17.0-browsers --platform linux/amd64 .
