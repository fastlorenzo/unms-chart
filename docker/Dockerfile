FROM ubnt/unms:1.3.0-dev as unms
FROM node:10.19.0-buster-slim

LABEL maintainer="docker@bernardi.be"
LABEL version="1.3.0-dev:1"

# start ubnt/unms dockerfile #
RUN mkdir -p /home/app/unms

WORKDIR /home/app/unms

# Copy UNMS app from offical image since the source code is not published at this time
COPY --from=unms /home/app/unms /home/app/unms

RUN apt-get update && apt-get install -y git python build-essential libvips-dev libcairo-gobject2 libglib2.0-dev libcap2-bin dumb-init netcat postgresql-client --no-install-recommends

RUN rm -rf node_modules \
    && sed -i 's/"@sentry\/cli": "1.49.0"/"@sentry\/cli": "1.55.2"/g' package.json \
    && CHILD_CONCURRENCY=$(nproc) npm install --production --no-cache --ignore-engines \
    && mkdir -p -m 777 "$HOME/unms/public/site-images" \
    && mkdir -p -m 777 "$HOME/unms/data/config-backups" \
    && mkdir -p -m 777 "$HOME/unms/data/unms-backups" \
    && mkdir -p -m 777 "$HOME/unms/data/import"

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# end ubnt/unms dockerfile #

RUN apt-get autoremove --purge -y build-essential libvips-dev libcairo-gobject2 libglib2.0-dev git python \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ENV HOME=/home/app \
    PATH=/home/app/unms/node_modules/.bin:$PATH \
    HTTP_PORT=8081 \
    WS_PORT=8082 \
    UNMS_RABBITMQ_HOST=unms-rabbitmq \
    UNMS_RABBITMQ_PORT=5672 \
    UNMS_SIRIDB_HOST=unms-siridb \
    UNMS_SIRIDB_PORT=9000 \
    UNMS_REDISDB_HOST=unms-redis \
    UNMS_REDISDB_PORT=6379 \
    UNMS_PG_HOST=unms-postgres \
    UNMS_PG_PORT=5432 \
    UNMS_FLUENTD_HOST=unms-fluentd \
    UNMS_FLUENTD_PORT=24224 \
    UNMS_NGINX_HOST=unms-nginx \
    UNMS_NGINX_PORT=12345 \
    NODE_ENV=production

EXPOSE 8081 8082

RUN setcap cap_net_raw=pe /usr/local/bin/node

ENTRYPOINT ["/usr/bin/dumb-init", "docker-entrypoint.sh"]
