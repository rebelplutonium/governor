#!/bin/sh

cd /opt/docker/workspace &&
    docker-compose stop &&
    docker-compose rm -fv