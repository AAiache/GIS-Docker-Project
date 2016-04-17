#Keepalived and pgpool in a Docker container

#version 1.0.0

################################

FROM armhf/debian:jessie

MAINTAINER AminaAiache <https://github.com/AAiache>

#Install Keepalived

RUN apt-get update && apt-get install --no-install-recommends keepalived -y && apt-get install --no-install-recommends pgpool2 -y

COPY keepalived.conf /etc/keepalived/keepalived.conf

COPY pgpool.conf /etc/pgpool2/pgpool.conf

#Entrypoint

ENTRYPOINT ["/bin/sh", "-c"]

CMD ["/usr/sbin/keepalived && pgpool && while true; do sleep 1000; done"]
