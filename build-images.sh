#!/usr/bin/env bash

docker build --file 8.0/Dockerfile -t cimg/openjdk:8.0.302  -t cimg/openjdk:8.0 .
docker build --file 8.0/node/Dockerfile -t cimg/openjdk:8.0.302-node  -t cimg/openjdk:8.0-node .
docker build --file 8.0/browsers/Dockerfile -t cimg/openjdk:8.0.302-browsers  -t cimg/openjdk:8.0-browsers .
docker build --file 17.0/Dockerfile -t cimg/openjdk:17.0.0  -t cimg/openjdk:17.0 .
docker build --file 17.0/node/Dockerfile -t cimg/openjdk:17.0.0-node  -t cimg/openjdk:17.0-node .
docker build --file 17.0/browsers/Dockerfile -t cimg/openjdk:17.0.0-browsers  -t cimg/openjdk:17.0-browsers .
