#!/usr/bin/env bash

docker build --file 8.0/Dockerfile -t cimg/openjdk:8.0.282  -t cimg/openjdk:8.0 .
docker build --file 8.0/node/Dockerfile -t cimg/openjdk:8.0.282-node  -t cimg/openjdk:8.0-node .
docker build --file 8.0/browsers/Dockerfile -t cimg/openjdk:8.0.282-browsers  -t cimg/openjdk:8.0-browsers .
docker build --file 11.0/Dockerfile -t cimg/openjdk:11.0.10  -t cimg/openjdk:11.0 .
docker build --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.10-node  -t cimg/openjdk:11.0-node .
docker build --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.10-browsers  -t cimg/openjdk:11.0-browsers .
docker build --file 15.0/Dockerfile -t cimg/openjdk:15.0.2  -t cimg/openjdk:15.0 .
docker build --file 15.0/node/Dockerfile -t cimg/openjdk:15.0.2-node  -t cimg/openjdk:15.0-node .
docker build --file 15.0/browsers/Dockerfile -t cimg/openjdk:15.0.2-browsers  -t cimg/openjdk:15.0-browsers .
docker build --file 16.0/Dockerfile -t cimg/openjdk:16.0.0  -t cimg/openjdk:16.0 .
docker build --file 16.0/node/Dockerfile -t cimg/openjdk:16.0.0-node  -t cimg/openjdk:16.0-node .
docker build --file 16.0/browsers/Dockerfile -t cimg/openjdk:16.0.0-browsers  -t cimg/openjdk:16.0-browsers .
docker build --file lts/Dockerfile -t cimg/openjdk:lts-8.0.282-11.0.10  -t cimg/openjdk:lts-8-11 .
docker build --file lts/node/Dockerfile -t cimg/openjdk:lts-8.0.282-11.0.10-node  -t cimg/openjdk:lts-8-11-node .
docker build --file lts/browsers/Dockerfile -t cimg/openjdk:lts-8.0.282-11.0.10-browsers  -t cimg/openjdk:8-11-browsers .
docker build --file lts.plus/Dockerfile -t cimg/openjdk:lts-8.0.282-11.0.10-16.0.0  -t cimg/openjdk:lts-8-11-plus .
docker build --file lts.plus/node/Dockerfile -t cimg/openjdk:lts-8.0.282-11.0.10-16.0.0-node  -t cimg/openjdk:lts-8-11-plus-node .
docker build --file lts.plus/browsers/Dockerfile -t cimg/openjdk:lts-8.0.282-11.0.10-16.0.0-browsers  -t cimg/openjdk:8-11-plus-browsers .
