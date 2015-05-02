#!/bin/bash

# Delete all untagged images

docker rmi $(docker images | fgrep "<none>" | awk '{print $3}')
