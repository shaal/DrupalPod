#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Set up ddev for use on gitpod

DDEV_DIR="${GITPOD_REPO_ROOT}/.ddev"
# Generate a config.gitpod.yaml that adds the gitpod
# proxied ports so they're known to ddev.
shortgpurl="${GITPOD_WORKSPACE_URL#'https://'}"

# Set the default PHP version to 7.4
if [ -z "$DP_PHP_VERSION" ]; then
  DP_PHP_VERSION="7.4"
fi

cat <<CONFIGEND > "${DDEV_DIR}"/config.gitpod.yaml
#ddev-gitpod-generated
php_version: "$DP_PHP_VERSION"
use_dns_when_possible: false
# Throwaway ports, otherwise Gitpod throw an error 'port needs to be > 1024'
router_http_port: "8888"
router_https_port: "8889"
additional_fqdns:
- 8888-${shortgpurl}
- 8025-${shortgpurl}
- 8036-${shortgpurl}
CONFIGEND

# We need host.docker.internal inside the container,
# So add it via docker-compose.host-docker-internal.yaml
hostip=$(awk "\$2 == \"$HOSTNAME\" { print \$1; }" /etc/hosts)

cat <<COMPOSEEND >"${DDEV_DIR}"/docker-compose.host-docker-internal.yaml
#ddev-gitpod-generated
version: "3.6"
services:
  web:
    environment:
      - DRUSH_OPTIONS_URI=$(gp url 8080)
    extra_hosts:
    - "host.docker.internal:${hostip}"
    # This adds 8080 on the host (bound on all interfaces)
    # It goes directly to the web container without
    # ddev-nginx
    ports:
    - 8080:80
COMPOSEEND

# Misc housekeeping before start
ddev config global --instrumentation-opt-in=true --router-bind-all-interfaces=true
