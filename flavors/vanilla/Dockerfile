ARG PHP_VERSION=8.2
ARG BUILD_ARCH="amd64"
ARG BUILD_FLAVOR=""
FROM fbraz3/php-fpm:$PHP_VERSION$BUILD_FLAVOR
USER root

ARG PHP_VERSION
ARG BUILD_ARCH
ENV DEBIAN_FRONTEND=noninteractive
ENV ENTRYPOINT_COMMAND="/usr/bin/tail -f /var/log/apache2/access.log"

COPY ../../assets/scripts/docker-entrypoint.sh /entrypoints/2-apache2-entrypoint.sh
COPY ../../assets/scripts/healthcheck.sh /healthcheck.sh
RUN chmod +x /entrypoints/2-apache2-entrypoint.sh /healthcheck.sh

#ensure php repo is up-to-date
RUN for i in {1..10}; do \
      add-apt-repository -y ppa:ondrej/php && break || sleep 10; \
    done

RUN apt-get update && apt-get -yq dist-upgrade;

RUN apt-get update --allow-releaseinfo-change && apt-get upgrade -y && \
    for i in {1..10}; do \
      apt-get install -fy apache2 && break || sleep 10; \
    done

COPY ../../assets/monit/apache2 /etc/monit/conf-enabled/
COPY ../../assets/apache2/000-default.conf /etc/apache2/sites-enabled/000-default.conf

RUN a2enmod rewrite; \
    a2enmod proxy; \
    a2enmod proxy_fcgi

RUN mkdir /etc/apache2/custom-conf/; \
    touch /etc/apache2/custom-conf/dummy.conf;

# Fix Permissions
RUN chown -R www-data. /var/log/apache2; \
    chown -R www-data. /var/lib/apache2; \
    chown -R www-data. /etc/apache2/custom-conf/; \
    chown -R www-data. /etc/apache2/sites-enabled/; \
    chown -R www-data. /etc/apache2/sites-available/; \
    rm -rf /var/run/apache2/apache2.pid; \
    chown www-data. /var/run/apache2/; \
    chown -R www-data. /var/run/php/ /run/php/ /var/log/php* /etc/php/$PHP_VERSION/fpm/ 2>/dev/null || true;

WORKDIR /app
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 CMD /healthcheck.sh
USER www-data
ENTRYPOINT ["/docker-entrypoint.sh"]
