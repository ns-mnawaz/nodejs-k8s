#!/bin/bash
set -e

echo "Decrypt spiped data"
spiped -d -s '[0.0.0.0]:6378' -t '[0.0.0.0]:6379' -k /etc/spiped/redis.key  

echo "Encrypt spiped data"
spiped -e -s '[0.0.0.0]:6377' -t '[0.0.0.0]:6378' -k /etc/spiped/redis.key  

echo "Run Redis"
redis-server --requirepass $REDIS_PASSWORD
