#!/usr/bin/env bash
# Do not edit by hand; please use build scripts/templates to make changes

docker build --file 8.0/Dockerfile -t cimg/openjdk:8.0.345 -t cimg/openjdk:8.0 .
docker build --file 8.0/node/Dockerfile -t cimg/openjdk:8.0.345-node -t cimg/openjdk:8.0-node .
docker build --file 8.0/browsers/Dockerfile -t cimg/openjdk:8.0.345-browsers -t cimg/openjdk:8.0-browsers .
docker build --file 11.0/Dockerfile -t cimg/openjdk:11.0.16 -t cimg/openjdk:11.0 .
docker build --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.16-node -t cimg/openjdk:11.0-node .
docker build --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.16-browsers -t cimg/openjdk:11.0-browsers .
