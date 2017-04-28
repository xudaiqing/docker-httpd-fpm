FROM httpd:alpine

	# Bring in gettext so we can get `envsubst`, then throw
	# the rest away. To do this, we need to install `gettext`
	# then move `envsubst` out of the way so `gettext` can
	# be deleted completely, then move `envsubst` back.
RUN	apk add --no-cache --virtual .gettext gettext \
	&& mv /usr/bin/envsubst /tmp/ \
	&& runDeps="$( \
		scanelf --needed --nobanner /tmp/envsubst \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)" \
	&& apk add --no-cache --virtual .rundeps $runDeps \
	&& apk del .gettext \
	&& mv /tmp/envsubst /usr/local/bin/


COPY httpd.conf /usr/local/apache2/conf/httpd.conf

COPY httpd-vhosts.template /usr/local/apache2/conf/extra/httpd-vhosts.template

ENV PHP_HOST=localhost
ENV WEB_ROOT=/var/www/html

VOLUME /var/www/html

CMD /bin/sh -c "envsubst '\${PHP_HOST}, \${WEB_ROOT}' < /usr/local/apache2/conf/extra/httpd-vhosts.template > /usr/local/apache2/conf/extra/httpd-vhosts.conf && httpd-foreground"
