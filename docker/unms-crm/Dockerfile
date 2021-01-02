FROM ubnt/unms-crm:3.2.7 as unms-crm
FROM php:7.3.21-fpm-alpine

LABEL maintainer="docker@bernardi.be"
LABEL version="3.2.7:1"

ARG NGINX_VERSION=1.18.0
ADD "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" \
    /tmp/nginx.tar.gz

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
