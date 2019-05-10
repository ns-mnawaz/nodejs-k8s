## Deploy mongodb 

```
cd mongo/scripts
./generate.sh
```
Wait for pods running status
```
NAME           READY   STATUS    RESTARTS   AGE
pod/mongod-0   1/1     Running   0          3m28s
pod/mongod-1   1/1     Running   0          3m17s
pod/mongod-2   1/1     Running   0          3m4s

NAME                      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)     AGE
service/kubernetes        ClusterIP   10.96.0.1      <none>        443/TCP     7d
service/mongodb-service   ClusterIP   None   <none>        27017/TCP   3m28s

NAME                      READY   AGE
statefulset.apps/mongod   3/3     3m28s
```
```
 ./configure_repset_auth.sh <mongodb-password>
cd -
```
## Deploy Redis 
```
cd redis/scripts
./generate.sh
cd -
```
Wait for pods running status 
```
NAME           READY   STATUS    RESTARTS   AGE
pod/mongod-0   1/1     Running   0          90m
pod/mongod-1   1/1     Running   0          90m
pod/mongod-2   1/1     Running   0          89m
pod/redis-0    1/1     Running   0          3m16s

NAME                      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)     AGE
service/kubernetes        ClusterIP   10.96.0.1      <none>        443/TCP     7d1h
service/mongodb-service   ClusterIP   None   		 <none>        27017/TCP   90m
service/redis-service     ClusterIP   None           <none>        6379/TCP    3m16s

NAME                      READY   AGE
statefulset.apps/mongod   3/3     90m
statefulset.apps/redis    1/1     3m16s
```
## Deploy NATS 
```
cd nats/scripts
./generate.sh
cd -
```
Wait for pods running status 
```
NAME           READY   STATUS    RESTARTS   AGE
pod/mongod-0   1/1     Running   0          9m17s
pod/mongod-1   1/1     Running   0          9m7s
pod/mongod-2   1/1     Running   0          8m57s
pod/nats-0     1/1     Running   0          6m21s
pod/nats-1     1/1     Running   0          6m16s
pod/nats-2     1/1     Running   0          6m10s
pod/redis-0    1/1     Running   0          7m9s

NAME                      TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                      AGE
service/kubernetes        ClusterIP   10.96.0.1    <none>        443/TCP                      7d7h
service/mongodb-service   ClusterIP   None         <none>        27017/TCP                    9m18s
service/nats              ClusterIP   None         <none>        4222/TCP,6222/TCP,8222/TCP   6m21s
service/redis             ClusterIP   None         <none>        6377/TCP                     7m9s

NAME                      READY   AGE
statefulset.apps/mongod   3/3     9m17s
statefulset.apps/nats     3/3     6m21s
statefulset.apps/redis    1/1     7m9s
```
## Build docker sample node project with mongo, redis and nats connections
```
docker build -t node-k8s .
docker tag node-k8s mirnawaz/node-k8s:<tag> 
docker push mirnawaz/node-k8s
```
check connections

## Deploy node sample app 
```
kubectl apply -f deploy.yaml 
kubectl logs -f pod/node-app-*
```
Output below
```
2019-05-06T13:51:29: PM2 log: Launching in no daemon mode
2019-05-06T13:51:30: PM2 log: App [nodetestapp:0] starting in -fork mode-
2019-05-06T13:51:30: PM2 log: App [nodetestapp:0] online
nats connecting 
server started at : 8000
 
 Redis Connected 
 
 
 nats connected 
 
 
 Connected successfully to mongodb !!! 
 
Mongodb closing connection !!!
```

## Final status 
```
kubectl get all 
kubectl get persistentvolumes
```
```
NAME                            READY   STATUS    RESTARTS   AGE
pod/mongod-0                    1/1     Running   0          24m
pod/mongod-1                    1/1     Running   0          23m
pod/mongod-2                    1/1     Running   0          23m
pod/nats-0                      1/1     Running   0          21m
pod/nats-1                      1/1     Running   0          21m
pod/nats-2                      1/1     Running   0          20m
pod/node-app-7d9cd4469b-8zzw5   1/1     Running   0          11m
pod/redis-0                     1/1     Running   0          21m

NAME                      TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                      AGE
service/kubernetes        ClusterIP   10.96.0.1    <none>        443/TCP                      7d7h
service/mongodb-service   ClusterIP   None         <none>        27017/TCP                    24m
service/nats              ClusterIP   None         <none>        4222/TCP,6222/TCP,8222/TCP   21m
service/redis             ClusterIP   None         <none>        6377/TCP                     21m

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/node-app   1/1     1            1           11m

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/node-app-7d9cd4469b   1         1         1       11m

NAME                      READY   AGE
statefulset.apps/mongod   3/3     24m
statefulset.apps/nats     3/3     21m
statefulset.apps/redis    1/1     21m
NAME                  CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                               STORAGECLASS    REASON   AGE
mongo-data-volume-0   2Gi        RWO            Retain           Bound    default/mongodb-persistent-storage-claim-mongod-0   mongo-storage            24m
mongo-data-volume-1   2Gi        RWO            Retain           Bound    default/mongodb-persistent-storage-claim-mongod-1   mongo-storage            24m
mongo-data-volume-2   2Gi        RWO            Retain           Bound    default/mongodb-persistent-storage-claim-mongod-2   mongo-storage            24m
redis-volume-0        2Gi        RWO            Retain           Bound    default/redis-storage-redis-0                       redis-storage            21m
```

## Expose API to internet
```
kubectl expose deployment node-app --type=LoadBalancer --port=8000 --target-port=8000 --external-ip=192.168.56.112
```
## Check API 
```
curl http://192.168.56.112:8000/
```
Should return current time.

## Check mongo connections
```
kubectl exec -it mongod-0 -- /bin/bash
mongo --username main_admin --password abcd@1234 --authenticationDatabase admin --ssl --sslPEMKeyFile /data/ssl/server.pem  --sslCAFile /data/ssl/ca.pem --host mongod-0.mongodb-service
```