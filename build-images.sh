#!/usr/bin/env bash

docker build --file 8.0/Dockerfile -t cimg/openjdk:8.0.282 -t cimg/openjdk:8.0 .
docker build --file 8.0/node/Dockerfile -t cimg/openjdk:8.0.282-node -t cimg/openjdk:8.0-node .
docker build --file 8.0/browsers/Dockerfile -t cimg/openjdk:8.0.282-browsers -t cimg/openjdk:8.0-browsers .

docker build --file 11.0/Dockerfile -t cimg/openjdk:11.0.10 -t cimg/openjdk:11.0 .
docker build --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.10-node -t cimg/openjdk:11.0-node .
docker build --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.10-browsers -t cimg/openjdk:11.0-browsers .

docker build --file 15.0/Dockerfile -t cimg/openjdk:15.0.2 -t cimg/openjdk:15.0 .
docker build --file 15.0/node/Dockerfile -t cimg/openjdk:15.0.2-node -t cimg/openjdk:15.0-node .
docker build --file 15.0/browsers/Dockerfile -t cimg/openjdk:15.0.2-browsers -t cimg/openjdk:15.0-browsers .
