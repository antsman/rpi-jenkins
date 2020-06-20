#!/bin/bash

# get jenkins
JENKINS_VERSION=2.235.1
wget --timestamping --no-verbose http://mirrors.jenkins.io/war-stable/$JENKINS_VERSION/jenkins.war

# get docker binaries
DOCKER_VERSION=19.03.9
wget --timestamping --no-verbose https://download.docker.com/linux/static/stable/armhf/docker-$DOCKER_VERSION.tgz
tar xzvf docker-$DOCKER_VERSION.tgz --strip 1 docker/docker
