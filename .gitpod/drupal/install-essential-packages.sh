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

if [ "$DP_EXTRA_COMPOSER_DRUPAL_LENIENT" != '1' ]; then
    unset COMPOSER_DRUPAL_LENIENT
fi

cd "${GITPOD_REPO_ROOT}" && time ddev composer require --dev drupal/core-dev:* -W --no-install
cd "${GITPOD_REPO_ROOT}" && time ddev composer require --dev phpspec/prophecy-phpunit:^2 --no-install
cd "${GITPOD_REPO_ROOT}" && time ddev composer require drush/drush:^11.0 drupal/coder:^8.3 "$DEVEL_PACKAGE" "$ADMIN_TOOLBAR_PACKAGE" "$COMPOSER_DRUPAL_LENIENT" --no-install
cd "${GITPOD_REPO_ROOT}" && time ddev composer update
