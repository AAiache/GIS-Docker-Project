FROM armhf/debian:jessie

MAINTAINER Amina Aiache <https://github.com/AAiache>

RUN apt-get update

RUN apt-get install --no-install-recommends pgpool2 -y

COPY pgpool.conf /etc/pgpool2/pgpool.conf

ENTRYPOINT ["/bin/sh", "-c"]

CMD ["pgpool && while true; do sleep 1000; done"]
