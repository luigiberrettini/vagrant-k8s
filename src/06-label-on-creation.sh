#!/usr/bin/env bash

echo '********** cat 05-labeled-pod.yaml'
cat $SCRIPT_DIR/05-labeled-pod.yaml
echo '********** kubectl create -f 05-labeled-pod.yaml'
kubectl create -f $SCRIPT_DIR/05-labeled-pod.yaml

echo '********** kubectl get po --show-labels'
kubectl get po --show-labels
echo '********** kubectl get po -L kind,team'
kubectl get po -L kind,team