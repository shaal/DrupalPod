#!/usr/bin/env bash

# Set up ddev for use on gitpod

set -eu -o pipefail

DDEV_DIR="$(pwd)/.ddev"
mkdir -p $DDEV_DIR

# Generate a config.gitpod.yaml that adds the gitpod
# proxied ports so they're known to ddev.
shortgpurl="${GITPOD_WORKSPACE_URL#'https://'}"

cat <<CONFIGEND > ${DDEV_DIR}/config.gitpod.yaml
#ddev-gitpod-generated
router_http_port: 8080
router_https_port: 8443
use_dns_when_possible: false

additional_fqdns:
- 8080-${shortgpurl}
- 8025-${shortgpurl}
- 8036-${shortgpurl}
CONFIGEND

# We need host.docker.internal inside the container,
# So add it via docker-compose.host-docker-internal.yaml
hostip=$(awk "\$2 == \"$HOSTNAME\" { print \$1; }" /etc/hosts)

cat <<COMPOSEEND >${DDEV_DIR}/docker-compose.host-docker-internal.yaml
#ddev-gitpod-generated
version: "3.6"
services:
  web:
    extra_hosts:
    - "host.docker.internal:${hostip}"
COMPOSEEND

# Misc housekeeping before start
ddev config global --instrumentation-opt-in=true --router-bind-all-interfaces=true

ddev start