#!/bin/sh
##
# Script to remove/undepoy all project resources from the local Minikube environment.
##

# Delete mongod stateful set + mongodb service + secrets + host vm configuer daemonset
kubectl delete -f ../resources/mongodb-service.yaml
kubectl delete secret mongo-shared-secret
sleep 3

# Delete persistent volume claims
kubectl delete persistentvolumeclaims -l role=mongo
kubectl delete pv -l role=mongo

