# ARM HAproxy image

## Run the container

    docker run -d -p 80:80 -p 88:8080 vsasyan/arm-haproxy:1.0.0

## Administration

You can see the statistics here :

    http://piensg001:88/haproxy?stats

## The site

You can see the site here:

    http://piensg001/geoserver/web
