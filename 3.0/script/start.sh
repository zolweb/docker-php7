#!/usr/bin/env bash
set -o errexit

php_logs() {
    if [ ! -z "$UID" ] && [ ! -z "$GID" ]; then
        local conf_file="/usr/local/etc/php-fpm.d/www.conf"

        local log_dir="/var/log/php"
        local access_log_file="${log_dir}/access.log"
        local error_log_file="${log_dir}/error.log"

        mkdir -p ${log_dir} \
            && touch ${access_log_file} \
            && touch ${error_log_file} \
            && chown -R $UID:$GID ${log_dir}

        # The "c" supplementary letter is needed because the first letter will be cut at replacement.
        sed -i '/^;catch_workers_output/ccatch_workers_output = yes' ${conf_file} \
            && sed -i '/^;log_level/clog_level = debug' ${conf_file} \
            && sed -i '/^;listen/clisten = 9000' ${conf_file} \
            && sed -i '/^;access.log/caccess.log = /var/log/php/access.log' ${conf_file} \
            && sed -i '/^;php_flag\[display_errors\]/cphp_flag[display_errors] = off' ${conf_file} \
            && sed -i '/^;php_admin_value\[error_log\]/cphp_admin_value[error_log] = /var/log/php/error.log' ${conf_file} \
            && sed -i '/^;php_admin_flag\[log_errors\]/cphp_admin_flag[log_errors] = on' ${conf_file} \
            && sed -i '/^;clear_env/cclear_env = no' ${conf_file}
    fi

    setfacl -R  -m u:"www-data":rwX -m u:"root":rwX /var/www/html
    setfacl -dR -m u:"www-data":rwX -m u:"root":rwX /var/www/html
}

php_logs

cron -L 15
php-fpm --nodaemonize
