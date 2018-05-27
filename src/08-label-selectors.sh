#!/usr/bin/env bash

echo '********** key == k or key != k'
echo "kubectl get po -l 'team'"
kubectl get po -l 'team'
echo "kubectl get po -l '!team'"
kubectl get po -l '!team'

echo '********** key in/not in a set'
echo 'kubectl get po -l app in (BApp, LApp)'
kubectl get po -l app in (BApp, LApp)
echo 'kubectl get po -l app notin (BApp, MyApp)'
kubectl get po -l app notin (BApp, MyApp)

echo '********** value == v or value != v'
echo 'kubectl get po -l app=LApp'
kubectl get po -l app=LApp
echo 'kubectl get po -l app!=LApp'
kubectl get po -l app!=LApp

echo '********** multiple selectors'
echo 'kubectl get po -l team=A-Team,kind=FrontOffice'
kubectl get po -l team=A-Team,kind=FrontOffice

echo "********** kubectl delete po -l 'team'"
kubectl delete po -l 'team'