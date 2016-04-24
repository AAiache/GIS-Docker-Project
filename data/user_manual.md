#User Manual

##1. Configure Raspberry Pi machines

In order to implement our Docker based GIS, you should have at least three machines supporting Docker. If you want to use Raspberry Pi machines we invite you to use [hypriot guide](http://blog.hypriot.com/getting-started-with-docker-on-your-arm-device/) to get your machines ready.  

##2. Pull Docker images

We made all docker images needed to run our multi-container application in our Docker hubs, in order to get them run this on all machines:

    docker pull aaiache/arm-keepalived-master
    docker pull aaiache/arm-keepalived-slave
    docker pull aaiache/arm-pgpool
    docker pull vsasyan/geoserver
    docker pull vsasyan/arm-haproxy
    docker pull alkra/arm-postgis:5.6  


You need a Master Keepalived running in one machine and Slave Keepalived rinning on the others.

##3. Install Consul

Consul is service discovery system, we use it to store all available nodes in our Docker Swarm cluster so that the Swarm Manager could have access to them.  
Click on the [link](../consul/config.md) to install and configure consul.  

##4. Configure machines
###4.1 Install Docker Swarm
