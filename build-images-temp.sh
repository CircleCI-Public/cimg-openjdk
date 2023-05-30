docker build --file 20.0/Dockerfile -t cimg/openjdk:20.0.1 -t cimg/openjdk:20.0 --platform linux/amd64 .
docker build --file 20.0/node/Dockerfile -t cimg/openjdk:20.0.1-node -t cimg/openjdk:20.0-node --platform linux/amd64 .
docker build --file 20.0/browsers/Dockerfile -t cimg/openjdk:20.0.1-browsers -t cimg/openjdk:20.0-browsers --platform linux/amd64 .
