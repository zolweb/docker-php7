#!/usr/bin/env bash
set -o errexit

php_logs() {
    local conf_file="/usr/local/etc/php-fpm.d/www.conf"

    local log_dir="/var/log/php"
    local access_log_file="${log_dir}/access.log"
    local error_log_file="${log_dir}/error.log"

    mkdir -p ${log_dir} \
        && touch ${access_log_file} \
        && touch ${error_log_file};

    if [ ! -z "$UID" ] && [ ! -z "$GID" ]; then
        chown -R $UID:$GID ${log_dir}
    fi

    # The "c" supplementary letter is needed because the first letter will be cut at replacement.
    sed -i '/^;catch_workers_output/ccatch_workers_output = yes' ${conf_file} \
        && sed -i '/^;log_level/clog_level = debug' ${conf_file} \
        && sed -i '/^;listen/clisten = 9000' ${conf_file} \
        && sed -i '/^;access.log/caccess.log = /var/log/php/access.log' ${conf_file} \
        && sed -i '/^;php_flag\[display_errors\]/cphp_flag[display_errors] = off' ${conf_file} \
        && sed -i '/^;php_admin_value\[error_log\]/cphp_admin_value[error_log] = /var/log/php/error.log' ${conf_file} \
        && sed -i '/^;php_admin_flag\[log_errors\]/cphp_admin_flag[log_errors] = on' ${conf_file} \
        && sed -i '/^;clear_env/cclear_env = no' ${conf_file}
}

symfony_logs() {
    local html_dir="/var/www/html"
    local var_dir="${html_dir}/var"

    if [ ! -z "$UID" ] && [ ! -z "$GID" ]; then
        # To avoid permissions issues, create directly the /var/www/html/var directory and give it to $UID:$GID

        mkdir -p ${var_dir}
        chown -R $UID:$GID ${var_dir}
    fi

    setfacl -R  -m u:"www-data":rwX -m u:"root":rwX ${html_dir}
    setfacl -dR -m u:"www-data":rwX -m u:"root":rwX ${html_dir}
}

php_logs
symfony_logs

cron -L 15


# Add host ip as an alias in /etc/hosts to allow container to ping it without guessing it's ip everytime
HOST_MACHINE_IP=$(ip route | awk '/default/ { print $3 }')
echo "$HOST_MACHINE_IP host-machine" >> /etc/hosts


php-fpm --nodaemonize
