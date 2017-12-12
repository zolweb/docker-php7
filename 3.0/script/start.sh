#!/usr/bin/env bash
set -o errexit

__DIR__="$(cd "$(dirname "${0}")"; echo $(pwd))"
__BASE__="$(basename "${0}")"
__FILE__="${__DIR__}/${__BASE__}"

symfony_acls() {
    echo "Setting ACLs"

    if [ "$(uname)" == "Darwin" ]; then
        chmod -R +a "www-data allow delete,write,append,file_inherit,directory_inherit" /var/www/html
    else

        setfacl -R  -m u:"www-data":rwX /var/www/html
        setfacl -dR -m u:"www-data":rwX /var/www/html
    fi
}

php_logs() {
  local conf_file="/usr/local/etc/php-fpm.d/www.conf"

  local log_dir="/var/log/php"
  local access_log_file="${log_dir}/fpm-access.log"
  local error_log_file="${log_dir}/fpm-error.log"

  mkdir -p ${log_dir} \
    && touch ${access_log_file} \
    && touch ${error_log_file} \
    && chown -R www-data:www-data ${log_dir} \

  sed -i '/^;catch_workers_output/catch_workers_output = yes' ${conf_file} \
    && sed -i '/^;access.log/access.log = /var/log/php/fpm-access.log' ${conf_file} \
    && sed -i '/^;php_flag\[display_errors\]/php_flag[display_errors] = off' ${conf_file} \
    && sed -i '/^;php_admin_value\[error_log\]/php_admin_value[error_log] = /var/log/php/fpm-error.log' ${conf_file} \
    && sed -i '/^;php_admin_flag\[log_errors\]/php_admin_flag[log_errors] = on' ${conf_file}
}

#symfony_acls
#php_logs

#crond &
php-fpm --nodaemonize
