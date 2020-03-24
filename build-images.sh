#!/usr/bin/env bash

docker build --file 11.0/Dockerfile -t cimg/openjdk:11.0.6  -t cimg/openjdk:11.0 .
docker build --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.6-node  -t cimg/openjdk:11.0-node .
