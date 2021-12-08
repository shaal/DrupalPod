#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Set the default PHP version to 7.4
if [ -z "$DP_PHP_VERSION" ]; then
  DP_PHP_VERSION="7.4"
fi

# Misc housekeeping before start
# ddev config global --instrumentation-opt-in=false
