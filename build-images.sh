#!/usr/bin/env bash

docker build --file 8.0/Dockerfile -t cimg/openjdk:8.0.312  -t cimg/openjdk:8.0 .
docker build --file 8.0/node/Dockerfile -t cimg/openjdk:8.0.312-node  -t cimg/openjdk:8.0-node .
docker build --file 8.0/browsers/Dockerfile -t cimg/openjdk:8.0.312-browsers  -t cimg/openjdk:8.0-browsers .
docker build --file 11.0/Dockerfile -t cimg/openjdk:11.0.13  -t cimg/openjdk:11.0 .
docker build --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.13-node  -t cimg/openjdk:11.0-node .
docker build --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.13-browsers  -t cimg/openjdk:11.0-browsers .
