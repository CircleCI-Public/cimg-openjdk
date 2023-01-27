#!/usr/bin/env bash
# Do not edit by hand; please use build scripts/templates to make changes

docker build --file 8.0/Dockerfile -t cimg/openjdk:8.0.362 -t cimg/openjdk:8.0 --platform linux/amd64 .
docker build --file 8.0/node/Dockerfile -t cimg/openjdk:8.0.362-node -t cimg/openjdk:8.0-node --platform linux/amd64 .
docker build --file 8.0/browsers/Dockerfile -t cimg/openjdk:8.0.362-browsers -t cimg/openjdk:8.0-browsers --platform linux/amd64 .
docker build --file 11.0/Dockerfile -t cimg/openjdk:11.0.18 -t cimg/openjdk:11.0 --platform linux/amd64 .
docker build --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.18-node -t cimg/openjdk:11.0-node --platform linux/amd64 .
docker build --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.18-browsers -t cimg/openjdk:11.0-browsers --platform linux/amd64 .
docker build --file 17.0/Dockerfile -t cimg/openjdk:17.0.6 -t cimg/openjdk:17.0 --platform linux/amd64 .
docker build --file 17.0/node/Dockerfile -t cimg/openjdk:17.0.6-node -t cimg/openjdk:17.0-node --platform linux/amd64 .
docker build --file 17.0/browsers/Dockerfile -t cimg/openjdk:17.0.6-browsers -t cimg/openjdk:17.0-browsers --platform linux/amd64 .
docker build --file 19.0/Dockerfile -t cimg/openjdk:19.0.2 -t cimg/openjdk:19.0 --platform linux/amd64 .
docker build --file 19.0/node/Dockerfile -t cimg/openjdk:19.0.2-node -t cimg/openjdk:19.0-node --platform linux/amd64 .
docker build --file 19.0/browsers/Dockerfile -t cimg/openjdk:19.0.2-browsers -t cimg/openjdk:19.0-browsers --platform linux/amd64 .
