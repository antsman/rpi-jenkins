#!/bin/bash

# get jenkins
JENKINS_VERSION=2.222.1
wget --timestamping --no-verbose http://mirrors.jenkins.io/war-stable/$JENKINS_VERSION/jenkins.war

# get docker binaries
DOCKER_VERSION=19.03.7
wget --timestamping --no-verbose https://download.docker.com/linux/static/stable/armhf/docker-$DOCKER_VERSION.tgz
tar xzvf docker-$DOCKER_VERSION.tgz --strip 1 docker/docker

# get qemu-arm-static - using with Travis
# wget -nc -nv https://github.com/multiarch/qemu-user-static/releases/download/v2.11.0/qemu-arm-static && chmod +x qemu-arm-static
