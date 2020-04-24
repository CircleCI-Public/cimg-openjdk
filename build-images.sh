#!/usr/bin/env bash

docker build --file 14.0/Dockerfile -t cimg/openjdk:14.0.1  -t cimg/openjdk:14.0 .
docker build --file 14.0/node/Dockerfile -t cimg/openjdk:14.0.1-node  -t cimg/openjdk:14.0-node .
