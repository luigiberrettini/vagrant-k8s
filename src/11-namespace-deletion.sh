#!/usr/bin/env bash

echo '********** kubectl get ns'
kubectl get ns

echo '********** kubectl delete ns ns-a'
kubectl delete ns ns-a
echo '********** kubectl get ns'
kubectl get ns
echo '********** kubectl get po --all-namespaces'
kubectl get po --all-namespaces

echo '********** kubectl delete po --all'
kubectl delete po --all
echo '********** kubectl get ns'
kubectl get ns
echo '********** kubectl get po --all-namespaces'
kubectl get po --all-namespaces

echo '********** kubectl delete ns ns-b'
kubectl delete ns ns-b
echo '********** kubectl get ns'
kubectl get ns