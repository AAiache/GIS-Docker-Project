# HAproxy in a container
#
# VERSION               1.0.0
#
############################################

FROM armhf/debian:jessie
MAINTAINER Sasyan Valentin <https://github.com/VSasyan>

# Installation of haproxy
RUN echo deb http://httpredir.debian.org/debian jessie-backports main | \
    sed 's/\(.*\)-sloppy \(.*\)/&@\1 \2/' | tr @ '\n' | \
    tee /etc/apt/sources.list.d/backports.list
RUN apt-get update && \
    apt-get install wget -y && \
    apt-get install haproxy -y -t jessie-backports && \
    apt-get autoremove && apt-get clean

# HAproxy init script
RUN wget http://deb.best-hosting.cz/_scripts_/haproxy/init.d/haproxy -O /etc/init.d/haproxy && \
    chmod +x /etc/init.d/haproxy

# Start on reboot
RUN update-rc.d haproxy defaults

# Create haproxy user
RUN adduser --group --system --no-create-home --disabled-password --disabled-login haproxy

# Change HAproxy configuration
COPY haproxy.cfg /etc/haproxy/haproxy.cfg

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["haproxy -f /etc/haproxy/haproxy.cfg && while true; do sleep 1000; done"]
