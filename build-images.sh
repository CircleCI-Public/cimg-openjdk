#!/usr/bin/env bash

docker build --file 8.0/Dockerfile -t cimg/openjdk:8.0.302  -t cimg/openjdk:8.0 .
docker build --file 8.0/node/Dockerfile -t cimg/openjdk:8.0.302-node  -t cimg/openjdk:8.0-node .
docker build --file 8.0/browsers/Dockerfile -t cimg/openjdk:8.0.302-browsers  -t cimg/openjdk:8.0-browsers .
docker build --file 11.0/Dockerfile -t cimg/openjdk:11.0.12  -t cimg/openjdk:11.0 .
docker build --file 11.0/node/Dockerfile -t cimg/openjdk:11.0.12-node  -t cimg/openjdk:11.0-node .
docker build --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.12-browsers  -t cimg/openjdk:11.0-browsers .
docker build --file 17.0/Dockerfile -t cimg/openjdk:17.0.0  -t cimg/openjdk:17.0 .
docker build --file 17.0/node/Dockerfile -t cimg/openjdk:17.0.0-node  -t cimg/openjdk:17.0-node .
docker build --file 17.0/browsers/Dockerfile -t cimg/openjdk:17.0.0-browsers  -t cimg/openjdk:17.0-browsers .
docker build --file lts/Dockerfile -t cimg/openjdk:lts-8.0.302-11.0.12  -t cimg/openjdk:lts-8-11 .
docker build --file lts/node/Dockerfile -t cimg/openjdk:lts-8.0.302-11.0.12-node  -t cimg/openjdk:lts-8-11-node .
docker build --file lts/browsers/Dockerfile -t cimg/openjdk:lts-8.0.302-11.0.12-browsers  -t cimg/openjdk:8-11-browsers .
docker build --file lts.plus/Dockerfile -t cimg/openjdk:lts-8.0.302-11.0.12-17.0.0  -t cimg/openjdk:lts-8-11-plus .
docker build --file lts.plus/node/Dockerfile -t cimg/openjdk:lts-8.0.302-11.0.12-17.0.0-node  -t cimg/openjdk:lts-8-11-plus-node .
docker build --file lts.plus/browsers/Dockerfile -t cimg/openjdk:lts-8.0.302-11.0.12-17.0.0-browsers  -t cimg/openjdk:8-11-plus-browsers .
