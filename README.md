# docker-php7
A docker image with php 7 and extensions (apc, apcu, intl, mcrypt,...)

See docker hub image [zolweb/php7](https://hub.docker.com/r/zolweb/php7/)


| Version        | Docker                       | Symfony recommended version |
|:--------------:|:----------------------------:|:---------------------------:|
| 1.0            | php:7.0-fpm                  | 2.x -> 3.x                  |
| 1.1            | php:7.0-fpm                  | 2.x -> 3.x                  |
| 2.0-alpine     | php:7.0.11-fpm-alpine        | 2.x -> 3.x                  |
| 2.1-alpine     | php:7.0.11-fpm-alpine        | 2.x -> 3.x                  |
| 2.2-alpine     | php:7.1.1-fpm-alpine         | 2.x -> 3.x                  |
| 3.0            | php:7.1-fpm                  | 4.x                         |
| 4.0            | php:7.2-fpm                  | 4.x                         |
| 7.4.0          | php:7.4-rc-fpm               |  (do not use before 7.4.0)  |

1.1 comes with libfreetype6-dev, libjpeg62-turbo-dev and libpng12-dev comparing to 1.0.
From 2.x, logrotate have been added
