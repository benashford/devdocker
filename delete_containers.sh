#!/bin/bash

# Delete all containers

docker rm $(docker ps -a -q)
