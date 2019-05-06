#!/bin/bash

rm ca-key.pem ca.pem ca.srl nats-key.pem nats.csr nats.pem

kubectl delete secret tls-nats-server
kubectl delete secret tls-nats-client

openssl genrsa -out ca-key.pem 2048
openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kube-ca"
openssl genrsa -out nats-key.pem 2048
openssl req -new -key nats-key.pem -out nats.csr -subj "/CN=kube-nats" -config ssl.cnf
openssl x509 -req -in nats.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out nats.pem -days 3650 -extensions v3_req -extfile ssl.cnf

kubectl create secret generic tls-nats-server --from-file nats.pem --from-file nats-key.pem --from-file ca.pem
kubectl create secret generic tls-nats-client --from-file ca.pem