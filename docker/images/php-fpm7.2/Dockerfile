FROM php:7.2.12-fpm-stretch

MAINTAINER Nicolas BONNIOT <nicolas@devgiants.fr>

ARG UID
ARG TIMEZONE

#RUN apt-get clean && apt-get -y update && apt-get install -y locales curl software-properties-common git \
#  && locale-gen en_US.UTF-8
#RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php
#RUN apt-get update
#
## Installation PHP + extensions
#RUN apt-get install -y \
#    php7.1-fpm \
#    php7.1-mbstring \
#    php7.1-mcrypt \
#    php7.1-mysql \
#    php7.1-apcu \
#    php7.1-curl \
#    php7.1-intl \
#    php7.1-xdebug \
#    php7.1-xml \
#    php7.1-zip
#
## Configuration PHP (FPM, CLI) + extensions
#COPY config/etc/php/7.1/fpm/php-fpm.conf /etc/php/7.1/fpm/php-fpm.conf
#COPY config/etc/php/7.1/fpm/pool.d/www.conf /etc/php/7.1/fpm/pool.d/www.conf
#
#COPY config/etc/php/7.1/mods-available/php-custom.ini /etc/php/7.1/mods-available/php-custom.ini
#RUN ln -s /etc/php/7.1/mods-available/php-custom.ini /etc/php/7.1/fpm/conf.d/php-custom.ini
#RUN ln -s /etc/php/7.1/mods-available/php-custom.ini /etc/php/7.1/cli/conf.d/php-custom.ini
#
## La config de xdebug est automatiquement ajoutée dans fpm et cli
#COPY config/etc/php/7.1/mods-available/xdebug.ini /etc/php/7.1/mods-available/xdebug.ini

#RUN chown -R root:www-data /var/log/
#RUN chmod -R 775 /var/log

# Installation utilitaires
#RUN apt-get install -y git iproute2 vim


RUN apt-get update && apt-get install -y \
    openssl \
    git \
    unzip \
    nano

# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone \
&& printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini \
&& "date"

# Type docker-php-ext-install to see available extensions
RUN docker-php-ext-install pdo pdo_mysql

# Installation de composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

RUN usermod -u ${UID} www-data

WORKDIR /var/www/html

EXPOSE 9000

#RUN service php7.1-fpm start
#
#CMD php-fpm7.1 -F

