#!/bin/sh
##
# Script to remove/undepoy all project resources from the local Minikube environment.
##

kubectl delete secret redis-config
# Delete mongod stateful set + mongodb service + secrets + host vm configuer daemonset
kubectl delete -f ../resources/redis-service.yaml
sleep 3

# Delete persistent volume claims
kubectl delete pvc redis-storage-redis-0
kubectl delete persistentvolumeclaims -l role=redis
kubectl delete pv -l role=redis

