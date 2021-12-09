#!/usr/bin/env bash

docker build --file 17.0/Dockerfile -t cimg/openjdk:17.0.1  -t cimg/openjdk:17.0 .
docker build --file 17.0/node/Dockerfile -t cimg/openjdk:17.0.1-node  -t cimg/openjdk:17.0-node .
docker build --file 17.0/browsers/Dockerfile -t cimg/openjdk:17.0.1-browsers  -t cimg/openjdk:17.0-browsers .
