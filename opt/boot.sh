#!/bin/bash

if [ -n "$DEBUG" ]; then
  set -x
fi

if [[ -z "$SCALINGO_POSTGRESQL_URL" ]]; then
  echo >&2 "The environment variable SCALINGO_POSTGRESQL_URL must be set. The default user should be updated with the CREATEROLE privilege."
  exit -1
fi
export PROMSCALE_DB_URI=$SCALINGO_POSTGRESQL_URL

if [[ -z "$PROMSCALE_WEB_AUTH_USERNAME" ]] || [[ -z "$PROMSCALE_WEB_AUTH_PASSWORD" ]]; then
  echo >&2 "The environment variables PROMSCALE_WEB_AUTH_USERNAME and PROMSCALE_WEB_AUTH_PASSWORD are mandatory to configure the Basic Auth"
  exit -1
fi

/app/bin/promscale -web.listen-address=0.0.0.0:$PORT
