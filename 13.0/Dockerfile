# vim:set ft=dockerfile:

FROM cimg/base:2019.10

LABEL maintainer="CircleCI Community & Partner Engineering Team <community-partner@circleci.com>"

# This can be removed with the next monthly base image.
# Generate & set locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV JAVA_VERSION 13.0.0
ENV URL https://download.java.net/java/GA/jdk13/5b8a42f3905b406298b72d750b6919f6/33/GPL/openjdk-13_linux-x64_bin.tar.gz

RUN curl -o java.tar.gz "${URL}" && \
	tar -xzf java.tar.gz -C /usr/local && \
	rm java.tar.gz && \
	ln -s /usr/local/jdk-${JAVA_VERSION}/bin/java /usr/bin/java && \
	ln -s /usr/local/jdk-${JAVA_VERSION}/bin/javac /usr/bin/javac && \
	ln -s /usr/local/jdk-${JAVA_VERSION}/bin/javaws /usr/bin/javaws
	
ENV JAVA_HOME /usr/local/jdk-${JAVA_VERSION}
	
WORKDIR /root/project
