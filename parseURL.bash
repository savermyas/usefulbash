#!/usr/bin/env bash

#function to parse URL in accordance with https://tools.ietf.org/html/rfc3986
parseURL() {

  URL_SCHEME="$(echo "$1" | grep -e '^[-+.0-9A-Za-z]\+://' | sed -e s,://.*,,)"
  TMP_URL=${1#$URL_SCHEME:\/\/} #remove the protocol
  URL_AUTHORITY="$(echo "${TMP_URL}" | tr -s \# ? | tr -s \/ ? | cut -d? -f1 )"
  URL_USERINFO="$(echo "${URL_AUTHORITY}" | grep @ | cut -d@ -f1)" 
  URL_USERNAME="$(echo "${URL_USERINFO}" | cut -d: -f1)"
  URL_PASSWORD=${URL_USERINFO#$URL_USERNAME:}
  URL_SOCKET=${URL_AUTHORITY#$URL_USERINFO@}
  URL_HOST=$(echo "${URL_SOCKET}" | cut -d: -f1)
  URL_PORT=$(echo "${URL_SOCKET#$URL_HOST}" | sed -e s,^:,, )
  TMP_URL=${TMP_URL#"${URL_AUTHORITY}"}
  URL_PATH="${TMP_URL}"
}

