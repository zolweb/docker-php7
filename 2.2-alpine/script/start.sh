#!/usr/bin/env bash
set -o errexit

__DIR__="$(cd "$(dirname "${0}")"; echo $(pwd))"
__BASE__="$(basename "${0}")"
__FILE__="${__DIR__}/${__BASE__}"

# Add if not exists an environment variable to the php fpm configuration
php_env_variable()
{
    local key=$1
    local value=$2

    # Force conf to use ENV from container
    # E.G.: Set SYMFONY_ENV="$SYMFONY_ENV"
    value="\"\$$key\""

    # Check whether variable already exists
    if grep -q $key /usr/local/etc/php-fpm.d/www.conf; then
        # Reset variable
        sed -i "s/^env\[$key.*/env[$key] = $value/g" /usr/local/etc/php-fpm.d/www.conf
    else
        # Add variable
        echo "Set $key=$value in www.conf"
        echo "env[$key] = $value" >> /usr/local/etc/php-fpm.d/www.conf
    fi
}

symfony_env_variables()
{
    # Grep for Symfony variables
    for _curVar in `env | grep ^SYMFONY_ | awk -F = '{print $1}'`;do
        php_env_variable ${_curVar} ${!_curVar}
    done
}

symfony_cache_clear_alias() {
    echo "alias sfcc='sudo -E -u www-data app/console ca:cl'" >> ~/.bashrc
}


symfony_acls() {

    echo "Setting ACLs"
    [ -z $CUSTOM_UID ] && echo "Environment variable CUSTOM_UID not found" && exit 1

    if [ "$(uname)" == "Darwin" ]; then
        chmod -R +a "$CUSTOM_UID allow delete,write,append,file_inherit,directory_inherit" /var/www/html/var
        chmod -R +a "www-data allow delete,write,append,file_inherit,directory_inherit" /var/www/html/var
    else
        setfacl -R -m u:"$CUSTOM_UID":rwX -m u:"www-data":rwX /var/www/html/var
        setfacl -dR -m u:"$CUSTOM_UID":rwX -m u:"www-data":rwX /var/www/html/var
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

  sed -i '/^;catch_workers_output/ccatch_workers_output = yes' "/usr/local/etc/php-fpm.d/www.conf" \
    && sed -i '/^;access.log/caccess.log = /var/log/php/fpm-access.log' "/usr/local/etc/php-fpm.d/www.conf" \
    && sed -i '/^;php_flag\[display_errors\]/cphp_flag[display_errors] = off' "/usr/local/etc/php-fpm.d/www.conf" \
    && sed -i '/^;php_admin_value\[error_log\]/cphp_admin_value[error_log] = /var/log/php/fpm-error.log' "/usr/local/etc/php-fpm.d/www.conf" \
    && sed -i '/^;php_admin_flag\[log_errors\]/cphp_admin_flag[log_errors] = on' "/usr/local/etc/php-fpm.d/www.conf"
}

symfony_acls
symfony_env_variables
symfony_cache_clear_alias
php_logs

crond &
php-fpm
