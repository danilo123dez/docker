FROM ubuntu:18.04

# Maintainer
MAINTAINER Danilo Franceschi "danfranceschi231@gmail.com"

ENV NGINX_VERSION 1.9.3-1~jessie

RUN apt-get update
RUN apt-get install -y locales locales-all sudo

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

ADD vhost /vhost

ADD configurations.sh /
ADD functions.sh /

RUN chmod +x /functions.sh
RUN chmod +x /configurations.sh

RUN cd / && ./configurations.sh -d -iall

WORKDIR /var/www/html

EXPOSE 80 443
CMD service nginx start && service php7.4-fpm start && /bin/bash

#