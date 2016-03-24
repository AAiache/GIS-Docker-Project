## Used pages

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
