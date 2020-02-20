# docker-php7
A docker image with php 7 and extensions (apc, apcu, intl, mcrypt,...)

See docker hub image [zolweb/php7](https://hub.docker.com/r/zolweb/php7/)


| Version        | Docker                       | Symfony recommended version | Main changes |
|:--------------:|:----------------------------:|:---------------------------:|:------------:|
| 1.0            | php:7.0-fpm                  | 2.x -> 3.x                  ||
| 1.1            | php:7.0-fpm                  | 2.x -> 3.x                  | Add with libfreetype6-dev, libjpeg62-turbo-dev and libpng12-dev |
| 2.0-alpine     | php:7.0.11-fpm-alpine        | 2.x -> 3.x                  | Switch to php alpine as test, add logrotate |
| 2.1-alpine     | php:7.0.11-fpm-alpine        | 2.x -> 3.x                  | Fixes |
| 2.2-alpine     | php:7.1.1-fpm-alpine         | 2.x -> 3.x                  | Upgrade to php 7.1 |
| 3.0            | php:7.1-fpm                  | 4.x                         | Re switch to debian base, update conf for SF4 |
| 4.0            | php:7.2-fpm                  | 4.x                         | Upgrade to php 7.2 |
| 4.1            | php:7.2-fpm                  | 4.x                         | Add mariadb-client |
| 4.2            | php:7.2-fpm                  | 4.x                         | Add composer to image |
| 5.0            | php:7.4-fpm                  | 4.x                         | Upgrade to php 7.4 |
| 5.1            | php:7.4-fpm                  | 4.x                         | Add composer to image |
