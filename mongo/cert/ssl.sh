#!/bin/bash

rm server.pem ca.pem
echo 'Generating self signed certificate'
#Create a 2048 bit Certificate Authority (CA) private key:
openssl genrsa -out privkey.pem 2048
#Create a self signed CA certificate:
openssl req -new -x509 -days 3650 -nodes -key privkey.pem  -sha256 -out ca.pem -subj "/C=PK/ST=Sindh/L=Karachi/O=Avanza" 
#Create a server Certificate Signing Request (CSR) and server private key.
openssl req -new -nodes -out server.csr -keyout server.key -config req.conf
#Create the server certificate:
openssl x509 -req -in server.csr -CA ca.pem -CAkey privkey.pem  -CAcreateserial -out server.crt -days 3650  -extfile server_v3.ext
#merge Certificate Authority (CA) and server certificate
cat server.key server.crt > server.pem
#Remove Files
rm ca.srl privkey.pem server.crt server.csr server.key 
#Delete secret 
kubectl delete secret mongo-ssl
#Create secret
kubectl create secret generic mongo-ssl --from-file=./server.pem --from-file=./ca.pem