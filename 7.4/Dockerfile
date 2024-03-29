ARG ARCH=
FROM ${ARCH}debian:buster

MAINTAINER Ghislain GAUCHER <ghislain@lancaster-solutions.com>
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# SSH
COPY ./config/ssh/config /root/.ssh/
RUN apt -y update
RUN apt -y upgrade
# Packages
RUN apt install -y --no-install-recommends \
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
    ghostscript
# Node and NPM
ARG NODE_MAJOR=20
RUN mkdir -p /etc/apt/keyrings \
 && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
 && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
 && apt-get update -y \
 && apt-get install nodejs -y \
 && npm install -g npm-cli-login
# Amqproxy
RUN wget -qO- https://packagecloud.io/cloudamqp/amqproxy/gpgkey | apt-key add - \
 && echo "deb https://packagecloud.io/cloudamqp/amqproxy/ubuntu/ bionic main" | tee /etc/apt/sources.list.d/amqproxy.list \
 && apt -y update \
 && apt install -y amqproxy
# PHP
RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - \
 && echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/php.list \
 && apt -y update \
 && apt install -y --no-install-recommends \
    php7.4 \
    php7.4-bcmath \
    php7.4-curl \
    php7.4-dev \
    php7.4-gd \
    php7.4-iconv \
    php7.4-imap \
    php7.4-intl \
    php7.4-mbstring \
    php7.4-mysql \
    php7.4-redis \
    php7.4-soap \
    php7.4-xdebug \
    php7.4-xml \
    php7.4-zip \
    php7.4-imagick \
    php7.4-amqp \
 && update-alternatives --set php /usr/bin/php7.4
# PECL
RUN ln -s /bin/sed /usr/bin/sed
RUN apt install -y --no-install-recommends php-pear php7.4-dev \
 && pecl install timecop-beta
# Apache
RUN apt install -y --no-install-recommends apache2 libapache2-mod-php7.4 \
 && a2dismod mpm_event php7.4 \
 && a2enmod mpm_prefork php7.4 rewrite ssl macro headers proxy proxy_http proxy_wstunnel \
 && mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.dist \
 && rm /etc/apache2/conf-enabled/* /etc/apache2/sites-enabled/* \
# PHP ini
 && echo "date.timezone=Europe/Paris" > /etc/php/7.4/cli/conf.d/timezone.ini \
 && echo "date.timezone=Europe/Paris" > /etc/php/7.4/apache2/conf.d/timezone.ini \
 && echo "memory_limit=2048M" > /etc/php/7.4/cli/conf.d/memory-limit.ini \
 && echo "memory_limit=2048M" > /etc/php/7.4/apache2/conf.d/memory-limit.ini \
 && echo "extension=timecop.so" > /etc/php/7.4/cli/conf.d/20-timecop.ini \
 && echo "extension=timecop.so" > /etc/php/7.4/apache2/conf.d/20-timecop.ini \
 && echo "upload_max_filesize=20M" > /etc/php/7.4/cli/conf.d/20-upload-limits.ini \
 && echo "post_max_size=30M" >> /etc/php/7.4/cli/conf.d/20-upload-limits.ini \
 && echo "upload_max_filesize=20M" > /etc/php/7.4/apache2/conf.d/20-upload-limits.ini \
 && echo "post_max_size=30M" >> /etc/php/7.4/apache2/conf.d/20-upload-limits.ini \
 && echo '[xdebug]' >> /etc/php/7.4/apache2/conf.d/xdebug.ini \
 && echo 'xdebug.client_host=${LOCAL_IP}' >> /etc/php/7.4/apache2/conf.d/xdebug.ini \
 && echo 'xdebug.client_port=${XDEBUG_PORT}' >> /etc/php/7.4/apache2/conf.d/xdebug.ini \
 && echo 'xdebug.idekey=docker' >> /etc/php/7.4/apache2/conf.d/xdebug.ini \
 && echo 'xdebug.start_with_request=yes' >> /etc/php/7.4/apache2/conf.d/xdebug.ini \
 && echo 'xdebug.mode=${XDEBUG_MODE}' >> /etc/php/7.4/apache2/conf.d/xdebug.ini \
 && echo 'xdebug.discover_client_host=false' >> /etc/php/7.4/apache2/conf.d/xdebug.ini \
 && echo 'xdebug.output_dir=/tmp' >> /etc/php/7.4/apache2/conf.d/xdebug.ini \
 && echo 'xdebug.log=/tmp/xdebug_apache.log' >> /etc/php/7.4/apache2/conf.d/xdebug.ini \
 && echo 'xdebug.level=0' >> /etc/php/7.4/apache2/conf.d/xdebug.ini \
 && echo '[xdebug]' >> /etc/php/7.4/cli/conf.d/xdebug.ini \
 && echo 'xdebug.client_host=${LOCAL_IP}' >> /etc/php/7.4/cli/conf.d/xdebug.ini \
 && echo 'xdebug.client_port=${XDEBUG_PORT}' >> /etc/php/7.4/cli/conf.d/xdebug.ini \
 && echo 'xdebug.idekey=docker' >> /etc/php/7.4/cli/conf.d/xdebug.ini \
 && echo 'xdebug.start_with_request=yes' >> /etc/php/7.4/cli/conf.d/xdebug.ini \
 && echo 'xdebug.mode=${XDEBUG_MODE}' >> /etc/php/7.4/cli/conf.d/xdebug.ini \
 && echo 'xdebug.discover_client_host=false' >> /etc/php/7.4/cli/conf.d/xdebug.ini \
 && echo 'xdebug.output_dir=/tmp' >> /etc/php/7.4/cli/conf.d/xdebug.ini \
 && echo 'xdebug.log=/tmp/xdebug_cli.log' >> /etc/php/7.4/cli/conf.d/xdebug.ini \
 && echo 'xdebug.level=0' >> /etc/php/7.4/cli/conf.d/xdebug.ini \
# Bashrc
 && echo "alias ls='ls --color=auto'" >> .bashrc \
 && echo "alias ll='ls -halF'" >> .bashrc
#cleanup
RUN apt clean -y \
 && rm -rf /var/lib/apt/lists/*
# APACHE
COPY ./config/apache2.conf /etc/apache2/apache2.conf
COPY ./apache2-foreground /usr/local/bin/
#GIT
COPY ./config/gitconfig /root/.gitconfig

EXPOSE 80
WORKDIR /var/www
ENTRYPOINT ["apache2-foreground"]

ARG XDEBUG_PORT=9003
ARG XDEBUG_MODE="develop,debug"
ENV XDEBUG_PORT=$XDEBUG_PORT
ENV XDEBUG_MODE=$XDEBUG_MODE
