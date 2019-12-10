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
RUN curl -sL https://deb.nodesource.com/setup_8.x > setup_node && chmod +x setup_node && ./setup_node
RUN apt-get install -y nodejs
RUN npm install -g npm-cli-login

# PHP

RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
RUN echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list
RUN apt-get -y update
RUN apt-get install -y php7.2 php7.2-xml php7.2-soap php7.2-curl php7.2-imap php7.2-intl php7.2-mysql php7.2-xdebug
RUN apt-get install -y php7.2-mbstring php7.2-iconv php7.2-zip php7.2-gd php7.2-bcmath php7.2-dev php7.2-redis
RUN update-alternatives --set php /usr/bin/php7.2

# PECL
RUN apt-get install -y php-pear php-dev
RUN pecl install timecop-beta

# Apache

RUN apt-get install -y apache2
RUN a2dismod mpm_event php*
RUN a2enmod mpm_prefork php7.2 rewrite ssl macro headers proxy proxy_http proxy_wstunnel

RUN mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.dist
RUN rm /etc/apache2/conf-enabled/* /etc/apache2/sites-enabled/*
COPY ./config/apache2.conf /etc/apache2/apache2.conf
COPY ./apache2-foreground /usr/local/bin/

# PHP ini

RUN echo "date.timezone=Europe/Paris" > /etc/php/7.2/cli/conf.d/timezone.ini
RUN echo "date.timezone=Europe/Paris" > /etc/php/7.2/apache2/conf.d/timezone.ini
RUN echo "memory_limit=2048M" > /etc/php/7.2/cli/conf.d/memory-limit.ini
RUN echo "memory_limit=2048M" > /etc/php/7.2/apache2/conf.d/memory-limit.ini
RUN echo "extension=timecop.so" > /etc/php/7.2/cli/conf.d/20-timecop.ini
RUN echo "extension=timecop.so" > /etc/php/7.2/apache2/conf.d/20-timecop.ini

# Composer

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN composer global require hirak/prestissimo

# Bashrc

RUN echo "alias ls='ls --color=auto'" >> .bashrc
RUN echo "alias ll='ls -halF'" >> .bashrc

EXPOSE 80
WORKDIR /var/www
ENTRYPOINT ["apache2-foreground"]
