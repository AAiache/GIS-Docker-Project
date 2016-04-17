# Consul

## Installation of consul

Download :
    
    wget https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_arm.zip
    wget https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_web_ui.zip

Extract it. Then copy `consul` to /usr/local/bin/ and `consul-ui` in `/home/pi/consul/ui`.

Run consul interface :

    consul agent -dev -ui -ui-dir /home/pi/consul/ui -bind 192.168.1.27 -client 192.168.1.27

## Configuration

### Other devices

Run: `sudo vim /etc/default/docker` and add :

    DOCKER_OPTS="--storage-driver=overlay -D -H tcp://0.0.0.0:2375 --cluster-store=consul://192.168.1.27:8500 --cluster-advertise=eth0:2375"

### Main device

    docker run -d --restart=always -p 4060:4161 hypriot/rpi-swarm manage -H 0.0.0.0:4161 consul://192.168.1.27:8500/docker/nodes/

### Installation of Docker Compose

