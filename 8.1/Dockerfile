FROM php:8.1.20-apache-buster

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
    libmagickcore-dev

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
    && docker-php-ext-enable \
      amqp \
      redis \
      uopz \
      imagick \
      xdebug \
    && rm -rf /tmp/pear

RUN composer global require --dev slope-it/clock-mock
# Node and NPM
RUN curl -sL https://deb.nodesource.com/setup_8.x > setup_node && chmod +x setup_node && ./setup_node
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
RUN printf '[PHP]\ndate.timezone = "UTC"\n' > /usr/local/etc/php/tzone.ini
RUN mkdir -p /etc/php/8.1/cli && ln -s /usr/local/etc/php/php.ini /etc/php/8.1/cli/php.ini
RUN mkdir -p /etc/php/8.1/apache2 && ln -s /usr/local/etc/php/php.ini /etc/php/8.1/apache2/php.ini
RUN echo "memory_limit=2048M" > /usr/local/etc/php/memory-limit.ini
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
