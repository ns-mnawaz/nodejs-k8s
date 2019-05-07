#!/bin/sh
##
# Script to remove/undepoy all project resources from the local Minikube environment.
##

kubectl delete -f ./deploy.yaml
sleep 3
kubectl delete svc node-app

