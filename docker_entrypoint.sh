#!/bin/sh
set -e

if ! [ -z $PHP_SOCKET ]; then
  export PHP_SOCKET="unix:$PHP_SOCKET|"
fi

sed -i 's@\$PHP_SOCKET@'"$PHP_SOCKET"'@g' /usr/local/apache2/conf/extra/httpd-vhosts.template

envsubst '\${PHP_HOST}, \${WEB_ROOT}' < /usr/local/apache2/conf/extra/httpd-vhosts.template \
                                      > /usr/local/apache2/conf/extra/httpd-vhosts.conf

echo "$@"
exec "$@"
