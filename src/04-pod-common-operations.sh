#!/usr/bin/env bash

echo '********** kubectl get pods'
kubectl get pods
echo '********** kubectl get po basic-pod -o yaml'
kubectl get po basic-pod -o yaml
echo '********** kubectl get po basic-pod -o json'
kubectl get po basic-pod -o json
echo '********** kubectl describe po basic-pod'
kubectl describe po basic-pod

echo '********** kubectl port-forward basic-pod 8000:8012 *** '
kubectl port-forward basic-pod 8000:8012
echo '********** curl localhost:8000'
curl localhost:8000

echo '********** kubectl logs basic-pod -c cntnr'
kubectl logs basic-pod -c cntnr

echo '********** kubectl delete po basic-pod'
kubectl delete po basic-pod