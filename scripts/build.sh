#!/bin/bash

DOCKER_REGISTRY=${DOCKER_REGISTRY:-rgabdullin}

if [ -f private/docker_password ]
then
    echo "Docker password found"
    cat "private/docker_password" | docker login --username=${DOCKER_REGISTRY} --password-stdin
fi
