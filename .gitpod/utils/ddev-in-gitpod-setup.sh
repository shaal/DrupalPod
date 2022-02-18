#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Set the default PHP version to 8.0
if [ -z "$DP_PHP_VERSION" ]; then
  DP_PHP_VERSION="8.1"
fi

DDEV_DIR="${GITPOD_REPO_ROOT}/.ddev"
# Generate a config.gitpod.yaml to allow for different PHP versions.

cat <<CONFIGEND > "${DDEV_DIR}"/config.gitpod.yaml
#ddev-gitpod-generated
php_version: "$DP_PHP_VERSION"
CONFIGEND

# Misc housekeeping before start
ddev config global --instrumentation-opt-in=false
