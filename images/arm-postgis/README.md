A postgresql image on ARM for Docker
====================================

Contents of the repository:
--------------------------

- Dockerfile
- pg_hba.conf: postgresql server authentification configuration file
  (who is authorized to connect to what base from which server?)
- exec_postgres: script to start the server AND initialize a database
- booktown.sql: sample data (from Postgresql website)


The Dockerfile
--------------

Configuration steps are put at the end of the file to use the cache,
it may not be very clear.

### Installation

Add postgresql-9.4-pgpool plugin if that doesn't work.

### The Debian packaging "bug"

Postgresql uses a statistics collector in `~` (`/var/lib/postgresql/`),
started as user *postgres*, but Postgresql is located in
`/var/lib/postgresql/<version>/<cluster>/` (Debian "cluster"
installation) and parent folder are owned by *root*. At startup, the
statistics collector send ~100 warnings, filling the system log.

Correction involves creating a directory for statistics and editing
Postgresql's configuration file to the new directory.


### Running the server

The entrypoint is custom, and `CMD` is the command to run a bare
Postgresql server. To debug, one can use --entrypoint="bash -c" (from
memory).



The entrypoint
--------------

This is a bash script, whose main component is the infinite loop at
bottom.

`trap` is used to capture signals and redirect them to custom
functions. (i.e., when container is interrupted, database exits
properly).

Between server start and the first request to create the database, I
put a grace delay of 30 seconds.




Account configuration (pg_hba.conf)
-----------------------------------

At bottom, we allow administrator postgres to connect to all databases
from the host machine. User pgpool was intended as a read-only user,
and user updater (with stronger credentials) is the read-write user.

For developpement purpose, the user updater will be used.




Testing database
----------------

After container creation, run it from the host machine with :

    psql -U postgres -h 172.17.0.? -d geoserver < pg_hba.conf

