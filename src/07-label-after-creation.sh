#!/usr/bin/env bash

echo '********** kubectl create -f 02-basic-pod.yaml'
kubectl create -f $SCRIPT_DIR/02-basic-pod.yaml
echo '********** kubectl get po --show-labels'
kubectl get po --show-labels

echo '********** kubectl label po basic-pod app=BApp'
kubectl label po basic-pod app=BApp
echo '********** kubectl label po basic-pod team=HappyDays'
kubectl label po basic-pod team=HappyDays
echo '********** kubectl get po --show-labels'
kubectl get po --show-labels

echo '********** kubectl label po basic-pod team=A-Team --overwrite'
kubectl label po basic-pod team=A-Team --overwrite
echo '********** kubectl get po --show-labels'
kubectl get po --show-labels