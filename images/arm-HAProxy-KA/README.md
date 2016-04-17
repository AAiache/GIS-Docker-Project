#Keepalived and HAProxy in a docker container

run command :

    docker run -d -p 80:80 --net=host --privileged=true --cap-add=NET_ADMIN arm-ha-ka

go to : 

    192.168.1.240:8080/geoserver
