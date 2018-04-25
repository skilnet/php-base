FROM php:7.2.4-apache

RUN apt-get -qq update \
    && apt-get install --assume-yes --quiet --no-install-recommends \
        ca-certificates curl git \
        libcurl4-gnutls-dev openssl libssl-dev libpng-dev libxml++2.6-dev libxslt-dev \
        libfreetype6-dev libjpeg62-turbo-dev coreutils vim mysql-client \
        libicu-dev zlib1g-dev \
    && rm -r /var/lib/apt/lists/*

RUN rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime \
    && date

RUN docker-php-ext-install pdo pdo_mysql pcntl session xml curl sockets zip bcmath \
                           iconv soap mbstring exif xsl opcache posix iconv intl > /dev/null \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ > /dev/null \
    && docker-php-ext-install gd > /dev/null \
    && docker-php-source delete > /dev/null

RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin/ --filename=composer


RUN ln -s /etc/apache2/mods-available/expires.load /etc/apache2/mods-enabled/
RUN ln -s /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled/
RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/

RUN groupadd -g 1000 appuser && \
     useradd -r -u 1000 -g appuser appuser

COPY vhost.conf /etc/apache2/sites-available/000-default.conf
COPY php.ini /usr/local/etc/php
RUN sed -i "s/80/8000/g" /etc/apache2/ports.conf
RUN mkdir -p /var/run/apache2 \
    && chown -R appuser: /var/run/apache2/ \
    && chown -R appuser: /var/www
EXPOSE 8000

USER appuser
RUN alias sf="php bin/console"
WORKDIR "/var/www"
CMD ["apache2-foreground"]
