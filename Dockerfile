FROM php:7.4-fpm

LABEL maintainer="Johan Post <johan@chanto.nl>"

# Install package dependencies
RUN apt update && apt install -y ghostscript libmagickwand-dev libjpeg-dev libpng-dev libzip-dev git unzip mariadb-client

# Enable default PHP extensions
RUN docker-php-ext-install mysqli pdo_mysql pcntl bcmath zip soap intl gd exif opcache

# Add imagick from pecl
RUN pecl install imagick && echo 'extension=imagick.so' >> /usr/local/etc/php/php.ini

# Install nodejs & yarn
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && DEBIAN_FRONTEND=noninteractive apt-get install nodejs -yqq \
    && npm i -g npm \
    && curl -o- -L https://yarnpkg.com/install.sh | bash \
    && npm cache clean --force

# Install composer
ENV COMPOSER_HOME=/composer
ENV PATH=./vendor/bin:/composer/vendor/bin:/root/.yarn/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install wp cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp-cli.phar && \
    echo '#!/bin/sh' >> /usr/local/bin/wp && \
    echo 'wp-cli.phar "$@" --allow-root' >> /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

WORKDIR /app
