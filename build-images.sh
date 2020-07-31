#!/usr/bin/env bash

docker build --file 11.0/Dockerfile -t cimg/openjdk:11.0.8  -t cimg/openjdk:11.0 .
docker build --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.8-node  -t cimg/openjdk:11.0-node .
docker build --file 14.0/Dockerfile -t cimg/openjdk:14.0.2  -t cimg/openjdk:14.0 .
docker build --file 14.0/node/Dockerfile -t cimg/openjdk:14.0.2-node  -t cimg/openjdk:14.0-node .
