#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ] || [ -n "$GITPOD_HEADLESS" ]; then
    set -x
fi

# Install Drush + Coder
cd "${GITPOD_REPO_ROOT}" && time ddev composer require drush/drush drupal/coder

# Download extra modules
if [ -n "$DP_EXTRA_DEVEL" ]; then
    cd "${GITPOD_REPO_ROOT}" && \
    ddev composer require "$DEVEL_PACKAGE"
fi
if [ -n "$DP_EXTRA_ADMIN_TOOLBAR" ]; then
    cd "${GITPOD_REPO_ROOT}" && \
    ddev composer require "$ADMIN_TOOLBAR_PACKAGE"
fi
