# vim:set ft=dockerfile:

FROM cimg/base:2020.01

LABEL maintainer="Community & Partner Engineering Team <community-partner@circleci.com>"

ENV JAVA_VERSION 12.0.2
ENV URL https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.2%2B10/OpenJDK12U-jdk_x64_linux_hotspot_12.0.2_10.tar.gz
ENV JAVA_HOME /usr/local/jdk-${JAVA_VERSION}

RUN curl -sSL -o java.tar.gz "${URL}" && \
	sudo mkdir /usr/local/jdk-${JAVA_VERSION} && \
	sudo tar -xzf java.tar.gz --strip-components=1 -C /usr/local/jdk-${JAVA_VERSION} && \
	rm java.tar.gz && \
	sudo ln -s /usr/local/jdk-${JAVA_VERSION}/bin/java /usr/bin/java && \
	sudo ln -s /usr/local/jdk-${JAVA_VERSION}/bin/javac /usr/bin/javac && \
	sudo ln -s /usr/local/jdk-${JAVA_VERSION}/bin/javaws /usr/bin/javaws && \
	java --version && \
	javac --version
