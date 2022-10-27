#!/usr/bin/env bash
# Do not edit by hand; please use build scripts/templates to make changes

docker build --file 11.0/Dockerfile -t cimg/openjdk:11.0.17 -t cimg/openjdk:11.0 .
docker build --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.17-node -t cimg/openjdk:11.0-node .
docker build --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.17-browsers -t cimg/openjdk:11.0-browsers .
docker build --file 17.0/Dockerfile -t cimg/openjdk:17.0.5 -t cimg/openjdk:17.0 .
docker build --file 17.0/node/Dockerfile -t cimg/openjdk:17.0.5-node -t cimg/openjdk:17.0-node .
docker build --file 17.0/browsers/Dockerfile -t cimg/openjdk:17.0.5-browsers -t cimg/openjdk:17.0-browsers .
