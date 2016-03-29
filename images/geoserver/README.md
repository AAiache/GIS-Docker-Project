# Image arm-geoserver

## Get the image

Download the image (or build again) :

    docker pull vsasyan/geoserver:1.0.0

Run the container (needs 2-3 minutes to start) :

    docker run -d -p 8080:8080 vsasyan/geoserver:1.0.0

You can go to : http://server:8080/geoserver

In our installation, we have to share the `geoserver` folder :

    docker run -d -p 8080:8080 --name=geoserver -v /mnt/geoserver:/var/lib/tomcat7/webapps/geoserver vsasyan/geoserver:1.0.0

We assume that `/mnt/geoserver` is the shared folder.

## Used pages - Notes

### Installation of Geoserver

* http://blog.sortedset.com/gis-tiny-box-geoserver-raspberry-pi/
* https://www.digitalocean.com/community/tutorials/how-to-manually-install-oracle-java-on-a-debian-or-ubuntu-vps

### Synchronisation of Geoserver

* http://georezo.net/forum/viewtopic.php?id=62448

Files / folders to synchronize :
* file `geoserver/data/services.xml` : metadata of the server
* file `geoserver/data/catalog.xml` : connexion parameters to connect datastore (Postgis), style sheet repertory
* folder `geoserver/data/featureTypes` : répertoire dont les sous répertoires assignent un nom à chaque layer et contiennent un fichier `info.xml` qui contient les métadonnées du layer ainsi que le nom du style associé à chaque layer
* folder `geoserver/data/styles` : répertoire qui contient les feuilles de style "SLD" répertoriées dans les fichiers mentionnés précédemment

All the folder `goserver/data` ?
