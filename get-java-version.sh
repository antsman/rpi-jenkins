#!/bin/bash

test -n "$1" && (
    echo JAVA_VERSION=\"$(docker exec -t $1 java -version | grep version | awk -F\" '{ print $2 }')\" | tee -a env.properties
) || (
    echo Give container name as parameter!
)

