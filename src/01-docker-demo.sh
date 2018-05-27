#!/usr/bin/env bash

echo '********** docker container run -d -p 8080:8080 --name dkr-demo luksa/kubia:v1'
docker container run -d -p 8080:8080 --name dkr-demo luksa/kubia:v1

echo '********** docker container logs dkr-demo'
docker container logs dkr-demo

echo '********** docker container exec -ti dkr-demo ls -Al'
docker container exec -ti dkr-demo ls -Al

echo '********** docker container stop dkr-demo'
docker container stop dkr-demo