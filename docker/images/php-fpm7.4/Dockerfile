FROM php:7.4-fpm

MAINTAINER Nicolas BONNIOT <nicolas@devgiants.fr>

ARG UID
ARG TIMEZONE
ARG PROJECT_NAME


RUN apt-get update && apt-get install -y \
    openssl \
    git \
    unzip \
    nano \
    curl \
    wget \
    gnupg \
    apt-transport-https \
    python3 \
    # For imagick
    libmagickwand-dev --no-install-recommends \
    zlib1g-dev \
    libzip-dev

# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone \
&& printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini \
&& "date"

RUN pecl install xdebug-2.9.8

# Type docker-php-ext-install to see available extensions
RUN docker-php-ext-install pdo pdo_mysql zip xml
RUN docker-php-ext-enable xdebug

RUN pecl install imagick && docker-php-ext-enable imagick

#COPY config/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Composer install
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

# Node install, for Encore
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# Yarn install
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

# Symfony CLI install
RUN wget https://get.symfony.com/cli/installer -O - | bash
RUN cp /root/.symfony/bin/symfony /usr/local/bin/symfony

RUN usermod -u ${UID} www-data

WORKDIR /var/www/html

EXPOSE 9000

#RUN service php7.1-fpm start
#
#CMD php-fpm7.1 -F

