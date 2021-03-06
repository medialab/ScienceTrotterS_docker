FROM php:7.2-fpm-alpine

ARG DEVMODE
RUN if [ "$DEVMODE" = "true" ] ; then apk --no-cache add git unzip zip vim ; fi

RUN apk --no-cache add postgresql-dev bash\
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql 

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.17

COPY php-fpm.conf /usr/local/etc/php-fpm.d/sts.conf
COPY ./ScienceTrotterS_API /api
COPY ./ScienceTrotterS_backoffice /backoffice

RUN chown -R www-data:www-data /api /api/* /var/www/ /backoffice /backoffice*

WORKDIR /backoffice

RUN cp /backoffice/config/defines.default.php /backoffice/config/defines.php

WORKDIR /api

RUN composer install --no-dev
RUN cp /api/config/conf.default.php /api/config/conf.php

COPY ./phpcomposer.entrypoint /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
