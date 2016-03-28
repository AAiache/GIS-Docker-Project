# NFS Server


## Server:

Installation:

    sudo apt-get update && sudo apt-get install nfs-kernel-server -y

To share the folder `/var/geoserver`, add in `/etc/exports`:

    /var/geoserver *(rw,all_squash,no_subtree_check,anonuid=1000,anongid=1000,sync)

`rpcbind` has to autostart:

    sudo update-rc.d rpcbind enable
    
Restart all the needed services:

    sudo service rpcbind restart
    sudo service nfs-kernel-server restart


## Client:

Installation:

    sudo apt-get update && sudo apt-get install nfs-common -y

Create the mount point:

    sudo mkdir /mnt/geoserver

Edit `/etc/fstab` to do the mount :

    piensg001:/var/geoserver /mnt/geoserver nfs rw,nolock

Restart the mount soft:

    sudo mount -a


## Links

* http://www.pobot.org/Partage-NFS-d-un-repertoire-sur-Raspberry-Pi.html
