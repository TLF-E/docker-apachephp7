FROM php:7-apache
MAINTAINER Michael Garrez <michael.garrez@gmail.com>

ENV REFRESHED_AT 2015-09-23

COPY config/php.ini /usr/local/etc/php/
COPY bash /var

RUN apt-get update && apt-get install -y libmcrypt-dev zlib1g-dev vim cron
RUN docker-php-ext-install mysqli pdo pdo_mysql mbstring mcrypt iconv zip
RUN a2enmod rewrite
RUN usermod -u 1000 www-data
RUN mkdir -p /var/www/html
RUN apt-get update
RUN yes | apt-get upgrade
ENV TERM xterm
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

EXPOSE 80
CMD bash -C '/var/stack_start.sh'
