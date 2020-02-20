#!/usr/bin/env bash

wait_single_host() {
  local host=$1
  shift
  local port=$1
  shift

  while ! nc ${host} ${port} > /dev/null 2>&1 < /dev/null; do echo "   --> Waiting for ${host}:${port}" && sleep 1; done;
}

wait_all_hosts() {
  if [ ! -z "$WAIT_FOR_HOSTS" ]; then
    local separator=':'
    for _HOST in $WAIT_FOR_HOSTS ; do
        IFS="${separator}" read -ra _HOST_PARTS <<< "$_HOST"
        wait_single_host "${_HOST_PARTS[0]}" "${_HOST_PARTS[1]}"
    done
  fi
}

main () {
    # Install blackfire automatically
    # Don't install it if it's already installed
    if [ ! -f /usr/local/etc/php/conf.d/blackfire.ini ];
        then
        version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;")
        curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version > /dev/null
        tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp
        chmod 644 /tmp/blackfire-*.so
        mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so
        printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > /usr/local/etc/php/conf.d/blackfire.ini
    fi
}

wait_all_hosts
main

bash -c "$*"