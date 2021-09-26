#!/usr/bin/env bash

docker build --file 11.0/Dockerfile -t cimg/openjdk:11.0.0  -t cimg/openjdk:11.0 .
docker build --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.0-node  -t cimg/openjdk:11.0-node .
docker build --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.0-browsers  -t cimg/openjdk:11.0-browsers .
docker build --file 12.0/Dockerfile -t cimg/openjdk:12.0.0  -t cimg/openjdk:12.0 .
docker build --file 12.0/node/Dockerfile -t cimg/openjdk:12.0.0-node  -t cimg/openjdk:12.0-node .
docker build --file 12.0/browsers/Dockerfile -t cimg/openjdk:12.0.0-browsers  -t cimg/openjdk:12.0-browsers .
docker build --file 13.0/Dockerfile -t cimg/openjdk:13.0.0  -t cimg/openjdk:13.0 .
docker build --file 13.0/node/Dockerfile -t cimg/openjdk:13.0.0-node  -t cimg/openjdk:13.0-node .
docker build --file 13.0/browsers/Dockerfile -t cimg/openjdk:13.0.0-browsers  -t cimg/openjdk:13.0-browsers .
docker build --file 14.0/Dockerfile -t cimg/openjdk:14.0.0  -t cimg/openjdk:14.0 .
docker build --file 14.0/node/Dockerfile -t cimg/openjdk:14.0.0-node  -t cimg/openjdk:14.0-node .
docker build --file 14.0/browsers/Dockerfile -t cimg/openjdk:14.0.0-browsers  -t cimg/openjdk:14.0-browsers .
docker build --file 15.0/Dockerfile -t cimg/openjdk:15.0.0  -t cimg/openjdk:15.0 .
docker build --file 15.0/node/Dockerfile -t cimg/openjdk:15.0.0-node  -t cimg/openjdk:15.0-node .
docker build --file 15.0/browsers/Dockerfile -t cimg/openjdk:15.0.0-browsers  -t cimg/openjdk:15.0-browsers .
docker build --file 16.0/Dockerfile -t cimg/openjdk:16.0.0  -t cimg/openjdk:16.0 .
docker build --file 16.0/node/Dockerfile -t cimg/openjdk:16.0.0-node  -t cimg/openjdk:16.0-node .
docker build --file 16.0/browsers/Dockerfile -t cimg/openjdk:16.0.0-browsers  -t cimg/openjdk:16.0-browsers .
