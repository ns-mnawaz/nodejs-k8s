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

## Deploy sample node project with mongo, redis and nats connections
```
docker build -t node-k8s .
docker tag node-k8s mirnawaz/node-k8s:<tag> 
docker push mirnawaz/node-k8s
```

check connections
```
kubectl logs -f pod/node-app-7d9cd4469b-8zzw5
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