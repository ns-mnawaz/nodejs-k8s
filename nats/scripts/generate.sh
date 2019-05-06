#!/bin/sh

#Create Certificates for SSL


kubectl delete configmap nats-config

kubectl create configmap nats-config --from-file ../resources/nats.conf

cd ../cert
sh ./tls.sh
cd -

kubectl create -f ../resources/nats.yaml
sleep 5

# Print current deployment state (unlikely to be finished yet)
kubectl get all 
kubectl get persistentvolumes
echo
echo "Keep running the following command until all pods are shown as running:  kubectl get all"
echo