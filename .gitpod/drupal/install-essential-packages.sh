#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi
set -eu -o pipefail

# Install devel and admin_toolbar modules
if [ "$DP_EXTRA_DEVEL" != '1' ]; then
    unset DEVEL_PACKAGE
fi
if [ "$DP_EXTRA_ADMIN_TOOLBAR" != '1' ]; then
    unset ADMIN_TOOLBAR_PACKAGE
fi

cd "${GITPOD_REPO_ROOT}" && time ddev . composer require --dev "drupal/core-dev":* "phpspec/prophecy-phpunit":^2 -W --no-install
cd "${GITPOD_REPO_ROOT}" && time ddev . composer require "drush/drush":^11 "drupal/coder" "$DEVEL_PACKAGE" "$ADMIN_TOOLBAR_PACKAGE"
