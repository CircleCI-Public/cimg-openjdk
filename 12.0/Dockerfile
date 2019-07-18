# vim:set ft=dockerfile:

FROM cimg/base:edge

LABEL maintainer="CircleCI Community & Partner Engineering Team <community-partner@circleci.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_VERSION 12.0.1
ENV URL https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_linux-x64_bin.tar.gz

RUN curl -o java.tar.gz "${URL}" && \
	tar -xzf java.tar.gz -C /usr/local && \
	rm java.tar.gz && \
	ln -s /usr/local/jdk-${JAVA_VERSION}/bin/java /usr/bin/java && \
	ln -s /usr/local/jdk-${JAVA_VERSION}/bin/javac /usr/bin/javac && \
	ln -s /usr/local/jdk-${JAVA_VERSION}/bin/javaws /usr/bin/javaws
	
ENV JAVA_HOME /usr/local/jdk-${JAVA_VERSION}/bin/java
	
WORKDIR /root/project
