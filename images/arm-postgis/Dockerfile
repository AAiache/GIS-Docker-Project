# PostGIS in a container
#
# VERSION               0.0.1
#
############################################

FROM armhf/debian:jessie
MAINTAINER Sasyan Valentin <https://github.com/VSasyan>

# Installation of postgresql and postGIS 
RUN apt-get update && \
    apt-get -y --no-install-recommands install postgresql-9.4-postgis-2.1 && \
    apt-get autoremove && apt-get clean

# Correct debian packaging
RUN mkdir /var/run/postgresql/9.4/main/pg_stat_tmp
RUN chown postgres:postgres /var/run/postgresql/9.4/main/pg_stat_tmp
RUN sed -i "s|stats_temp_directory = '/var/run/postgresql/9.4-main.pg_stat_tmp'|stats_temp_directory = '/var/run/postgresql/9.4/main/pg_stat_tmp'|" /etc/postgresql/9.4/main/postgresql.conf

# Lauch postgres server
USER postgres
WORKDIR /usr/lib/postgresql/9.4/
ENTRYPOINT ["bin/postgres", "--config-file=/etc/postgresql/9.4/main/postgresql.conf"]
