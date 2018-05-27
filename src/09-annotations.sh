#!/usr/bin/env bash

echo '********** kubectl create -f 02-basic-pod.yaml'
kubectl create -f $SCRIPT_DIR/02-basic-pod.yaml

echo '********** kubectl annotate pod basic-pod companyName.com/annotationKey="annotationValue"'
kubectl annotate pod basic-pod companyName.com/annotationKey="annotationValue"

echo '********** kubectl describe po basic-pod'
kubectl describe po basic-pod

echo '********** kubectl delete po basic-pod'
kubectl delete po basic-pod