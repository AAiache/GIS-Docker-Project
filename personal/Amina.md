# Amina's report

## Accomplished tasks

I worked with Alban and Valentin during three months to make this cloud resilient GIS on a Docker Swarm cluster. It was a real team-work. During the first week, we asked for Raspberry Pi machines and we got them. Then, we set them up at Valentin's house (in order to have them set up during the whole project's period), and we configured them.  
We also worked together to propose a conception to respond to the need, so as we could divide what should be done into small tasks. In general, I did the following tasks:

* At the begining I created a GitHub repository for the project, I wrote a small introduction to explain what it is going to be.
* During the realisation period, I first tried to look for existing Docker images that we need for the ARM architectue, and how to use them. We didn't find light images to use, and for some tools we didn't fing them at all. So, we decided to make our own Docker images (since we know how to do it).
* I made a Docker image for Pgpool-II, which is a middleware between PostgreSQL servers and database clients. The idea is that we run Pgpool-II in a Docker container, and it should be able to manage replicaton and load balancing for two or more PostgreSQL servers running on Docker containers too. The containers are not running on the same machine.  
I tested my image by running two PostgreSQL containers on different machines, and a Pgpool-II container in another machine. I tried to create a database on a server and enssured that it replicates it. Pgpool-II has a master server and slave ones, I tested that if we kill the container that runs the master server, the service is maintained.
* One of the most difficult tasks was to run Keepalived in a Docker container, and I did it.  
We have three Geoservers running in Docker containers, managed by HAProxy which runs in Docker conatiners too. The problem is if we want to add a Geoserver, we should stop the service. As a result, our system would not be a `high available` one. The solution is to add a virtual IP between HAProxy containers, define a master one, and if it crashes, the service is still available. That is why we used Keepalived.
I created a Docker image to run Keepalived as a master, and one to run it as a slave. I tested it by accessing Geoserver via the virtual IP.  
I also created two images, one with HAProxy and Keepalived in the same container, and the other with Pgpool and Keepalived, and I tested them, but we finally changed the architecture and we didn't use them.  
* Once we finished creating and testing small bricks, the three of us worked to make it work all together. We created a docker-compose file and we run it. Of course, it didn't work at the first time, we did a lot of tests to debug it, and finaly we succeeded.  
I thought that making a Docker Swarm cluster was very difficult, because it was hard to understand in class, but we finally succeded to make a cluster using Docker Swarm and Consul without real difficulties.  
* Finally, I wrote the user guide, to allow a user starting from zero to have a detailed manual to run the application. I also did the physical and logical architecture diagrams.

### Architecture limitations

* The architecture we proposed has a Single Point Of Failure (SPOF), which is on the master machine which runs Swarm Manager and Consul. So, if this machine crashes, the service is not available anymore.

### To improve it, we could:

* Run Consul on a docker container, so it would not have a SPOF anymore. Given that we have a virtaul IP provided by Keepalived which manages HAProxy and Pgpool-II containers, we should do the same for Consul!  
* However, we will still have a SPOF, it is Swarm's. If the machine that contains the Swarm manager has a breakdonk, the service is no longer available.  

### Blocking points

* I think that I don't have any blocking point. I understand all of what we did, and I think that I know how to make it better.

### Conclusion

I beleive that it was a very interesting project, I really learned a lot of things:
* I improved my Docker skills: make dockerfiles, use Docker Compose and Docker Swarm to run multi-container applications.
* I imporoved my knowledge in linux, because we had to make a lot of shell scripts, so it was a real opportunity for me to practise it.
* I also learned a lot about network architecture, how to manage IP addresses and ports.
* Lastly, this project hepled me understand more the architecture of a Docker based application. 
