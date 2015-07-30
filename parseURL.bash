#!/usr/bin/env bash

#function to parse URL in accordance with https://tools.ietf.org/html/rfc3986
parseURL() {

  SCHEME="$(echo "$1" | grep -e '^[-+.0-9A-Za-z]\+://' | sed -e s,://.*,://,)"
  TMP_URL=${1#$SCHEME} #remove the protocol
  USERINFO="$(echo "${TMP_URL}" | grep -e '^[^\/]*@' | cut -d@ -f1)" 
  USERNAME="$(echo "${USERINFO}" | cut -d: -f1)"
  PASSWORD=${USERINFO#$USERNAME}
  TMP_URL=${TMP_URL#"${USERINFO}@"}
  SOCKET=$(echo "${TMP_URL}" | cut -d/ -f1)
  HOST=$(echo "${SOCKET}" | cut -d: -f1)
  PORT=$(echo "${SOCKET}" | grep : | sed -e s,^$HOST,,)

}

