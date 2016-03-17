Pgpool-II from A to Z
=====================

![image](http://pgpool.net/mediawiki/skins/common/images/pgpool-ii-128px.png)

Features
========

Le proxy parfait :

- réutilise les connections existantes / mise en attente
- réplication + backup => load balancing

Attention :

- une seule version de postgresql sur tous les serveurs
- fonctions avec effets de bord dans SELECT
- lock pour insertion (sur un serveur)
- réplication *ou* requêtes parallèles
- licence résolument ouverte, mais mal formulée.

Dans les paquets Debian, avec module postgres.


Documentation
=============

[Tutorial](http://www.pgpool.net/docs/latest/tutorial-en.html)

[Home page](http://pgpool.net/mediawiki/index.php)

Interesting Docker Hub images
=============================

danharbin/pgpool2 : basée sur Ubuntu, installe pgpool2 et { pgpooladmin avec Apache }

thedutchselection/pgpool_ii : basée sur custom Debian, installe postgresql et recompile pgpool. Invente un peu trop la roue.

bettervoice/pgpool2-container : basée sur Ubuntu, pgpool2 plus python


Configuration
=============

Standard Pcpool
---------------

    /etc/pgpool.conf

listen_addresses
port

### Nodes

backend\_hostname0
backend\_port0
backend\_weight0 = 1

(\_ is un underscore)

Administrative PCP commands
---------------------------

    /etc/pcp.conf

user:md5password (pg_md5)
pcp_port

### Lancer le proxy

$ pgpool

(systemd ?)

$ pgpool stop

### Replication

replication\_mode = true
load\_balancing\_mode = true


Custom setup
============

    # docker run -q --name=db1 postgres:9.4
    # docker run -q --name=db2 postgres:9.4

    # apt-get install pgpool2

    # emacs /etc/pgpool2/pgpool.conf

    # - pgpool connection settings -
    listen_addresses = 'localhost'
    port             = 5432
    # - pgpool Communication Manager settings -
    pcp_port         = 5430
    # - Backend connection settings
    backend_hostname0 = '172.17.0.11'
    backend_port0     = 5432
    backend_weight0   = 1
    backend_hostname1 = '172.17.0.12'
    backend_port1     = 5432
    backend_wieght1   = 1
    #-----------------------
    # REPLICATION MODE
    #-----------------------
    replication_mode  = on
    #----------------------------
    # LOAD BALANCING MODE
    #----------------------------
    load_balance_mode = on

    # pgpool stop # Reload middleware
    # pgpool

    # systemctl stop postgresql # Ensure my own local postgresql does not interfere

    $ psql -U postgres -c "CREATE DATABASE test WITH OWNER = postgres" -e postgres
    CREATE DATABASE test WITH OWNER = postgres
    CREATE DATABASE

    # docker exec -ti db1 psql -U postgres -e postgres -c "\l"
                                     List of databases                                            
       Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges              
    -----------+----------+----------+------------+------------+-----------------------           
     postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                                  
     template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +           
               |          |          |            |            | postgres=CTc/postgres            
     template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +           
               |          |          |            |            | postgres=CTc/postgres            
     test      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                                  
    (4 rows)

    # docker exec -ti db2 psql -U postgres -e postgres -c "\l"
    [idem]

Beware of IP addresses changing upon container start.

