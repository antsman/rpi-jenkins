#!/bin/bash

# get jenkins
JENKINS_VERSION=2.426.2
wget --timestamping --no-verbose http://mirrors.jenkins.io/war-stable/$JENKINS_VERSION/jenkins.war

# get docker binaries
DOCKER_VERSION=24.0.7
wget --timestamping --no-verbose https://download.docker.com/linux/static/stable/aarch64/docker-$DOCKER_VERSION.tgz
tar xzvf docker-$DOCKER_VERSION.tgz --strip 1 docker/docker
