FROM debian:stretch

MAINTAINER Ghislain GAUCHER <ghislain@lancaster-solutions.com>

RUN apt-get -y update
RUN apt-get -y upgrade

# Packages
RUN apt-get install -y gnupg curl acl vim htop wget ca-certificates apt-transport-https libpng-dev

# SSH

COPY ./config/ssh/config /root/.ssh/

# Git

RUN apt-get install -y git

# Node and NPM
RUN curl -sL https://deb.nodesource.com/setup_12.x > setup_node && chmod +x setup_node && ./setup_node
RUN apt-get install -y nodejs
RUN npm install -g npm-cli-login

# PHP

RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
RUN echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list
RUN apt-get -y update
RUN apt-get install -y php7.1 php7.1-xml php7.1-soap php7.1-curl php7.1-imap php7.1-intl php7.1-mysql
RUN apt-get install -y php7.1-mbstring php7.1-iconv php7.1-zip php7.1-gd php7.1-bcmath php7.1-redis
RUN update-alternatives --set php /usr/bin/php7.1

# PECL
RUN apt-get install -y php-pear php7.1-dev
RUN pecl install timecop-beta

# Apache

RUN apt-get install -y apache2
RUN a2dismod mpm_event php*
RUN a2enmod mpm_prefork php7.1 rewrite ssl macro headers proxy proxy_http proxy_wstunnel

RUN mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.dist
RUN rm /etc/apache2/conf-enabled/* /etc/apache2/sites-enabled/*
COPY ./config/apache2.conf /etc/apache2/apache2.conf
COPY ./apache2-foreground /usr/local/bin/

# xDebug

RUN pecl install xdebug-2.9.8
RUN echo "zend_extension=xdebug.so" >> /etc/php/7.1/apache2/conf.d/xdebug.ini
RUN echo "zend_extension=xdebug.so" >> /etc/php/7.1/cli/conf.d/xdebug.ini

# PHP ini

RUN echo "date.timezone=Europe/Paris" > /etc/php/7.1/cli/conf.d/timezone.ini
RUN echo "date.timezone=Europe/Paris" > /etc/php/7.1/apache2/conf.d/timezone.ini
RUN echo "memory_limit=2048M" > /etc/php/7.1/cli/conf.d/memory-limit.ini
RUN echo "memory_limit=2048M" > /etc/php/7.1/apache2/conf.d/memory-limit.ini
RUN echo "extension=timecop.so" > /etc/php/7.1/cli/conf.d/20-timecop.ini
RUN echo "extension=timecop.so" > /etc/php/7.1/apache2/conf.d/20-timecop.ini

# Composer

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Bashrc

RUN echo "alias ls='ls --color=auto'" >> .bashrc
RUN echo "alias ll='ls -halF'" >> .bashrc

EXPOSE 80
WORKDIR /var/www
ENTRYPOINT ["apache2-foreground"]
