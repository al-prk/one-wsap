FROM httpd:2.4

MAINTAINER Alexandr Prokopenko <crsde.pk@gmail.com>

ARG ver=*

ENV descriptors_config /usr/local/apache2/conf/descriptors.conf
ENV descriptors /descriptors
ENV public_dir /pub

VOLUME $descriptors

# Установка пакетов 1С
COPY packages/1c-enterprise*_${ver}_amd64.deb /packages/
RUN sh -c 'dpkg -i /packages/*.deb'

ADD configure.sh /config/
RUN touch $descriptors_config && echo "Include conf/descriptors.conf" >> /usr/local/apache2/conf/httpd.conf

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && rm /packages/*.deb
RUN ln -s /usr/local/apache2/bin/httpd /usr/bin/apache2

CMD /bin/bash /config/configure.sh && httpd-foreground
