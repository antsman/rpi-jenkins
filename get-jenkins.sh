#!/bin/bash

# get jenkins
wget -nc http://mirrors.jenkins.io/war-stable/latest/jenkins.war

# find Jenkins version
echo JENKINS_VERSION=\"$(unzip -p jenkins.war META-INF/MANIFEST.MF | grep Jenkins-Version | awk '{printf $2}'| tr -d '\r')\" | tee env.properties

# get docker binaries
DOCKER_VERSION=19.03.5
wget -nc https://download.docker.com/linux/static/stable/armhf/docker-$DOCKER_VERSION.tgz
tar xzvf docker-$DOCKER_VERSION.tgz --strip 1 docker/docker

# get qemu-arm-static - using with Travis
# wget -nc -nv https://github.com/multiarch/qemu-user-static/releases/download/v2.11.0/qemu-arm-static && chmod +x qemu-arm-static
