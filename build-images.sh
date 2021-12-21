#!/usr/bin/env bash

docker build --file 8.0/Dockerfile -t cimg/openjdk:8.0.312  -t cimg/openjdk:8.0 .
docker build --file 8.0/node/Dockerfile -t cimg/openjdk:8.0.312-node  -t cimg/openjdk:8.0-node .
docker build --file 8.0/browsers/Dockerfile -t cimg/openjdk:8.0.312-browsers  -t cimg/openjdk:8.0-browsers .
docker build --file 11.0/Dockerfile -t cimg/openjdk:11.0.13  -t cimg/openjdk:11.0 .
docker build --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.13-node  -t cimg/openjdk:11.0-node .
docker build --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.13-browsers  -t cimg/openjdk:11.0-browsers .
docker build --file 16.0/Dockerfile -t cimg/openjdk:16.0.2  -t cimg/openjdk:16.0 .
docker build --file 16.0/node/Dockerfile -t cimg/openjdk:16.0.2-node  -t cimg/openjdk:16.0-node .
docker build --file 16.0/browsers/Dockerfile -t cimg/openjdk:16.0.2-browsers  -t cimg/openjdk:16.0-browsers .
docker build --file 17.0/Dockerfile -t cimg/openjdk:17.0.1  -t cimg/openjdk:17.0 .
docker build --file 17.0/node/Dockerfile -t cimg/openjdk:17.0.1-node  -t cimg/openjdk:17.0-node .
docker build --file 17.0/browsers/Dockerfile -t cimg/openjdk:17.0.1-browsers  -t cimg/openjdk:17.0-browsers .
