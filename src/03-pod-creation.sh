#!/usr/bin/env bash

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo '********** kubectl explain pods'
kubectl explain pods
echo '********** kubectl explain pods.spec'
kubectl explain pods.spec

echo '********** cat 02-basic-pod.yaml'
cat $SCRIPT_DIR/02-basic-pod.yaml

echo '********** kubectl create -f 02-basic-pod.yaml'
kubectl create -f $SCRIPT_DIR/02-basic-pod.yaml