# vim:set ft=dockerfile:

FROM cimg/base:2021.10

LABEL maintainer="Community & Partner Engineering Team <community-partner@circleci.com>"

ENV JAVA_VERSION 16.0.2
ENV URL https://github.com/adoptium/temurin16-binaries/releases/download/jdk-16.0.2%2B7/OpenJDK16U-jdk_x64_linux_hotspot_16.0.2_7.tar.gz
ENV JAVA_HOME /usr/local/jdk-${JAVA_VERSION}

RUN curl -sSL -o java.tar.gz "${URL}" && \
	sudo mkdir /usr/local/jdk-${JAVA_VERSION} && \
	sudo tar -xzf java.tar.gz --strip-components=1 -C /usr/local/jdk-${JAVA_VERSION} && \
	rm java.tar.gz && \
	if [[ "$JAVA_VERSION" == *"0.0"* ]]; then \
		sudo ln -s /usr/local/jdk-${JAVA_VERSION} /usr/local/jdk-16; \
	fi && \
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

ENV MAVEN_VERSION=3.8.4 \
	PATH=/opt/apache-maven/bin:$PATH
RUN dl_URL="https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" && \
	curl -sSL --fail --retry 3 $dl_URL -o apache-maven.tar.gz && \
	sudo tar -xzf apache-maven.tar.gz -C /opt/ && \
	rm apache-maven.tar.gz && \
	sudo ln -s /opt/apache-maven-* /opt/apache-maven && \
	mvn --version

ENV GRADLE_VERSION=7.3.2 \
	PATH=/opt/gradle/bin:$PATH
RUN dl_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
	curl -sSL --fail --retry 3 $dl_URL -o gradle.zip && \
	sudo unzip -d /opt gradle.zip && \
	rm gradle.zip && \
	sudo ln -s /opt/gradle-* /opt/gradle && \
	gradle --version

ENV SBT_VERSION=1.5.8 \
	PATH=/opt/sbt/bin:$PATH
RUN dl_URL="https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" && \
	curl -sSL --fail --retry 3 $dl_URL -o sbt.tar.gz && \
	sudo tar -xzf sbt.tar.gz -C /opt/ && \
	sudo ln -s /opt/sbt-* /opt/sbt && \
	sbt about && \
	rm -r sbt.tar.gz ~/project/project ~/project/target
