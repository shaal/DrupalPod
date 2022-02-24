#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Set the default PHP version to 8.1
if [ -z "$DP_PHP_VERSION" ]; then
  DP_PHP_VERSION="8.1"
fi

# Misc housekeeping before start
ddev config global --instrumentation-opt-in=false
