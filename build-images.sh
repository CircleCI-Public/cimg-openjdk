#!/usr/bin/env bash

docker build --file 8.0/Dockerfile -t cimg/openjdk:8.0.272  -t cimg/openjdk:8.0 .
docker build --file 8.0/node/Dockerfile -t cimg/openjdk:8.0.272-node  -t cimg/openjdk:8.0-node .
docker build --file 8.0/browsers/Dockerfile -t cimg/openjdk:8.0.272-browsers  -t cimg/openjdk:8.0-browsers .
docker build --file 11.0/Dockerfile -t cimg/openjdk:11.0.9  -t cimg/openjdk:11.0 .
docker build --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.9-node  -t cimg/openjdk:11.0-node .
docker build --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.9-browsers  -t cimg/openjdk:11.0-browsers .
docker build --file 15.0/Dockerfile -t cimg/openjdk:15.0.1  -t cimg/openjdk:15.0 .
docker build --file 15.0/node/Dockerfile -t cimg/openjdk:15.0.1-node  -t cimg/openjdk:15.0-node .
docker build --file 15.0/browsers/Dockerfile -t cimg/openjdk:15.0.1-browsers  -t cimg/openjdk:15.0-browsers .
