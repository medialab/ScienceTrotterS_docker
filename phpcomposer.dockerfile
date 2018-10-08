FROM php:7.2-fpm

ARG DEVMODE
RUN if [ "$DEVMODE" = "true" ] ; then apt-get update && apt-get -y --no-install-recommends install git unzip zip vim ; fi

RUN apt-get update \
    && apt-get -y --no-install-recommends install libpq-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo pdo_pgsql

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer

COPY php-fpm.conf /usr/local/etc/php-fpm.d/sts.conf
COPY ./ScienceTrotterS_API /api
COPY ./ScienceTrotterS_backoffice /backoffice

RUN usermod -u 1000 www-data
RUN chown -R www-data:www-data /api /api/* /var/www/ /backoffice /backoffice*

WORKDIR /backoffice

RUN cp /backoffice/config/defines.default.php /backoffice/config/defines.php

WORKDIR /api

RUN cp /api/config/conf.default.php /api/config/conf.php

USER www-data
