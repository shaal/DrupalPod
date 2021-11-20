#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Set up ddev for use on gitpod

DDEV_DIR="${GITPOD_REPO_ROOT}/.ddev"
# Generate a config.gitpod.yaml that adds the gitpod
# proxied ports so they're known to ddev.

# Set the default PHP version to 7.4
if [ -z "$DP_PHP_VERSION" ]; then
  DP_PHP_VERSION="7.4"
fi

cat <<CONFIGEND > "${DDEV_DIR}"/config.gitpod.yaml
#ddev-gitpod-generated
php_version: "$DP_PHP_VERSION"

bind_all_interfaces: true
host_webserver_port: 8080
# Will ignore the direct-bind https port, which will land on 2222
host_https_port: 2222
# Allows local db clients to run
host_db_port: 3306
# Assign MailHog port
host_mailhog_port: "8025"
# Assign phpMyAdmin port
host_phpmyadmin_port: 8036

web_environment:
- DRUSH_OPTIONS_URI=https://127.0.0.1:8080
CONFIGEND

# Misc housekeeping before start
ddev config global --instrumentation-opt-in=true --omit-containers=ddev-router
