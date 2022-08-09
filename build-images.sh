#!/usr/bin/env bash
# Do not edit by hand; please use build scripts/templates to make changes

docker build --file 17.0/Dockerfile -t cimg/openjdk:17.0.4  -t cimg/openjdk:17.0 .
docker build --file 17.0/node/Dockerfile -t cimg/openjdk:17.0.4-node  -t cimg/openjdk:17.0-node .
docker build --file 17.0/browsers/Dockerfile -t cimg/openjdk:17.0.4-browsers  -t cimg/openjdk:17.0-browsers .
docker build --file 18.0/Dockerfile -t cimg/openjdk:18.0.2  -t cimg/openjdk:18.0 .
docker build --file 18.0/node/Dockerfile -t cimg/openjdk:18.0.2-node  -t cimg/openjdk:18.0-node .
docker build --file 18.0/browsers/Dockerfile -t cimg/openjdk:18.0.2-browsers  -t cimg/openjdk:18.0-browsers .
