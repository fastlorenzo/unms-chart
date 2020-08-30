#!/bin/bash

echo "Running docker-entrypoint $*"

echo "Sentry release: $SENTRY_RELEASE"

HOME_DIR="/home/app"
UNMS_DIR="${HOME_DIR}/unms"
DATA_DIR="${UNMS_DIR}/data"
PUBLIC_DIR="${UNMS_DIR}/public"
USE_ALTERNATIVE_CERT_DIR="${USE_ALTERNATIVE_CERT_DIR:-"false"}"

set -e
dirs=(
  ${UNMS_DIR}/supportinfo
  ${DATA_DIR}/images
  ${DATA_DIR}/firmwares
  ${DATA_DIR}/logs
  ${DATA_DIR}/config-backups
  ${DATA_DIR}/unms-backups
  ${DATA_DIR}/import
  ${DATA_DIR}/update
  ${DATA_DIR}/cloud-access
  ${DATA_DIR}/control
)

if [ "${USE_ALTERNATIVE_CERT_DIR}" != "true" ]; then
  dirs+=("${DATA_DIR}/cert")
fi

links=(
  "${PUBLIC_DIR}/site-images:${DATA_DIR}/images"
  "${PUBLIC_DIR}/firmwares:${DATA_DIR}/firmwares"
)

# allow the container to be started with `--user`
if [ "$1" = 'index.js' ] && [ "$(id -u)" = '0' ]; then
  echo "Running UNMS container as root"
  deluser node || true
  UNMS_USER_ID="${UNMS_USER_ID:-1000}"
  echo "Creating service user app (uid=${UNMS_USER_ID})"
  adduser -D -s /bin/false -u "${UNMS_USER_ID}" app -H -h /home/app || echo "User already exists"
  echo "Creating directories and setting permissions"

  # cli/user.js is only accessible by root
  chown root ${UNMS_DIR}/cli/user.js
  chmod 700 ${UNMS_DIR}/cli/user.js

  # create dir for Letsencrypt challenge
  # until we figure out how to move it under home dir (UNMS-1073)
  leDir="/home/app/letsencrypt"
  mkdir -p "${leDir}"
  chown -R app "${leDir}"
  chmod -R u+rwX,g-rwx,o-rwx "${leDir}"

  for dir in "${dirs[@]}"; do
    echo "creating ${dir}"
    mkdir -p "${dir}";
    echo "setting permissions on ${dir}"
    chown -R app "${dir}"
    chmod -R u+rwX,g-rwx,o-rwx "${dir}"
  done

  for i in "${links[@]}"; do
    IFS=':' read -ra LINK <<< "${i}"
    linkFrom=${LINK[0]}
    linkTo=${LINK[1]}
    if [ -L "${linkFrom}" ] || [ -d "${linkFrom}" ]; then rm -rf "${linkFrom}"; fi
    echo "Linking ${linkFrom} -> ${linkTo}"
    ln -s "${linkTo}" "${linkFrom}"
  done

  echo "Stepping down from root: su-exec \"$0\" \"$*\""
  exec su-exec app "$0" "$@"
fi

buildVersion="$(cat package.json | grep '"version":' | sed 's/^.*".*":.*"\([^"]*\)".*/\1/' || echo "unknown")"
buildCommit="$(cat build-info.json | grep '"commit":' | sed 's/^.*".*":.*"\([^"]*\)".*/\1/' || echo "unknown")"
buildTime="$(cat build-info.json | grep '"time":' | sed 's/^.*".*":.*"\([^"]*\)".*/\1/' || echo "unknown")"
echo "Version: ${buildVersion}+${buildCommit}.${buildTime}"

# wait for postgres to start
echo "Waiting for database containers"
while ! nc -z "${UNMS_PG_HOST}" "${UNMS_PG_PORT}"; do sleep 1; done

# remove timescaledb extension
psql --host "${UNMS_PG_HOST}" --port "${UNMS_PG_PORT}" --username "${UNMS_PG_USER}" --password "${UNMS_PG_PASSWORD}" --dbname unms -c "DROP EXTENSION IF EXISTS timescaledb CASCADE" || true

while ! nc -z "${UNMS_RABBITMQ_HOST}" "${UNMS_RABBITMQ_PORT}"; do sleep 1; done
while ! nc -z "${UNMS_REDISDB_HOST}" "${UNMS_REDISDB_PORT}"; do sleep 1; done
#while ! nc -z "${UNMS_SIRIDB_HOST}" "${UNMS_SIRIDB_PORT}"; do sleep 1; done

# trigger rewrite of Redis AOF file (see https://groups.google.com/forum/#!topic/redis-db/4p9ZvwS0NjQ)
redis-cli -h "${UNMS_REDISDB_HOST}" BGREWRITEAOF

echo "Restoring backups and/or running migrations"
yarn prestart

# unfortunately we cannot change --max_old_space_size at runtime so it is necessary to pull the value from the config
# like this. Better ideas are welcomed.
MEMORY_LIMIT_API=$(node -e 'const config = require("./config"); process.stdout.write(String(config.apiMemoryLimit))')

echo "Exec $@ with memory limit ${MEMORY_LIMIT_API}"
exec node --max_old_space_size="${MEMORY_LIMIT_API}" "$@"
