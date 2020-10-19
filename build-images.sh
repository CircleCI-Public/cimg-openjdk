#!/usr/bin/env bash

docker build --file 8.0/browsers/Dockerfile -t cimg/openjdk:8.0.265-browsers  -t cimg/openjdk:8.0-browsers .
docker build --file 11.0/browsers/Dockerfile -t cimg/openjdk:11.0.8-browsers  -t cimg/openjdk:11.0-browsers .
docker build --file 14.0/browsers/Dockerfile -t cimg/openjdk:14.0.2-browsers  -t cimg/openjdk:14.0-browsers .
docker build --file 15.0/browsers/Dockerfile -t cimg/openjdk:15.0.0-browsers  -t cimg/openjdk:15.0-browsers .
