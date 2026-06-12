#!/bin/sh
set -eu

if [ "${SPRING_DATASOURCE_PASSWORD:-}" = "" ] && [ -n "${SPRING_DATASOURCE_PASSWORD_FILE:-}" ]; then
  if [ -f "${SPRING_DATASOURCE_PASSWORD_FILE}" ]; then
    export SPRING_DATASOURCE_PASSWORD="$(cat "${SPRING_DATASOURCE_PASSWORD_FILE}")"
  else
    echo "ERROR: SPRING_DATASOURCE_PASSWORD_FILE apunta a '${SPRING_DATASOURCE_PASSWORD_FILE}', pero el fichero no existe."
    exit 1
  fi
fi




if [ "${STORAGE_S3_ACCESS_KEY:-}" = "" ] && [ -f "/run/secrets/minio_access_key" ]; then
  export STORAGE_S3_ACCESS_KEY="$(cat /run/secrets/minio_access_key)"
fi

if [ "${STORAGE_S3_SECRET_KEY:-}" = "" ] && [ -f "/run/secrets/minio_secret_key" ]; then
  export STORAGE_S3_SECRET_KEY="$(cat /run/secrets/minio_secret_key)"
fi


exec java ${JAVA_OPTS:-} -jar /app/app.jar