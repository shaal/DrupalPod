#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Install devel and admin_toolbar modules
if [ "$DP_EXTRA_DEVEL" != '1' ]; then
    unset DEVEL_PACKAGE
fi
if [ "$DP_EXTRA_ADMIN_TOOLBAR" != '1' ]; then
    unset ADMIN_TOOLBAR_PACKAGE
fi

if [ "$DP_CORE_VERSION" = "11.x" ]; then
    DRUSH_PACKAGE="drush/drush:^12.0"
    unset DEVEL_PACKAGE
    unset ADMIN_TOOLBAR_PACKAGE
else
    DRUSH_PACKAGE="drush/drush:^11.0"
fi

cd "${GITPOD_REPO_ROOT}" && time ddev composer require --dev drupal/core-dev:* -W --no-install
cd "${GITPOD_REPO_ROOT}" && time ddev composer require --dev phpspec/prophecy-phpunit:^2 --no-install
cd "${GITPOD_REPO_ROOT}" && time ddev . composer require "$DRUSH_PACKAGE" drupal/coder:^8.3 "$DEVEL_PACKAGE" "$ADMIN_TOOLBAR_PACKAGE" --no-install
# cd "${GITPOD_REPO_ROOT}" && time ddev composer update
