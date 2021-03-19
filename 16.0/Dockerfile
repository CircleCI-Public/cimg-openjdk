# vim:set ft=dockerfile:

FROM cimg/base:2021.03

LABEL maintainer="Community & Partner Engineering Team <community-partner@circleci.com>"

ENV JAVA_VERSION 16.0.0
ENV URL https://github.com/AdoptOpenJDK/openjdk16-binaries/releases/download/jdk-16%2B36/OpenJDK16-jdk_x64_linux_hotspot_16_36.tar.gz
ENV JAVA_HOME /usr/local/jdk-${JAVA_VERSION}

RUN curl -sSL -o java.tar.gz "${URL}" && \
	sudo mkdir /usr/local/jdk-${JAVA_VERSION} && \
	sudo tar -xzf java.tar.gz --strip-components=1 -C /usr/local/jdk-${JAVA_VERSION} && \
	rm java.tar.gz && \
	sudo ln -s /usr/local/jdk-${JAVA_VERSION}/bin/java /usr/bin/java && \
	sudo ln -s /usr/local/jdk-${JAVA_VERSION}/bin/javac /usr/bin/javac && \
	sudo ln -s /usr/local/jdk-${JAVA_VERSION}/bin/javaws /usr/bin/javaws && \
	# Install packages to help with legacy image migration
	sudo apt-get update && sudo apt-get install -y \
		fontconfig \
	&& \
	sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	# The dual version command is to support OpenJDK 8
	java --version || java -version && \
	javac --version || javac -version

ENV MAVEN_VERSION=3.6.3 \
	PATH=/opt/apache-maven/bin:$PATH
RUN dl_URL="https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" && \
	curl -sSL --fail --retry 3 $dl_URL -o apache-maven.tar.gz && \
	sudo tar -xzf apache-maven.tar.gz -C /opt/ && \
	rm apache-maven.tar.gz && \
	sudo ln -s /opt/apache-maven-* /opt/apache-maven && \
	mvn --version

ENV GRADLE_VERSION=6.8.3 \
	PATH=/opt/gradle/bin:$PATH
RUN dl_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
	curl -sSL --fail --retry 3 $dl_URL -o gradle.zip && \
	sudo unzip -d /opt gradle.zip && \
	rm gradle.zip && \
	sudo ln -s /opt/gradle-* /opt/gradle && \
	gradle --version
