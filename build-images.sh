#!/usr/bin/env bash

docker build --file 13.0/Dockerfile -t cimg/openjdk:13.0.2  -t cimg/openjdk:13.0 .
docker build --file 13.0/node/Dockerfile -t cimg/openjdk:13.0.2-node  -t cimg/openjdk:13.0-node .
