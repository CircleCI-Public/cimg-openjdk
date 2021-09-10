#!/usr/bin/env bash

docker build --file 8.0/Dockerfile -t cimg/openjdk:8.0.292  -t cimg/openjdk:8.0 .
docker build --file 8.0/node/Dockerfile -t cimg/openjdk:8.0.292-node  -t cimg/openjdk:8.0-node .
docker build --file 8.0/browsers/Dockerfile -t cimg/openjdk:8.0.292-browsers  -t cimg/openjdk:8.0-browsers .
docker build --file 11.0/Dockerfile -t cimg/openjdk:11.0.12  -t cimg/openjdk:11.0 .
docker build --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.12-node  -t cimg/openjdk:11.0-node .
docker build --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.12-browsers  -t cimg/openjdk:11.0-browsers .
docker build --file 16.0/Dockerfile -t cimg/openjdk:16.0.2  -t cimg/openjdk:16.0 .
docker build --file 16.0/node/Dockerfile -t cimg/openjdk:16.0.2-node  -t cimg/openjdk:16.0-node .
docker build --file 16.0/browsers/Dockerfile -t cimg/openjdk:16.0.2-browsers  -t cimg/openjdk:16.0-browsers .
