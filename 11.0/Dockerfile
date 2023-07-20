# vim:set ft=dockerfile:

# Do not edit individual Dockerfiles manually. Instead, please make changes to the Dockerfile.template, which will be used by the build script to generate Dockerfiles.

# By policy, the base image tag should be a quarterly tag unless there's a
# specific reason to use a different one. This means January, April, July, or
# October.

FROM cimg/base:2023.04

LABEL maintainer="Community & Partner Engineering Team <community-partner@circleci.com>"

ENV JAVA_VERSION 11.0.20
ENV URL https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.20%2B8/OpenJDK11U-jdk_x64_linux_hotspot_11.0.20_8.tar.gz
ENV JAVA_HOME /usr/local/jdk-${JAVA_VERSION}

RUN curl -sSL -o java.tar.gz "${URL}" && \
	sudo mkdir /usr/local/jdk-${JAVA_VERSION} && \
	sudo tar -xzf java.tar.gz --strip-components=1 -C /usr/local/jdk-${JAVA_VERSION} && \
	rm java.tar.gz && \
	if [[ "$JAVA_VERSION" == *"0.0"* ]]; then \
		sudo ln -s /usr/local/jdk-${JAVA_VERSION} /usr/local/jdk-11; \
	fi && \
	sudo ln -s /usr/local/jdk-${JAVA_VERSION}/bin/* /usr/bin/ && \
	sudo mkdir -p /etc/ssl/certs/java/cacerts && \
	sudo ln -s ${JAVA_HOME}/lib/security/cacerts /etc/ssl/certs/java/cacerts && \
	# Install packages to help with legacy image migration
	sudo apt-get update && sudo apt-get install -y \
		fontconfig \
	&& \
	sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	# The dual version command is to support OpenJDK 8
	java --version || java -version && \
	javac --version || javac -version

ENV MAVEN_VERSION=3.9.3 \
	PATH=/opt/apache-maven/bin:$PATH
RUN dl_URL="https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" && \
	curl -sSL --fail --retry 3 $dl_URL -o apache-maven.tar.gz && \
	sudo tar -xzf apache-maven.tar.gz -C /opt/ && \
	rm apache-maven.tar.gz && \
	sudo ln -s /opt/apache-maven-* /opt/apache-maven && \
	mvn --version

ENV GRADLE_VERSION=8.2.1 \
	PATH=/opt/gradle/bin:$PATH
RUN dl_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
	curl -sSL --fail --retry 3 $dl_URL -o gradle.zip && \
	sudo unzip -d /opt gradle.zip && \
	rm gradle.zip && \
	sudo ln -s /opt/gradle-* /opt/gradle && \
	gradle --version

ENV SBT_VERSION=1.9.2 \
	PATH=/opt/sbt/bin:$PATH
RUN dl_URL="https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" && \
	curl -sSL --fail --retry 3 $dl_URL -o sbt.tar.gz && \
	sudo tar -xzf sbt.tar.gz -C /opt/ && \
	sudo ln -s /opt/sbt-* /opt/sbt && \
	sbt about && \
	rm -rf sbt.tar.gz ~/project/project ~/project/target
