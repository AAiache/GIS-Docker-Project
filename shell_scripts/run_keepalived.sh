#!/bin/sh

ssh pi@piensg011 "docker run -d --net=host --privileged=true --cap-add=NET_ADMIN aaiache/arm-keepalived-master"
ssh pi@piensg012 "docker run -d --net=host --privileged=true --cap-add=NET_ADMIN aaiache/arm-keepalived-slave"
ssh pi@piensg020 "docker run -d --net=host --privileged=true --cap-add=NET_ADMIN aaiache/arm-keepalived-slave"
ssh pi@piensg021 "docker run -d --net=host --privileged=true --cap-add=NET_ADMIN aaiache/arm-keepalived-slave"