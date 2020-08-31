FROM ubnt/unms-crm:3.3.0-dev as unms-crm
FROM php:7.3.21-fpm-alpine

LABEL maintainer="docker@bernardi.be"
LABEL version="3.3.0-dev:1"

# ENV PHPIZE_DEPS="autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c"
# CMD ["/bin/sh"]
#
# RUN apk add --update --no-cache ca-certificates curl tar xz openssl
#
# RUN /bin/sh -c set -eux; \
#     addgroup -g 82 -S www-data; \
#     adduser -u 82 -D -S -G www-data www-data
#
# ENV PHP_INI_DIR=/usr/local/etc/php
#
# RUN /bin/sh -c set -eux; \
#     mkdir -p "$PHP_INI_DIR/conf.d"; \
#     [ ! -d /var/www/html ]; \
#     mkdir -p /var/www/html; \
#     chown www-data:www-data /var/www/html; \
#     chmod 777 /var/www/html
#
# ENV PHP_EXTRA_CONFIGURE_ARGS="--enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --disable-cgi"
# ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
# ENV PHP_CPPFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
# ENV PHP_LDFLAGS="-Wl,-O1 -pie"
# ENV GPG_KEYS="CBAF69F173A0FEA4B537F470D66C9593118BCCB6 F38252826ACD957EF380D39F2F7956BC5DA04B5D"
# ENV PHP_VERSION="7.3.21"
# ENV PHP_URL=https://www.php.net/distributions/php-7.3.21.tar.xz PHP_ASC_URL=https://www.php.net/distributions/php-7.3.21.tar.xz.asc
# ENV PHP_SHA256=4c8b065746ef776d84b7ae47908c21a79e3d4704b86b60d816716b8697c58ce9 PHP_MD5=
#
# RUN /bin/sh -c set -eux; \
#     apk add --no-cache --virtual .fetch-deps gnupg; \
#     mkdir -p /usr/src; cd /usr/src; \
#     curl -fsSL -o php.tar.xz "$PHP_URL"; \
#     if [ -n "$PHP_SHA256" ]; then \
#       echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c -; \
#     fi; \
#     if [ -n "$PHP_MD5" ]; then \
#       echo "$PHP_MD5 *php.tar.xz" | md5sum -c -; \
#     fi; \
#     if [ -n "$PHP_ASC_URL" ]; then \
#       curl -fsSL -o php.tar.xz.asc "$PHP_ASC_URL"; \
#       export GNUPGHOME="$(mktemp -d)"; \
#       for key in $GPG_KEYS; do \
#         gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
#       done; \
#       gpg --batch --verify php.tar.xz.asc php.tar.xz; \
#       gpgconf --kill all; \
#       rm -rf "$GNUPGHOME"; \
#     fi; \
#     apk del --no-network .fetch-deps
#
# COPY --from=unms-crm /usr/local/bin/docker-php-source /usr/local/bin/
# RUN /bin/sh -c set -eux; \
#     apk add --no-cache --virtual .build-deps \
#       $PHPIZE_DEPS \
#       argon2-dev \
#       coreutils \
#       curl-dev \
#       libedit-dev \
#       libsodium-dev \
#       libxml2-dev \
#       openssl-dev \
#       sqlite-dev \
#     ; \
#       export CFLAGS="$PHP_CFLAGS" \
#       CPPFLAGS="$PHP_CPPFLAGS" \
#       LDFLAGS="$PHP_LDFLAGS" \
#     ; \
#     docker-php-source extract; \
#     cd /usr/src/php; \
#     gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
#     ./configure \
#       --build="$gnuArch" \
#       --with-config-file-path="$PHP_INI_DIR" \
#       --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
#       --enable-option-checking=fatal \
#       --with-mhash \
#       --enable-ftp \
#       --enable-mbstring \
#       --enable-mysqlnd \
#       --with-password-argon2 \
#       --with-sodium=shared \
#       --with-pdo-sqlite=/usr \
#       --with-sqlite3=/usr \
#       --with-curl \
#       --with-libedit \
#       --with-openssl \
#       --with-zlib \
#       $(test "$gnuArch" = 's390x-linux-musl' && echo '--without-pcre-jit') \
#       ${PHP_EXTRA_CONFIGURE_ARGS:-} \
#     ; \
#     make -j "$(nproc)"; \
#     find -type f -name '*.a' -delete; \
#     make install; \
#     find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true;  make clean; \
#     cp -v php.ini-* "$PHP_INI_DIR/"; \
#     cd /; \
#     docker-php-source delete; \
#     runDeps="$( \
#       scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
#       | tr ',' '\n' \
#       | sort -u \
#       | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
#     )"; \
#     apk add --no-cache $runDeps; \
#     apk del --no-network .build-deps; \
#     pecl update-channels; \
#     rm -rf /tmp/pear ~/.pearrc; \
#     php --version
#
# COPY --from=unms-crm /usr/local/bin/docker-php-* /usr/local/bin/
#
# RUN /bin/sh -c docker-php-ext-enable sodium
# ENTRYPOINT ["docker-php-entrypoint"]
# WORKDIR /var/www/html
# RUN /bin/sh -c set -eux; \
#     cd /usr/local/etc; \
#     if [ -d php-fpm.d ]; then \
#       sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
#       cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
#     else \
#       mkdir php-fpm.d; \
#       cp php-fpm.conf.default php-fpm.d/www.conf; \
#       { \
#         echo '[global]'; \
#         echo 'include=etc/php-fpm.d/*.conf'; \
#       } | tee php-fpm.conf; \
#     fi; \
#     { \
#       echo '[global]'; \
#       echo 'error_log = /proc/self/fd/2'; \
#       echo; \
#       echo '; https://github.com/docker-library/php/pull/725#issuecomment-443540114'; \
#       echo 'log_limit = 8192'; \
#       echo; \
#       echo '[www]'; \
#       echo '; if we send this to /proc/self/fd/1, it never appears'; \
#       echo 'access.log = /proc/self/fd/2'; \
#       echo; \
#       echo 'clear_env = no'; \
#       echo; \
#       echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
#       echo 'catch_workers_output = yes'; \
#       echo 'decorate_workers_output = no'; \
#     } | tee php-fpm.d/docker.conf; \
#     { \
#       echo '[global]'; \
#       echo 'daemonize = no'; \
#       echo; \
#       echo '[www]'; \
#       echo 'listen = 9000'; \
#     } | tee php-fpm.d/zz-docker.conf
# STOPSIGNAL SIGQUIT
#
# EXPOSE 9000
# CMD ["php-fpm"]
EXPOSE 2055/udp 443 80 81
ENV TERM=xterm \
    POSTGRES_USER=ucrm \
    POSTGRES_DB=ucrm \
    POSTGRES_PASSWORD=aircrm1 \
    POSTGRES_HOST=postgresql \
    POSTGRES_PORT=5432 \
    POSTGRES_PORT_BOUNCER=6543 \
    POSTGRES_SCHEMA=ucrm \
    UNMS_POSTGRES_SCHEMA=unms \
    MAILER_HOST=127.0.0.1 \
    MAILER_USERNAME=null \
    MAILER_PASSWORD=null \
    MAILER_AUTH_MODE=null \
    MAILER_ENCRYPTION=null \
    MAILER_PORT=null \
    MAILER_TRANSPORT=smtp \
    RABBITMQ_HOST=rabbitmq \
    RABBITMQ_PORT=5672 \
    RABBITMQ_USER=guest \
    RABBITMQ_PASSWORD=guest \
    NETFLOW_HOST=0.0.0.0 \
    NETFLOW_PORT=2055 \
    SECRET=changeThisSecretKey \
    SYMFONY_ENV=prod \
    FORCE_HTTPS=1 \
    TRUSTED_PROXIES=all \
    UCRM_USERNAME=null \
    UCRM_PASSWORD=null \
    UCRM_DISK_USAGE_DIRECTORY=/ \
    UAS_INSTALLATION= \
    NGINX_VERSION=1.18.0 \
    UNMS_HOST=unms \
    UNMS_PORT=443 \
    UNMS_TOKEN= \
    UNMS_VERSION= \
    SUSPEND_PORT=81 \
    CLOUD=0 \
    CLOUD_SMTP_PORT=null \
    CLOUD_SMTP_USERNAME=null \
    CLOUD_SMTP_PASSWORD=null \
    CLOUD_SMTP_HOSTNAME=null \
    CLOUD_SMTP_TLS_ALLOW_UNAUTHORIZED=null \
    CLOUD_SMTP_SECURITY_MODE=null \
    CLOUD_MAPS_API_KEY=null \
    PUBLIC_HTTPS_PORT=443 \
    CLOUD_STRIPE_CONNECT_ONBOARDING_URL= \
    CLOUD_STRIPE_CONNECT_PROXY_SECRET_KEY= \
    CLOUD_STRIPE_CONNECT_PROXY_URL= \
    CLOUD_STRIPE_CONNECT_PUBLISHABLE_KEY=

WORKDIR /usr/src/ucrm

COPY --from=unms-crm /etc/apk/repositories /etc/apk/repositories
COPY --from=unms-crm /usr/local/bin/crm-* /usr/local/bin
COPY --from=unms-crm /usr/src/ucrm/scripts scripts

RUN apk add --update --no-cache \
    gettext \
    jq \
    && chmod -R 775 /usr/local/bin/crm-*

RUN apk add --no-cache --update \
      ca-certificates \
      curl \
      bash \
      openssl \
    && touch /etc/ssl/openssl.cnf \
    && /usr/src/ucrm/scripts/update-certificates.sh

RUN apk add --no-cache --update \
      wget \
      pcre \
      zlib \
    && apk add --no-cache --virtual .build-deps \
      build-base \
      linux-headers \
      openssl-dev \
      pcre-dev \
      zlib-dev \
    && cd /tmp \
    && wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
    && tar xzf nginx-${NGINX_VERSION}.tar.gz \
    && cd /tmp/nginx-${NGINX_VERSION} \
    && ./configure \
      --prefix=/etc/nginx \
      --sbin-path=/usr/sbin/nginx \
      --conf-path=/etc/nginx/nginx.conf \
      --error-log-path=/data/log/ucrm/nginx-src.log \
      --pid-path=/var/run/nginx.pid \
      --lock-path=/var/run/nginx.lock \
      --user=nginx \
      --group=nginx \
      --with-debug \
      --with-threads \
      --with-file-aio \
      --with-http_ssl_module \
      --with-http_v2_module \
      --with-http_realip_module \
      --with-http_addition_module \
      --with-http_sub_module \
      --with-http_gunzip_module \
      --with-http_gzip_static_module \
      --with-http_auth_request_module \
      --with-http_random_index_module \
      --with-http_secure_link_module \
      --with-http_slice_module \
      --with-http_stub_status_module \
      --http-log-path=/data/log/ucrm/php/access.log \
      --http-client-body-temp-path=/var/cache/nginx/client_temp \
      --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
      --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
      --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
      --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
      --with-mail \
      --with-mail_ssl_module \
      --with-stream \
      --with-stream_ssl_module \
      --with-stream_realip_module \
    && make -j$(nproc) \
    && make install \
    && rm -rf /tmp/nginx-${NGINX_VERSION}* \
    && cd /usr/src/ucrm \
    && sed -i -e 's/#access_log  logs\/access.log  main;/access_log \/dev\/stdout;/' -e 's/#error_log  logs\/error.log  notice;/error_log stderr notice;/' /etc/nginx/nginx.conf \
    && adduser -D nginx \
    && mkdir -p /var/cache/nginx \
    && apk del .build-deps

RUN apk upgrade --no-cache --update \
    && apk add --no-cache --update \
      bzip2 \
      dbus \
      file \
      fontconfig \
      gmp \
      icu \
      libgmpxx \
      libpng \
      libpq \
      libwebp \
      libxml2 \
      libxml2-utils \
      libzip \
      logrotate \
      make \
      nodejs \
      nodejs-npm \
      patch \
      'postgresql-client<13' \
      'postgresql-libs<13' \
      re2c \
      su-exec \
      supervisor \
      ttf-freefont \
      tzdata \
      yarn \
      dumb-init

RUN apk upgrade --no-cache --update \
    && apk add --no-cache --update \
      gnu-libiconv

ENV LD_PRELOAD="/usr/lib/preloadable_libiconv.so php"

COPY --from=unms-crm /usr/local/etc/php/php.ini /usr/local/etc/php/php.ini
COPY --from=unms-crm /usr/local/etc/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

RUN apk upgrade --no-cache --update \
    && apk add --no-cache --update --virtual .php-dependencies ${PHPIZE_DEPS} \
    && pecl channel-update pecl.php.net

RUN pecl install apcu ds \
    && docker-php-ext-enable apcu ds \
    && apk del .php-dependencies \
    && docker-php-source delete

RUN apk add --no-cache --update --virtual .php-dependencies \
      bzip2-dev \
      freetype-dev \
      imap-dev \
      libjpeg-turbo-dev \
      libpng-dev \
      libwebp-dev \
      libzip-dev \
      gmp-dev \
      icu-dev \
      libxml2-dev \
      'postgresql-dev<13' \
    && docker-php-ext-configure gd \
      --with-gd \
      --with-freetype-dir=/usr/include/ \
      --with-png-dir=/usr/include/ \
      --with-webp-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure imap \
      --with-imap-ssl \
    && docker-php-ext-configure zip \
      --with-libzip=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
      bcmath \
      bz2 \
      exif \
      gd \
      gmp \
      imap \
      intl \
      opcache \
      pdo_pgsql \
      soap \
      sockets \
      sysvmsg \
      sysvsem \
      sysvshm \
      zip

COPY --from=unms-crm /usr/src/ucrm/Makefile ./
COPY --from=unms-crm /usr/src/ucrm/composer.* ./
COPY --from=unms-crm /usr/src/ucrm/package.json ./
COPY --from=unms-crm /usr/src/ucrm/yarn.lock ./

COPY --from=unms-crm /usr/src/ucrm/app/config/ app/config
COPY --from=unms-crm /tmp/crontabs/ /tmp/crontabs/
COPY --from=unms-crm /tmp/DoctrineMigrations/ /tmp/DoctrineMigrations/
COPY --from=unms-crm /etc/nginx/ /etc/nginx/
COPY --from=unms-crm /root/.ssh/config /root/.ssh/config
COPY --from=unms-crm /tmp/supervisord/ /tmp/supervisord/
COPY --from=unms-crm /tmp/supervisor.d/ /tmp/supervisor.d/
COPY --from=unms-crm /etc/logrotate.d/ /etc/logrotate.d/
COPY --from=unms-crm /usr/src/ucrm/src src/
COPY --from=unms-crm /usr/src/ucrm/web web/
COPY --from=unms-crm /usr/src/ucrm/websockets websockets/
COPY --from=unms-crm /usr/src/ucrm/app app/
COPY --from=unms-crm /usr/src/ucrm/patch patch/

RUN /usr/src/ucrm/scripts/dirs.sh
RUN apk upgrade --no-cache --update \
    && apk add --no-cache --update git \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && composer global require hirak/prestissimo \
    && composer install --classmap-authoritative --no-dev --no-interaction \
    && app/console assets:install --symlink web \
    && composer clear-cache \
    && rm /usr/bin/composer \
    && apk del git

RUN find . -name '.*' -maxdepth 1 -delete \
    && rm -f /etc/logrotate.d/nginx \
    && cp web/assets/fonts/lato/fonts/*.ttf /usr/share/fonts/TTF/ \
    && fc-cache -f -v \
    && touch /tmp/UCRM_init.log

RUN mkdir -p /var/log/nginx \
    && mkdir -p /var/lib/nginx \
    && mkdir -p /run/nginx \
    && mkdir -p /etc/nginx/enabled-servers \
    && mkdir -p /usr/src/ucrm/app/cache/prod \
    && mkdir -p /usr/src/ucrm/app/data \
    && mkdir -p /usr/src/ucrm/web/media \
    && mkdir -p /usr/src/ucrm/web/uploads \
    && mkdir -p /usr/src/ucrm/web/_plugins \
    && chown -R nginx:nginx /var/lib/nginx \
    && chown -R nginx:nginx /usr/src/ucrm/app \
    && chown -R nginx:nginx /usr/src/ucrm/scripts \
    && chown -R nginx:nginx /usr/src/ucrm/src \
    && chown -R nginx:nginx /usr/src/ucrm/web \
    && chown nginx:nginx /usr/src/ucrm/* \
    && chown nginx:nginx /usr/src/ucrm \
    && chmod -R 775 /var/lib/nginx \
    && chmod -R 775 /usr/src/ucrm/app/cache \
    && chmod -R 775 /usr/src/ucrm/app/EmailQueue \
    && chmod -R 775 /usr/src/ucrm/app/data \
    && chmod -R 775 /usr/src/ucrm/web/media \
    && chmod -R 775 /usr/src/ucrm/web/uploads \
    && chmod -R 775 /usr/src/ucrm/web/assets \
    && chmod -R 775 /usr/src/ucrm/web/_plugins \
    && chmod -R 775 /usr/src/ucrm/scripts \
    && chmod -R 777 /tmp \
    && rm -rf /usr/src/ucrm/app/cache/prod/* \
    && rm -rf /usr/src/ucrm/web/crm \
    && ln -s /usr/src/ucrm/web /usr/src/ucrm/web/crm
VOLUME [/data]
ENTRYPOINT [ "dumb-init", "--", "make" ]
