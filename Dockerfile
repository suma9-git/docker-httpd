ARG apache_version=2.4.65
FROM httpd:$apache_version

ARG apache_version
#ENV http_proxy="http://xxxx:8080"
#To set timezone
ENV TZ=America/Los_Angeles
RUN cp -p /etc/localtime /etc/localtime_original && \
    ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

LABEL Product="Apache HTTP $apache_version" \
      SHIB.Version="3.0.4" \
      
# http uses 4041 and https uses 4042 ports 
 
RUN apt-get update -y \
    && apt-get install -y net-tools procps iputils-ping wget vim \
    && apt-get -qq -y --no-install-recommends install libapache2-mod-shib \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g 3187 webmgr && useradd -u 3187 -g webmgr webmgr && mkdir /home/webmgr && chown webmgr:webmgr /home/webmgr 

#COPY create_links.sh /home/webmgr/

#RUN chmod 755 /home/webmgr/create_links.sh && /home/webmgr/create_links.sh

#COPY httpd.conf /usr/local/apache2/conf/
#COPY httpd-default.conf httpd-mpm.conf httpd-ssl.conf /usr/local/apache2/conf/extra/
#COPY attribute-map.xml protocols.xml /etc/shibboleth/
#COPY apache2-foreground /usr/local/apache2/bin/

RUN cd /usr/local/apache2 && chown -R webmgr:webmgr *

#CMD ["httpd-foreground"]
CMD ["/usr/local/apache2/bin/apache2-foreground"]

