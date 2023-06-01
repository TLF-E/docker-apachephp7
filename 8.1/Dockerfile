ARG ARCH=
FROM ${ARCH}debian:buster

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
    ghostscript
# Node and NPM
RUN curl -sL https://deb.nodesource.com/setup_8.x > setup_node && chmod +x setup_node && ./setup_node
RUN apt-get install -y npm nodejs
RUN apt-get update -y
RUN npm install -g npm-cli-login
# Amqproxy
RUN curl -s https://packagecloud.io/install/repositories/cloudamqp/amqproxy/script.deb.sh | bash

# PHP
RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
RUN echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/php.list
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends \
    php8.1 \
    php8.1-bcmath \
    php8.1-curl \
    php8.1-dev \
    php8.1-gd \
    php8.1-iconv \
    php8.1-imap \
    php8.1-intl \
    php8.1-mbstring \
    php8.1-mysql \
    php8.1-redis \
    php8.1-soap \
    php8.1-xdebug \
    php8.1-xml \
    php8.1-zip \
    php8.1-imagick \
    php8.1-amqp \
 && update-alternatives --set php /usr/bin/php8.1
# PECL
RUN apt-get install -y --no-install-recommends php8.1-dev
# V2-8301 [PHP 8] Replace timecop with different solution
# slope-it/clock-mock 0.2.0 requires ext-uopz >=6.1.1 but it is not present.
RUN apt-get update -y
RUN apt-get install php-pear
RUN pecl channel-update pecl.php.net
RUN pear config-set php_ini /etc/php/8.1/apache2/php.ini
RUN ln -s /bin/sed /usr/bin/sed
RUN pecl install uopz
RUN echo extension=\"uopz.so\" > /etc/php/8.1/mods-available/uopz.ini
RUN ln -s /etc/php/8.1/mods-available/uopz.ini /etc/php/8.1/cli/conf.d/20-uopz.ini
RUN composer global require --dev slope-it/clock-mock
# CELB-599 zookeeper
RUN apt-get -y install libzookeeper-mt2 libzookeeper-mt-dev
RUN pecl install zookeeper-1.2.1
RUN apt-get remove --purge -y libzookeeper-mt-dev
RUN echo extension=\"zookeeper.so\" > /etc/php/8.1/mods-available/zookeeper.ini
RUN ln -s /etc/php/8.1/mods-available/zookeeper.ini /etc/php/8.1/cli/conf.d/20-zookeeper.ini
# Apache
RUN apt-get install -y --no-install-recommends apache2 libapache2-mod-php8.1
RUN a2dismod mpm_event php8.1
RUN a2enmod mpm_prefork php8.1 rewrite ssl macro headers proxy proxy_http proxy_wstunnel
RUN mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.dist
RUN rm /etc/apache2/conf-enabled/* /etc/apache2/sites-enabled/*
# PHP ini
RUN echo "date.timezone=UTC" > /etc/php/8.1/cli/conf.d/timezone.ini
RUN echo "date.timezone=UTC" > /etc/php/8.1/apache2/conf.d/timezone.ini
RUN echo "memory_limit=4096M" > /etc/php/8.1/cli/conf.d/memory-limit.ini
RUN echo "memory_limit=4096M" > /etc/php/8.1/apache2/conf.d/memory-limit.ini
# Bashrc
RUN echo "alias ls='ls --color=auto'" >> .bashrc
RUN echo "alias ll='ls -halF'" >> .bashrc
#cleanup
RUN apt clean -y
RUN rm -rf /var/lib/apt/lists/*
# APACHE
COPY ./config/apache2.conf /etc/apache2/apache2.conf
COPY ./apache2-foreground /usr/local/bin/
#GIT
COPY ./config/gitconfig /root/.gitconfig

EXPOSE 80
WORKDIR /var/www
ENTRYPOINT ["apache2-foreground"]
