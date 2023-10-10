FROM php:8.1.23-apache

LABEL "Author"="Ghislain GAUCHER <ghislain@lancaster-solutions.com>"
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# SSH
COPY ./config/ssh/config /root/.ssh/
RUN apt-get update -y
RUN apt-get upgrade -y
# Packages
RUN apt-get install -y --no-install-recommends \
    acl \
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    ssh-client \
    gnupg \
    htop \
    libpng-dev \
    make \
    unzip \
    vim \
    wget \
    redis-tools \
    imagemagick \
    ghostscript \
    libxml2-dev \
    libonig-dev \
    libcurl4-gnutls-dev \
    librabbitmq-dev \
    libicu-dev \
    libzip-dev \
    procps \
    libmagickwand-dev \
    libmagickcore-dev \
    mongodb-org

# PHP
RUN docker-php-ext-configure intl \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install -j$(nproc) \
      pdo_mysql \
      opcache \
      intl \
      zip \
      bcmath \
      sockets \
      pcntl \
      soap \
      mbstring \
      soap \
      gd \
      xml \
      curl \
    && pecl install -o -f \
      amqp \
      redis \
      uopz \
      imagick \
      xdebug \
      mongodb \
    && docker-php-ext-enable \
      amqp \
      redis \
      uopz \
      imagick \
      xdebug \
      mongodb \
    && rm -rf /tmp/pear

RUN composer global require --dev slope-it/clock-mock
# Node and NPM
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y npm nodejs
RUN apt-get update -y
RUN npm install -g npm-cli-login
# Amqproxy
RUN curl -s https://packagecloud.io/install/repositories/cloudamqp/amqproxy/script.deb.sh | bash
# Apache
RUN a2enmod rewrite ssl macro headers proxy proxy_http proxy_wstunnel
RUN mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.dist
RUN rm /etc/apache2/conf-enabled/* /etc/apache2/sites-enabled/*
# PHP ini
RUN touch /usr/local/etc/php/php.ini
RUN printf '[PHP]\ndate.timezone = "UTC"\n' > /usr/local/etc/php/conf.d/tzone.ini
RUN echo "memory_limit=2048M" > /usr/local/etc/php/conf.d/memory-limit.ini
RUN echo '[xdebug]' >> /usr/local/etc/php/conf.d/xdebug.ini \
 && echo 'xdebug.client_host=${LOCAL_IP}' >> /usr/local/etc/php/conf.d/xdebug.ini \
 && echo 'xdebug.client_port=${XDEBUG_PORT}' >> /usr/local/etc/php/conf.d/xdebug.ini \
 && echo 'xdebug.idekey=docker' >> /usr/local/etc/php/conf.d/xdebug.ini \
 && echo 'xdebug.start_with_request=yes' >> /usr/local/etc/php/conf.d/xdebug.ini \
 && echo 'xdebug.mode=${XDEBUG_MODE}' >> /usr/local/etc/php/conf.d/xdebug.ini \
 && echo 'xdebug.discover_client_host=false' >> /usr/local/etc/php/conf.d/xdebug.ini \
 && echo 'xdebug.output_dir=/tmp' >> /usr/local/etc/php/conf.d/xdebug.ini \
 && echo 'xdebug.log=/tmp/xdebug.log' >> /usr/local/etc/php/conf.d/xdebug.ini \
 && echo 'xdebug.level=0' >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini
# Bashrc
RUN echo "alias ls='ls --color=auto'" >> .bashrc
RUN echo "alias ll='ls -halF'" >> .bashrc
#cleanup
RUN apt clean -y
RUN rm -rf /var/lib/apt/lists/*
# APACHE
COPY ./config/apache2.conf /etc/apache2/apache2.conf
#GIT
COPY ./config/gitconfig /root/.gitconfig

EXPOSE 80
WORKDIR /var/www

ARG XDEBUG_PORT=9003
ARG XDEBUG_MODE="develop,debug"
ENV XDEBUG_PORT=$XDEBUG_PORT
ENV XDEBUG_MODE=$XDEBUG_MODE
