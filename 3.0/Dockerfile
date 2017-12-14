FROM php:7.1-fpm

RUN apt-get update -qq && apt-get install -qqy \
    sudo \
    wget \
    git \
    apt-utils \
    acl \
    openssl \
    nano \
    htop \
    unzip \
    tzdata \
    netcat \
    cron \
    apt-transport-https lsb-release ca-certificates \
    software-properties-common python-software-properties \
    && echo "Europe/Paris" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata \
    && echo 'alias ll="ls -lah --color=auto"' >> /etc/bash.bashrc

ENV PHP_VERSION 7.1

RUN mkdir /run/php \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
    && apt-get update -qq && apt-get upgrade -qqy \
    && apt-get install -qqy \
    php$PHP_VERSION-intl \
    php$PHP_VERSION-mysql \
    php$PHP_VERSION-curl \
    php$PHP_VERSION-gd \
    php$PHP_VERSION-xml  \
    php$PHP_VERSION-opcache \
    php$PHP_VERSION-dev \
    php$PHP_VERSION-bcmath

# Custom logrotate configuration for symfony
ADD logrotate/symfony /etc/logrotate.d/symfony
ADD logrotate/php /etc/logrotate.d/php
ADD logrotate/cron /etc/periodic/daily/logrotate-cron

# Custom PHP (and apc) configuration
COPY php/*.ini /usr/local/etc/php/conf.d/
COPY php/php.ini /usr/local/etc/php/php.ini

COPY script/start.sh /root/start.sh
COPY script/entry.sh /root/entry.sh

# Make sure every user can start the container
RUN chmod +x /root/start.sh /root/entry.sh \
  && chmod +x /etc/periodic/daily/logrotate-cron

WORKDIR /var/www/html

ENTRYPOINT ["/root/entry.sh"]
CMD ["/root/start.sh"]
