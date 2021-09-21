#!/bin/bash
DOCKER_IMAGE=$1
docker run --name falco-demo --rm -i -t $DOCKER_IMAGE 
