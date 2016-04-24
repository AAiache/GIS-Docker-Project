#!/bin/sh

ssh pi@piensg011 "docker run -d --restart=always hypriot/rpi-swarm join --advertise=192.168.1.29:2375 consul://192.168.1.29:8500"
ssh pi@piensg012 "docker run -d --restart=always hypriot/rpi-swarm join --advertise=192.168.1.31:2375 consul://192.168.1.29:8500"
ssh pi@piensg020 "docker run -d --restart=always hypriot/rpi-swarm join --advertise=192.168.1.37:2375 consul://192.168.1.29:8500"
ssh pi@piensg021 "docker run -d --restart=always hypriot/rpi-swarm join --advertise=192.168.1.38:2375 consul://192.168.1.29:8500"