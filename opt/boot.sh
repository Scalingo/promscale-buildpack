#!/bin/bash

if [ -n "$DEBUG" ]; then
  set -x
fi

if [[ -z "$PROMSCALE_DB_URI" ]]; then
  echo >&2 "The environment variable PROMSCALE_DB_URI containing the *admin* credentials must be set"
  exit -1
fi

if [[ -z "$PROMSCALE_AUTH_USERNAME" ]] || [[ -z "$PROMSCALE_AUTH_PASSWORD" ]]; then
  echo >&2 "The environment variables PROMSCALE_AUTH_USERNAME and PROMSCALE_AUTH_PASSWORD are mandatory to configure the Basic Auth"
  exit -1
fi

/app/bin/promscale -web-listen-address=0.0.0.0:$PORT
