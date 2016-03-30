#A Pgpool II image for ARM on Docker

##Contents on the repository

- Dockerfile
- pgpool.conf: pgpool II configuration file, customize Pgpool Connection settings and Communication Manager settings

##Running the server

The `CMD` instruction is used to provide default configuration from executing container: run the pgpool middleware that works between PostgreSQL servers and PostgreSQL database client.

##The entrypoint

A sh script to run an infinite loop.

##Testing Pgpool

From a PostgreSQL Client run :

    psql -U postgres -h 172.17.0.? -d geoserver


