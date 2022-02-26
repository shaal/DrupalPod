#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Install devel and admin_toolbar modules
if [ "$DP_EXTRA_DEVEL" != '1' ]; then
    DEVEL_PACKAGE=''
fi
if [ "$DP_EXTRA_ADMIN_TOOLBAR" != '1' ]; then
    ADMIN_TOOLBAR_PACKAGE=''
fi

cd "${GITPOD_REPO_ROOT}" && time ddev composer require drush/drush drupal/coder "$DEVEL_PACKAGE" "$ADMIN_TOOLBAR_PACKAGE"
