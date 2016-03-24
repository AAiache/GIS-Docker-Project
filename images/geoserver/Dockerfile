# Geoserver in a container
#
# VERSION               1.0.0
#
############################################

FROM armhf/debian:jessie
MAINTAINER Sasyan Valentin <https://github.com/VSasyan>

# Installation of java 1.8 jdk 
RUN rm -rf /usr/lib/jvm

COPY jdk1.8.0_73 /usr/lib/jvm/jdk1.8.0_73

RUN update-alternatives --install /usr/bin/java  java  /usr/lib/jvm/jdk1.8.0_73/bin/java  1100
RUN update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.8.0_73/bin/javac 1100

# Installation of tomcat7
RUN apt-get update && \
    apt-get -y install tomcat7 && \
    apt-get autoremove && apt-get clean

COPY tomcat7 /etc/default/tomcat7
RUN touch /var/log/tomcat7/catalina.out
RUN mkdir -p /usr/share/tomcat7/common/classes
RUN mkdir -p /usr/share/tomcat7/server/classes
RUN mkdir -p /usr/share/tomcat7/shared/classes
RUN chown -R tomcat7:tomcat7 /usr/share/tomcat7
RUN chown -R tomcat7:tomcat7 /var/log/tomcat7

# Copy geoserver
COPY geoserver.war /var/lib/tomcat7/webapps/geoserver.war

# Modified sleep parameter
COPY service_tomcat7 /etc/init.d/tomcat7
RUN chmod +x /etc/init.d/tomcat7

# Modify tomcat configuration
COPY server.xml /usr/share/tomcat7/conf/server.xml

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["/etc/init.d/tomcat7 start && while true; do sleep 1000; done"]

