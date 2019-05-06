#
# Redis Spiped Dockerfile
#
#

# Pull base image.
FROM ubuntu:16.04

#ENV
ENV REDIS_PASSWORD=abcd@1234

# Install Redis.
RUN  apt-get update \
  && apt-get install redis-server -y

# Install Spiped.
RUN  apt-get update \
  && apt-get install spiped -y

#Copy entry script
COPY ./docker-entrypoint.sh /

# Create Key
RUN mkdir /etc/spiped
RUN dd if=/dev/urandom of=/etc/spiped/redis.key bs=32 count=1
RUN chmod 600 /etc/spiped/redis.key

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

RUN ["chmod", "+x", "/docker-entrypoint.sh"]

CMD ["/docker-entrypoint.sh"]

# Expose ports.
EXPOSE 6377