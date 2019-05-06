'use strict';

var MongoClient = require('mongodb').MongoClient;
var http = require('http');
var redis = require("redis");
var fs = require('fs');
var path = require('path');
var nats = require('nats');

var redisOptions = {
	host: 'redis-0.redis.default.svc.cluster.local',
	port: 6377,
	password: 'abcd@1234'
};
var client = redis.createClient(redisOptions);

var ca = [fs.readFileSync(path.join(__dirname, '/mongo/cert/ca.pem'))];
var cert = fs.readFileSync(path.join(__dirname, '/mongo/cert/server.pem'));
var key = fs.readFileSync(path.join(__dirname, '/mongo/cert/server.pem'));

var mongoConfig = {
    connection: {
      uri: 'mongodb://mongod-0.mongodb-service,mongod-1.mongodb-service,mongod-2.mongodb-service?replicaSet=MainRepSet&ssl=true',
      db: 'admin'
    },
    options: {
      useNewUrlParser: true,
      numberOfRetries: 5,
      connectTimeoutMS: 500,
      auto_reconnect: true,
      poolSize: 40,
      auth: { user: 'main_admin', password: 'abcd@1234' },
      authMechanism: 'SCRAM-SHA-1',
      authSource: 'admin',
      sslCA:ca,
      sslKey:key,
      sslCert:cert
    }
  };

client.on("error", function (err) {
    console.log("Redis Connect Error " + err);
});

client.on("connect", function () {
    console.log(" \n Redis Connected \n ");
});

client.on("reconnecting", function () {
    console.log("Redis reconnecting ");
});
 
// Use connect method to connect to the server
MongoClient.connect(mongoConfig.connection.uri, mongoConfig.options, function(err, client) {
  if(err || !client){
		console.log("Not connected to server", err)
	}
  else{
    console.log(" \n Connected successfully to mongodb !!! \n ");
    const db = client.db(mongoConfig.connection.db);
    console.log("Mongodb closing connection !!!");
    client.close();
  }
  
});

// Use a client certificate if the server requires
var tlsOptions = {
  key: fs.readFileSync(path.join(__dirname, '/nats/cert/nats-key.pem')),
  cert: fs.readFileSync(path.join(__dirname, '/nats/cert/nats.pem')),
  ca: [ fs.readFileSync(path.join(__dirname, '/nats/cert/ca.pem')) ]
};

var nc = nats.connect({url:"nats://nats:4222", user:'nats_client_user', pass:'nats_client_pwd', tls: tlsOptions});

console.log('nats connecting ');
//console.log(nc);

nc.on('error', function(err) {
    console.log('NATS connect error: ', err);
});
 
nc.on('connect', function(nc) {
    console.log(' \n nats connected \n ');
});
 
nc.on('disconnect', function() {
    console.log('NATS disconnect');
});
 
nc.on('reconnecting', function() {
    console.log('NATS reconnecting');
});
 
nc.on('reconnect', function(nc) {
    console.log('NATS sreconnect');
});
 
nc.on('close', function() {
    console.log('NATS close');
});

var server = http.createServer(function(req, res){
    res.end(new Date().toISOString());
});

server.listen(8000);

console.log('server started at : 8000');

// kubectl expose deployment node-app --type=LoadBalancer --port=8000 --target-port=8000 --external-ip=192.168.56.112
