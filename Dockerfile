FROM silintl/php7
MAINTAINER Michael Garrez <michael.garrez@gmail.com>

ENV REFRESHED_AT 2015-05-11

RUN usermod -u 1000 www-data
RUN mkdir -p /var/www/html
RUN apt-get update
RUN yes | apt-get upgrade
ENV TERM xterm

EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]
