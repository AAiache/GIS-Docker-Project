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

##3. Install Consul and Docker swarm

Consul is service discovery system, we use it to store all available nodes in our Docker Swarm cluster so that the Swarm Manager could have access to them.  
Click on the [link](../consul/config.md) to install and configure consul and Dowker Swarm Cluster.  

##4. Configure machines
### 4.1 Synchronize Geoservers

In order to synchronise two or more Geoservers, we use a [NFS](NFS_Server.md) server.
All Raspberry Pis on which we run a Geoserver has a directory `/mnt/geoserver` which we share as a volume with the container to run the server.

###4.2 Generate ssh keys

We anticipated shell scripts to automate run all Docker Swarm and Keepalived containers from one machine. So, if you want it to be easy, generate an ssh key of a machine, the machine which is going to be the Swarm Manager and on which we run Consul for example, and add it to the authorized keys file in of all the other machines.

##5. Run Keepalived containers

To do so, customise the file `shell_scripts/run_keepalived.sh' so as to replace hostnames by yours and run the shell script:

    chmod +x run_keepalived.sh
    ./run_keepalived.sh

##6. Run Docker Swarm containers

To do so, customise the file `shell_scripts/run_swarm.sh' so as to replace hostnames and IP addresses by yours and run the shell script:

    chmod +x run_swarm.sh
    ./run_swarm.sh

##7. Run Docker Compose

We created a network named ava (Amina, Valentin and Alban) to run docker-compose:

    docker network create ava

You can create a network with your favorite name or run it on a default network, but your have to modify the docker-compose.yml file.
Go to the folder compose, which contains the `docker-compose.yml` file and run:

    docker-compose up

##8. Have fun!

Open your favorite browser and go to `http://192.168.1.240' (the virtual IP of Keepalived)

