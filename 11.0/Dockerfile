# vim:set ft=dockerfile:

FROM cimg/base:edge

LABEL maintainer="CircleCI Community & Partner Engineering Team <community-partner@circleci.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_VERSION 11.0.1

RUN MAJOR_VERSION=$(echo $JAVA_VERSION | cut -d. -f1) && \
	curl -o java.tar.gz "https://download.java.net/java/GA/jdk${JAVA_VERSION}/69cfe15208a647278a19ef0990eea691/${MAJOR_VERSION}/GPL/openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz" && \
	tar -xzf java.tar.gz -C /usr/local && \
	rm java.tar.gz && \
	ln -s /usr/local/jdk-${JAVA_VERSION}/bin/java /usr/bin/java && \
	ln -s /usr/local/jdk-${JAVA_VERSION}/bin/javac /usr/bin/javac && \
	ln -s /usr/local/jdk-${JAVA_VERSION}/bin/javaws /usr/bin/javaws
	
ENV JAVA_HOME /usr/local/jdk-${JAVA_VERSION}/bin/java
	
WORKDIR /root/project
