#Keepalived in a Docker container

#version 1.0.0

################################

FROM armhf/debian:jessie

MAINTAINER AminaAiache <https://github.com/AAiache>

#Install Keepalived

RUN apt-get update

RUN apt-get install --no-install-recommends keepalived -y

COPY keepalived.conf /etc/keepalived/keepalived.conf

ENTRYPOINT ["/bin/sh", "-c"]

CMD ["/usr/sbin/keepalived && while true; do sleep 1000; done"]
