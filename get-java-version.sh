#!/bin/bash

VERSIONS=version.properties

test -n "$1" && (
    echo JENKINS_VERSION=\"$(docker exec -t $1 cat /data/war/META-INF/MANIFEST.MF | grep Jenkins-Version | awk '{ print $2 }' | tr -d '\r')\" | tee $VERSIONS
    echo JAVA_VERSION=\"$(docker exec -t $1 java -version | grep version | awk -F\" '{ print $2 }')\" | tee -a $VERSIONS
    echo DOCKER_VERSION=\"$(docker exec -t $1 docker --version | grep version | awk '{ print $3 }' | tr -d ',')\" | tee -a $VERSIONS
) || (
    echo Give container name as parameter!
    exit 1
)

