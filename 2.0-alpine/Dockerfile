FROM php:7.0.11-fpm-alpine

# Install tzdata and change to Europe/Paris
RUN  set -x && \
    apk --update add tzdata && \
    ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
    date && \
    rm -rf /var/cache/apk/*

# Install tools...
RUN set -x && \
    apk --update add \
      mysql-client \
      sudo \
      zlib-dev \
      wget \
      icu \
      icu-libs \
      icu-dev \
      freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
    && docker-php-ext-configure intl \
    && NPROC=$(getconf _NPROCESSORS_ONLN) \
    && docker-php-ext-install -j${NPROC}
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install \
       iconv \
       apcu \
       mcrypt \
       intl \
       pdo \
       pdo_mysql \
       mbstring \
       opcache \
       zip \
       gd \
       exif \
    && rm -rf /var/cache/apk/*


COPY conf/php.ini /usr/local/etc/php/php.ini

COPY script/start.sh /root/start.sh
RUN chmod +x /root/start.sh

CMD ["/root/start.sh"]
