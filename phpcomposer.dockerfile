FROM php:7-fpm

RUN apt-get update 
RUN apt-get -y --no-install-recommends install git unzip zip libpq-dev vim
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo pdo_pgsql
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer
COPY docker.conf /usr/local/etc/php-fpm.d/
COPY www.conf /usr/local/etc/php-fpm.d/
RUN touch /var/log/fpm-php.www.log
COPY ./ScienceTrotterS_API /api
COPY ./ScienceTrotterS_backoffice /backoffice
RUN usermod -u 1000 www-data
RUN chown -R www-data:www-data /api /api/* /var/www/ /backoffice /backoffice* /var/log/fpm-php.www.log
WORKDIR /backoffice
RUN cp /backoffice/config/defines.default.php /backoffice/config/defines.php
WORKDIR /api
RUN cp /api/config/conf.default.php /api/config/conf.php
USER www-data
