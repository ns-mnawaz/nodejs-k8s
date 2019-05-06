#!/bin/sh

#Create Certificates for SSL


kubectl delete configmap nats-config
kubectl delete secret tls-nats-server
kubectl delete secret tls-nats-client

kubectl delete -f ../resources/nats.yaml