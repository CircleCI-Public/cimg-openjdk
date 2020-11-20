#!/usr/bin/env bash

docker build --file 8.0/browsers/Dockerfile -t cimg/openjdk:8.0.252-browsers  -t cimg/openjdk:8.0-browsers .
docker build --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.9-browsers  -t cimg/openjdk:11.0-browsers .
docker build --file 14.0/browsers/Dockerfile -t cimg/openjdk:14.0.1-browsers  -t cimg/openjdk:14.0-browsers .
docker build --file 15.0/browsers/Dockerfile -t cimg/openjdk:15.0.1-browsers  -t cimg/openjdk:15.0-browsers .
