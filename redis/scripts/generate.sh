#!/bin/sh
##
# Script to deploy a Kubernetes project with a StatefulSet running a redis
##

#Delete Redis Config
kubectl delete secret redis-config
#Create Password Config
kubectl create secret generic redis-config  --from-literal="password=abcd@1234"

# Create redis service with redis stateful-set
kubectl apply -f ../resources/redis-service.yaml
sleep 5

# Print current deployment state (unlikely to be finished yet)
kubectl get all 
kubectl get persistentvolumes
echo
echo "Keep running the following command until all pods are shown as running:  kubectl get all"
echo

