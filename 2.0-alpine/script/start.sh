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


symfony_env_variables
symfony_cache_clear_alias

php-fpm
