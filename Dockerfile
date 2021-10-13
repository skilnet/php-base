FROM --platform=linux/amd64 php:8.0.11-fpm-buster

RUN apt-get -qq update \
        && apt-get install --assume-yes --quiet --no-install-recommends \
            ca-certificates git curl libpng-dev libfreetype6-dev libjpeg62-turbo-dev \
            libicu-dev libxml++2.6-dev unzip libzip-dev libpq5 libpq-dev procps vim default-mysql-client \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ > /dev/null \
    && docker-php-ext-install bcmath  exif gd intl pdo_mysql pdo_pgsql pgsql soap zip xml mysqli redis \
    && docker-php-ext-enable opcache \
    && pecl install xdebug \
    && docker-php-source delete > /dev/null \
# remove dev-dependencies
    && apt-get remove --assume-yes --quiet libpng-dev libfreetype6-dev libpq-dev libjpeg62-turbo-dev libicu-dev libxml++2.6-dev libzip-dev python3 \
    && rm -r /var/lib/apt/lists/*

# Configure time
RUN rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime \
# Install composer
    && curl -sS https://getcomposer.org/installer | \
        php -- --install-dir=/usr/bin/ --filename=composer \
# Setup user/group
    && groupadd -g 1000 appuser  \
    && useradd -r -u 1000 -g appuser appuser \
    && mkdir -p /home/appuser && chown appuser:appuser /home/appuser

COPY php.ini /usr/local/etc/php
COPY www.conf /usr/local/etc/php-fpm.d/zz-docker.conf
RUN chown -R appuser: /var/www
EXPOSE 8443 8000ª

WORKDIR "/var/www"
CMD ["php-fpm"]
