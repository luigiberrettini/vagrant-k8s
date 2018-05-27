#!/usr/bin/env bash

echo '********** kubectl get ns'
kubectl get ns

echo '********** kubectl create namespace cli-ns'
kubectl create namespace ns-a

echo '********** kubectl create -f <namespace-HEREDOC>'
echo 'kubectl create -f - <<EOF'
echo 'apiVersion: v1'
echo 'kind: Namespace'
echo 'metadata:'
echo '  name: ns-b'
echo 'EOF'
kubectl create -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: ns-b
EOF
echo '********** kubectl get ns'
kubectl get ns

echo '********** kubectl create -f 02-basic-pod.yaml -n ns-a'
kubectl create -f 02-basic-pod.yaml -n ns-a
echo '********** kubectl create -f 02-basic-pod.yaml -n ns-b'
kubectl create -f 02-basic-pod.yaml -n ns-b
echo '********** kubectl get po --all-namespaces'
kubectl get po --all-namespaces