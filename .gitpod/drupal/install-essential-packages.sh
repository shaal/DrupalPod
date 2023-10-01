#!/usr/bin/env bash
set -eu -o pipefail

# Initialize all variables with null if they do not exist
: "${DEBUG_SCRIPT:=}"
: "${GITPOD_HEADLESS:=}"
: "${DP_EXTRA_DEVEL:=}"
: "${DP_EXTRA_ADMIN_TOOLBAR:=}"
: "${DEVEL_PACKAGE:=}"
: "${ADMIN_TOOLBAR_PACKAGE:=}"

if [ -n "$DEBUG_SCRIPT" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Install devel and admin_toolbar modules
if [ "$DP_EXTRA_DEVEL" != '1' ]; then
    DEVEL_PACKAGE=
fi
if [ "$DP_EXTRA_ADMIN_TOOLBAR" != '1' ]; then
    ADMIN_TOOLBAR_PACKAGE=
fi

cd "${GITPOD_REPO_ROOT}" && time ddev . composer require --dev "drupal/core-dev":* "phpspec/prophecy-phpunit":^2 -W --no-install
cd "${GITPOD_REPO_ROOT}" && time ddev . composer require "drush/drush":^11 "drupal/coder" "$DEVEL_PACKAGE" "$ADMIN_TOOLBAR_PACKAGE"
