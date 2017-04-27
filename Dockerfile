FROM httpd:alpine


COPY httpd.conf /usr/local/apache2/conf/httpd.conf

COPY httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf


VOLUME /var/www/html
